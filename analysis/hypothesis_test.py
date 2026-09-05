import matplotlib.pyplot as plt
import pandas as pd
import scipy.stats as stats
import sqlite3

con = sqlite3.connect("/Users/mihirgajjar/Desktop/python/bcur/numbats.db")

group_19 = pd.read_sql_query(
    """
    SELECT "total_weekly_exits" FROM "total_weekly_exits_2019";
    """, con)

# There are 3 stations that did not exist in 2019, the query eliminates that data for paired test
group_22 = pd.read_sql_query(
    """
    SELECT "total_weekly_exits" FROM "total_weekly_exits_2022"
    WHERE "dest_id" NOT IN (
    SELECT "dest_id" FROM "total_weekly_exits_2022"
    EXCEPT 
    SELECT "dest_id" FROM "total_weekly_exits_2019"
    );
    """, con)

print(group_19["total_weekly_exits"].describe(),'\n')
print(group_22["total_weekly_exits"].describe(),'\n')

# Visual Inspection
plt.hist(group_19["total_weekly_exits"], bins=100)

plt.hist(group_22["total_weekly_exits"], bins=100)
plt.show()
# Right-skewed distribution in both the datasets



# Defining Level of Significance
alpha = 0.05

# Checking for Normality
w_value, p_value = stats.shapiro(group_19)
print(f'W = {w_value}, p = {p_value}')
if p_value < alpha:
    print('2019 violates the assumption of normality\n')
else:
    print('2019 does not violate the assumption of normality\n')

w_value, p_value = stats.shapiro(group_22)
print(f'W = {w_value}, p = {p_value}')
if p_value < alpha:
    print('2022 violates the assumption of normality\n')
else:
    print('2022 does not violate the assumption of normality\n')

# Perform Matched Pair Wilcoxon Test
stat, p_value = stats.wilcoxon(group_19, group_22)

print(f'Statistics={stat}, p={p_value}\n')

# Conclusion 
if p_value < alpha: 
    print('Reject Null Hypothesis (Significant difference between two samples)\n') 
else: 
    print('Do not Reject Null Hypothesis (No significant difference between two samples)\n')

con.close()
