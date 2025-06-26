#!/usr/bin/env python3
import os
import tempfile
import datetime
import sys

def processo(file, output_dir, pipe):

    status = ""

    try:

        time = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
        basename = os.path.basename(file)
        backupname = f"{output_dir}/{basename}_{time}.tar.gz"

        status = os.system(f"tar -czf {backupname} {file} 2> /dev/null")

        if status != 0:

            raise OSError()

        status_message = f"Success;{basename};{backupname}"

    except:

        status_message = f"Failed;{basename};tar: couldn't read the file: Permission denied"

    with open(pipe, "w") as filepipe:
        filepipe.write(status_message + "\n")

    os._exit(0)

def main(listfile, output_dir, pipe):

    directorys = []
    with open(listfile, "r") as file:
        directorys = [line.strip() for line in file if line.strip()]

    pid_childs = []
    for directory in directorys:
        pid = os.fork()
        if not pid:
            processo(directory, output_dir, pipe)
        else:
            pid_childs.append(pid)

    with open(pipe, "r") as pipe_line:

        sucesses = []
        fails = []
        for _ in range(len(directorys)):

                result = pipe_line.readline().strip()
                
                if not result: continue

                pieces = result.split(';', 2)
                status, directory, info = pieces
                
                if status == 'Success':
                    print(f"Child {directory} finished successfuly")
                    sucesses.append(info)
                else:
                    print(f"Child {directory} finished unsuccessfuly - Permission denied")
                    fails.append(info)

        for pid in pid_childs:
            os.waitpid(pid, 0)

        print("Successes files are:")
        if sucesses:
            for path in sucesses:
                print(f"- {path}")

if __name__ == "__main__":

    try:
        
        pipe = tempfile.mktemp()
        os.mkfifo(pipe)

        main(sys.argv[1], sys.argv[2], pipe)

        
    finally:

        os.remove(pipe)