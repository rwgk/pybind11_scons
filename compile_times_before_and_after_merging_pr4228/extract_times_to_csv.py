"""See README.md."""

import sys


def get_cmdl_essence(cmdl):
  """."""
  if cmdl.endswith(".cpp"):
    flds = cmdl.split("/")
    return flds[-1]
  if cmdl.startswith("time_clang++ -o lib/"):
    flds = cmdl.split()
    return flds[2][4:]
  if cmdl.startswith("time_clang++ -o bin/"):
    flds = cmdl.split()
    return flds[7].split("/")[-1]
  return cmdl


def process_real_line(real_line):
  """."""
  flds = real_line.split("\t")
  assert len(flds) == 2
  ms = flds[1]
  assert ms.endswith("s")
  flds = ms[:-1].split("m")
  assert len(flds) == 2
  return "%.3f" % (int(flds[0]) * 60 + float(flds[1]))


def run(args):
  """."""
  all_timings = []
  for filename in args:
    timings = {}
    cmdl = None
    real = None
    for line in open(filename).read().splitlines():
      if line.startswith("time_clang++ "):
        assert cmdl is None
        cmdl = line
        real = None
      elif line.startswith("real\t"):
        assert real is None
        real = line
        assert cmdl not in timings
        timings[cmdl] = process_real_line(real)
        cmdl = None
    assert cmdl is None
    all_timings.append(timings)
  assert all_timings
  all_cmdls = tuple(all_timings[0].keys())  # preserve sort order here
  for timings in all_timings[1:]:
    # assert completeness & consistent sort order
    assert tuple(timings.keys()) == all_cmdls
  for cmdl in all_cmdls:
    cmdl_essence = get_cmdl_essence(cmdl)
    reals = [timings[cmdl] for timings in all_timings]
    print(",".join([cmdl_essence] + reals))


if __name__ == "__main__":
  run(args=sys.argv[1:])
