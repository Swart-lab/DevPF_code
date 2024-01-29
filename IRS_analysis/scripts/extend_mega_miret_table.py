#!/usr/bin/env python

import glob
from sys import argv
from collections import OrderedDict

for line in open(argv[1]):
  header_line = line[:-1]
  break

table_d = OrderedDict()
for line in open(argv[1]).readlines()[1:]:
  atoms = line.split("\t")
  iesname = atoms[0]
  table_d[iesname] = line[:-1]

rec_d = {}
for fn in argv[2:]:
  with open(fn) as fh:
    for line in fh.readlines()[1:]:
      atoms = line.split()
      rec_d.setdefault(atoms[0], []).append(atoms[1])

for ies in table_d:
  try:
    for retscore in rec_d[ies]:
      table_d[ies] += "\t%s" % retscore
  except KeyError:
    pass

new_kds = [a.split(".")[0] for a in argv[2:]]
print(header_line + "\t" + "\t".join(new_kds))

for ies in table_d:
  print(table_d[ies])
