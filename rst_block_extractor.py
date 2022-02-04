r"""
Example usage:

grep --color=auto -I --exclude \*.pyc --exclude-dir .git -r '\\rst' | cut -d: -f1 | uniq > ~/zfiles
python3 rst_block_extractor.py `cat ~/zfiles`
"""

import sys


def run(args):
  """."""
  for filename in args:
    lines = open(filename).read().splitlines()
    inside_block = False
    for line in lines:
      if line.find(r"\rst") >= 0:
        print("FILE:", filename)
        print(line)
        inside_block = True
      elif line.find(r"\endrst") >= 0:
        print(line)
        inside_block = False
        print()
      elif inside_block:
        print(line)


if __name__ == "__main__":
  run(args=sys.argv[1:])
