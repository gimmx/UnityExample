#!/bin/python3
import os
import re
import subprocess

path = "./test/build/"

def printHeader():
    print("\n****** TEST FILE REPORT ******\n")

def printFooter():
    print("\n****** END TEST FILE REPORT ******\n")

def printSummary():
    print("Tests: {}\nFailures: {}\nIgnores: {}".format(tests,failures,ignores))

printHeader()

headregex=re.compile(r".*\d+ Tests \d+ Failures \d Ignored.*")
failureregex=re.compile(r".*test_.*:FAIL:.*")

results = b''

# gather all test file output
for x in os.listdir(path):
    if x.endswith(".out"):
        cmd = path + x
        output = subprocess.Popen([str(cmd)], stdout=subprocess.PIPE)
        results += output.communicate()[0]

# consolidate and parse output into a readable format
output = results.decode('UTF-8').split('\n')

tests = 0
failures = 0
ignores = 0
failStrings = []

# parse the output for headers and failures
for x in output:
    if re.match(headregex, x):
        tmp = x.split(" ")
        tests += int(tmp[0])
        failures += int(tmp[2])
        ignores += int(tmp[4])

    if re.match(failureregex, x):
        failStrings.append(x)

printSummary()

# print all failures
if failures > 0:
    print("\nFAILURES:")

    for x in failStrings:
        print(x)
else:
    print("\nAll tests passed!")

printFooter()

