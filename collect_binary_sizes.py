import subprocess
import sys


def run(args):
  for build_dir in args:
    print(build_dir)
    output = subprocess.run(
        "find bin lib -type f | sort | xargs stat -c '%s'",
        shell=True,
        cwd=build_dir,
        capture_output=True,
        text=True)
    assert not output.returncode, output
    print(output.stdout)


if __name__ == '__main__':
  run(args=sys.argv[1:])
