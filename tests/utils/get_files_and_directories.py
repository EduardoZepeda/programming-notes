import os
import glob

import rstcheck


def get_directories_paths(directories):
    return [os.path.join(directory) for directory in directories]


def get_file_names(directories):
    files = []
    for directory in get_directories_paths(directories):
        for rst in glob.glob(os.path.join(directory, "*.rst")):
            files.append(rst)
    return files


def get_first_line_with_error(directories):
    for rst_file in get_file_names(directories):
        with open(rst_file, "r") as f:
            line = list(
                rstcheck.check(f.read(), ignore={"languages": ["bash", "html"]})
            )
            if line != []:
                line.append(rst_file)
                return line
    return []
