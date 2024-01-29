#!/usr/bin/env python

from sys import argv
from Bio import SeqIO
from re import compile
import gzip

recd = {}
#for line in gzip.open(argv[1], mode='rt'):
for line in open(argv[1]):
  if line[0] != '#':
    atoms = line.split()
    last_atoms = str(atoms[-1]).split(";")
    id = last_atoms[0].split("=")[1]
    recd[id] = (last_atoms[-5].split("=")[1], last_atoms[-3].split("=")[1], last_atoms[-2].split("=")[1])

with open(argv[1].split("_results")[0] + ".tab", 'w+') as fh:
  fh.write("ies_name\ties_ret\ties+\ties-\n")
  for rec in recd:
    fh.write(rec + "\t" + "%s\t%s\t%s" % recd[rec] + "\n")
