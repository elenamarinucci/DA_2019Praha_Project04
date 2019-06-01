import sys
import re
import csv
csv.field_size_limit(100000000)
final_data = [[re.sub("<.*?>", "", b) for b in i] for i in csv.reader(open('out.c-lena_project.superclean.csv', 'r', encoding="utf8"))]

with open('cleaned.csv', 'w', encoding="utf8", newline='') as writeFile:
  writer = csv.writer(writeFile)
  writer.writerows(final_data)
