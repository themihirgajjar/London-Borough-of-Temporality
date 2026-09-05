import csv
import os
import sqlite3


conn = sqlite3.connect("/Users/mihirgajjar/Desktop/python/bcur/numbats.db")

cursor = conn.cursor()
cursor.execute("""
    ...
    """)

with open("/Users/mihirgajjar/Desktop/python/bcur_csvs/absolute_total_change.csv", "w") as csv_file:
    csv_writer = csv.writer(csv_file, delimiter="\t")
    csv_writer.writerow([i[0] for i in cursor.description])
    csv_writer.writerows(cursor)

conn.close()