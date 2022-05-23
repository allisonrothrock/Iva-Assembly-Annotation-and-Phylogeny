#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Nov 14 23:22:39 2021

@author: allisonrothrock
"""
#Run if assembly dies with memory issues in the butterfly phase, continue Trinity when this script finishes
#Run from within trinity_out_dir

import os
import shutil

#Compiles the location of out files corresponding to failed commands (must be removed to rerun)
f = open("FailedCommands")
x = open("failed_compilation", "a")
for thing in f:
    sect = thing.replace('"', '/')
    sect = sect.split("/")
    for loc in sect:
        fil = str(loc)
        if fil.endswith(".trinity.reads.fa.out"):
            x.write(sect[sect.index(loc)-2])
            x.write("/")
            x.write(sect[sect.index(loc)-1])
            x.write(" ")
            x.write(fil.strip(".out"))
            x.write("\n")

#Removes the outfiles from the locations determined above
y = open("failed_compilation")
os.chdir("read_partitions/")
for add in y:
    fb = str(add.split(" "))
    form = str(add.split(" ")[1]).strip("\n") + ".out"
    os.chdir(fb[0])
    shutil.rmtree(form)
    os.chdir("..")

#Reruns each failed command individually
os.chdir("..")
f = open("FailedCommands")
for line in f:
    os.system(line)
