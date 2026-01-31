--[[
DaVinci Resolve: Export Markers to YouTube Chapters
----------------------------------------------------------------
Description:
  Exports timeline markers to the clipboard formatted as YouTube chapters.
  Works in DaVinci Resolve Free & Studio (uses Lua + PowerShell hack).

What it does:
  1. Scans the current timeline for markers.
  2. Formats them as "MM:SS Name" (or HH:MM:SS).
  3. Auto-adds "00:00 Start" if missing.
  4. Auto-numbers empty markers so YouTube accepts them.
  5. Copies the result to Clipboard and shows a popup.
]]--

local resolve = Resolve()
if not resolve then resolve = app:GetResolve() end

local projectManager = resolve:GetProjectManager()
local project = projectManager:GetCurrentProject()
local timeline = project:GetCurrentTimeline()

if not timeline then return end

local framerate = timeline:GetSetting('timelineFrameRate')
local fps = tonumber(framerate) or 24.0
local startFrame = timeline:GetStartFrame()
local markers = timeline:GetMarkers()

if not markers or next(markers) == nil then return end

-- Base64 function (Windows safe encoding for PowerShell transfer)
local b64 = function(str)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    return ((str:gsub('.', function(x)
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#str%3+1])
end

local sorted_frames = {}
for k in pairs(markers) do table.insert(sorted_frames, k) end
table.sort(sorted_frames)

local output_lines = {}

-- 00:00 FIX: YouTube requires chapters to start at 00:00
if (sorted_frames[1] - startFrame) > 0 then
    table.insert(output_lines, "00:00 Start")
end

for i, frameId in ipairs(sorted_frames) do
    local markerData = markers[frameId]
    local name = markerData['name'] or ""

    -- 1. FILTER: Remove default names like "Marker 1"
    if string.match(name, "^Marker %d+$") then
        name = ""
    end

    -- 2. LOGIC: If name is empty, use NUMBER (1, 2, 3...) so YouTube accepts it
    if name == "" then
        name = tostring(i)
    end

    -- Time calculation
    local relativeFrames = frameId - startFrame
    local totalSeconds = math.floor(relativeFrames / fps)
    local s = totalSeconds % 60
    local m = math.floor(totalSeconds / 60) % 60
    local h = math.floor(totalSeconds / 3600)

    local timestamp = (h > 0) and string.format("%02d:%02d:%02d", h, m, s) or string.format("%02d:%02d", m, s)

    -- Add line to output
    table.insert(output_lines, timestamp .. " " .. name)
end

local final_text = table.concat(output_lines, "\n")

-- Send to Clipboard + Show Popup (PowerShell)
-- We use Base64 to prevent issues with special characters and newlines in cmd
local encoded = b64(final_text)
os.execute('start /B powershell -NoProfile -Command "$bytes = [Convert]::FromBase64String(\'' .. encoded .. '\'); $text = [Text.Encoding]::UTF8.GetString($bytes); Set-Clipboard -Value $text; [System.Windows.Forms.MessageBox]::Show(\'Done! Chapters copied to clipboard.\', \'DaVinci Export\')"')
