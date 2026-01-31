"""
GPX HDOP Fixer (Any Folder)
----------------------------------------------------------------
Description:
  Fixes GPX files exported from GPX file by removing decimal
  precision from <hdop> tags (e.g. 5.92 -> 5).

  What it does:
  1. Scans the given folder.
  2. Finds all .gpx files.
  3. Removes the decimal part of the <hdop> tag (changes 5.92 -> 5).
  4. Saves the fixed version as a NEW file (does not overwrite original).
  5. Allows you to choose a custom suffix for new files (default: _fixed).
"""

import os
import re

def fix_gpx_files():
    print("=" * 60)
    print("           GPX HDOP FIXER - GPX file -> Slopes app           ")
    print("=" * 60)

    # 1. Ask for Folder Path
    print("\nEnter the folder path containing GPX files:")
    print("(Example: C:\\Users\\Name\\Downloads\\Hike)")
    print("(Press Enter to use the current folder where this script is)")
    folder_input = input("> ").strip()

    # Remove quotes if user pasted path as "C:\Path" (common in Windows)
    folder_input = folder_input.replace('"', '').replace("'", "")

    if not folder_input:
        target_folder = os.getcwd()
    else:
        target_folder = folder_input

    # Check if folder exists
    if not os.path.isdir(target_folder):
        print(f"\n❌ Error: The directory does not exist:\n{target_folder}")
        input("\nPress Enter to exit...")
        return

    print(f"📂 Selected folder: {target_folder}")

    # 2. Ask for Suffix
    print("\nEnter a suffix for the fixed files (default: '_fixed'):")
    suffix = input("> ").strip()
    if not suffix:
        suffix = "_fixed"

    # Regex pattern
    pattern = re.compile(r'(<hdop>\d+)\.\d+(</hdop>)')

    print(f"\n🚀 Starting repair process...")
    print("-" * 60)

    count = 0

    # Scan the TARGET folder
    for filename in os.listdir(target_folder):
        if filename.lower().endswith(".gpx") and suffix not in filename:
            filepath = os.path.join(target_folder, filename)

            try:
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()

                if pattern.search(content):
                    # Create new filename in the target folder
                    new_filename = filename.rsplit('.', 1)[0] + suffix + ".gpx"
                    new_filepath = os.path.join(target_folder, new_filename)

                    new_content = pattern.sub(r'\1\2', content)

                    with open(new_filepath, 'w', encoding='utf-8') as f:
                        f.write(new_content)

                    print(f"✅ Created: {new_filename}")
                    count += 1
                else:
                    print(f"ℹ️  Skipped: {filename} (No fix needed)")

            except Exception as e:
                print(f"❌ Error with file {filename}: {e}")

    print("-" * 60)
    print(f"🎉 Done! Created {count} new files in the target folder.")
    input("\nPress Enter to exit...")

if __name__ == "__main__":
    fix_gpx_files()
