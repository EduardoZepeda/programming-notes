import os, glob, time, html
from natsort import os_sorted

content_folder = "Cursos"
output_folder = "Notes"


def generate_notes_folder():
    for file in glob.glob(f"{content_folder}/*.md"):
        new_directory = (
            file.replace(f"{content_folder}", "").replace(".md", "").replace("/", "")
        )
        output = os.path.join(output_folder, new_directory)
        os.system(f"mdsplit {file} --max-level 2 --output {output}")
        # Iterate over directory


def rename_folders():
    for path, dirs, files in os.walk(output_folder):
        os.rename(os.path.join(path, dirs[0]), os.path.join(path, "content"))


def add_toc():
    for path, dirs, files in os.walk(output_folder):
        for sub_path, sub_dirs, sub_files in os.walk(os.path.join(path, "content")):
            with open(os.path.join(path, files[0]), "a") as f:
                li = os_sorted(
                    [
                        "* " + generate_single_toc_string(link) + "\n"
                        for link in sub_files
                    ]
                )
                f.write("\n")
                f.write("[comment]:STARTING_GENERATED_TOC")
                f.write("\n\n")
                f.write("".join(li))
                f.write("\n")
                f.write("[comment]:ENDING_GENERATED_TOC")
                f.write("\n")
                # aaa(.|\n)+?bbb
                # \[comment\]:STARTING_GENERATED_TOC(.|\n)+?\[comment\]:ENDING_GENERATED_TOC


def remove_spaces_from_md_files():
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


def main():
    # generate_notes_folder()
    # rename_folders()
    add_toc()
    # remove_spaces_from_md_files()


if __name__ == "__main__":
    main()
