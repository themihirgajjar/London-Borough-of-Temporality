import pandas as pd
import sqlite3

con = sqlite3.connect("/Users/mihirgajjar/Desktop/python/bcur/numbats.db")

data = pd.read_sql_query(
    """
    SELECT "total_weekly_exits_2019"."name", "total_weekly_exits_2019"."dest_id", (("total_weekly_exits_2022"."total_weekly_exits" - "total_weekly_exits_2019"."total_weekly_exits") / "total_weekly_exits_2019"."total_weekly_exits") * 100 AS "percentage_change" 
    FROM "total_weekly_exits_2019"
    JOIN "total_weekly_exits_2022" ON "total_weekly_exits_2019"."dest_id" = "total_weekly_exits_2022"."dest_id"
    ORDER BY ABS("percentage_change") DESC;
    """, con)

# Create pandas dataframe
df = pd.DataFrame(data)

# Calculate quartiles
q1 = df['percentage_change'].quantile(0.25)
q3 = df['percentage_change'].quantile(0.75)
iqr = q3 - q1

# Print quartiles and IQR
print("First Quartile (Q1):", q1)
print("Third Quartile (Q3):", q3)
print("Interquartile Range (IQR):", iqr)

# Results:
# First Quartile (Q1): -25.50806156405345
# Third Quartile (Q3): -16.983568116233037
# Interquartile Range (IQR): 8.524493447820412
# Majority of stations seem to have seen a decrease in total weekly exits
# "Due to the negative distribution of percentage changes, 
# the IQR did not provide significant insights in this analysis and was therefore excluded."

# TODO: Get a list of stations that can be categorised as outliers, ask Gemini how to compare them

