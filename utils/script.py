import os, glob, time, html, re, argparse
from natsort import os_sorted

content_folder = "Cursos"
output_folder = "Notes"


def generate_notes_folder():
    """Split big markdown files by title into smaller files"""
    for file in glob.glob(f"{content_folder}/*.md"):
        new_directory = (
            file.replace(f"{content_folder}", "").replace(".md", "").replace("/", "")
        )
        output = os.path.join(output_folder, new_directory)
        os.system(f"mdsplit {file} --max-level 2 --output {output}")
        # Iterate over directory


def rename_folders():
    """Change the name of every generated folder to content"""
    for path, dirs, files in os.walk(output_folder):
        os.rename(os.path.join(path, dirs[0]), os.path.join(path, "content"))


def add_toc():
    """Add a generated TOC to every index file, enclose it in comments"""
    for path, dirs, files in os.walk(output_folder):
        for sub_path, sub_dirs, sub_files in os.walk(os.path.join(path, "content")):
            with open(os.path.join(path, files[0]), "a") as f:
                li = os_sorted(
                    [
                        "* " + generate_single_toc_string(link) + "\n"
                        for link in sub_files
                    ]
                )
                f.write("")


def remove_toc():
    """Remove the generated TOC from every index file, use comments to detect them"""
    for path, dirs, files in os.walk(output_folder):
        for sub_path, sub_dirs, sub_files in os.walk(os.path.join(path, "content")):
            with open(os.path.join(path, files[0]), "r") as f:
                text_content = f.read()
                text_content_without_toc = re.sub(
                    "\[comment\]:STARTING_GENERATED_TOC(.|\n)+?\[comment\]:ENDING_GENERATED_TOC",
                    "",
                    text_content,
                )
            with open(os.path.join(path, files[0]), "w") as f:
                f.write(text_content_without_toc)


def update_toc():
    """Remove TOC, and afterwards generate a new one for every index file"""
    remove_toc()
    add_toc()


def remove_spaces_from_md_files():
    """Remove all the spaces and replace them with hyphens in every markdown file name"""
    for path, dirs, files in os.walk(output_folder):
        for file in files:
            if " " in file:
                os.rename(
                    os.path.join(path, file), os.path.join(path, file).replace(" ", "-")
                )
        for sub_path, sub_dirs, sub_files in os.walk(os.path.join(path, "content")):
            pass


def generate_single_toc_string(link):
    base_name = link.replace(".md", "")
    escaped_link = html.escape(link)
    return f"[{base_name}](<./content/{escaped_link}>)"


def initialize_args():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--addToc",
        action=argparse.BooleanOptionalAction,
        help="Add TOC to every index file",
    )
    parser.add_argument(
        "--removeToc",
        action=argparse.BooleanOptionalAction,
        help="Remove TOC from every index file",
    )
    parser.add_argument(
        "--toc",
        action=argparse.BooleanOptionalAction,
        help="Update TOC for every index file",
    )
    args = parser.parse_args()
    return args


def main():
    """Parse arguments and act accordingly"""
    args = initialize_args()
    if args.addToc:
        add_toc()
    if args.removeToc:
        remove_toc()
    if args.toc:
        update_toc()


if __name__ == "__main__":
    main()
