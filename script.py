import os, glob
from natsort import natsorted

def merge_markdown():
    for file in os.walk(os.getcwd()):
        if "content" in file[1]:
            ordered = natsorted(glob.glob(os.path.join(file[0], 'content', "*.md")))
            index = os.path.join(file[0], list(filter(lambda x: x!='index.md', file[2]))[0])
            os.system("cat {} {} > {}/index.md".format(index, " ".join(ordered), file[0]))
            os.system("rm {}".format(index))
            os.system("rm -rf {}".format(os.path.join(file[0], 'content')))
def main():
    merge_markdown()


if __name__ == '__main__':
    main()