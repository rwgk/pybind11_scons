"""
Example usage:

grep --color=auto -I --exclude \*.pyc --exclude-dir .git -r '\\rst' | cut -d: -f1 | uniq > ~/zfiles
python3 rst_clang_format_off_on.py `cat ~/zfiles`
git commit -a -m 'Automatically inserted clang-format off-on around rst blocks (NO manual changes).'
"""

import sys


def run(args):
  """."""
  for filename in args:
    lines = open(filename).read().splitlines()
    more_lines = []
    mla = more_lines.append
    indent = None
    for ix_line, line in enumerate(lines):
      if line.find(r"\rst") >= 0:
        if "// clang-format off" not in lines[ix_line - 1]:
          indent = " " * (len(line) - len(line.lstrip()))
          mla(indent + "// clang-format off")
        mla(line)
      elif line.find(r"\endrst") >= 0:
        mla(line)
        if "// clang-format on" not in lines[ix_line + 1]:
          assert indent is not None
          mla(indent + "// clang-format on")
          indent = None
      else:
        mla(line)
    if more_lines != lines:
      blob = "\n".join(more_lines) + "\n"
      print("Writing: ", filename, flush=True)
      open(filename, "w").write(blob)


if __name__ == "__main__":
  run(args=sys.argv[1:])
