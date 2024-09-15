## Introduction

The rise of large-scale open datasets offers valuable insights for urban
planning and transit management. Traditional spatial network analysis often assumes static node relationships, yet real-world transit networks are dynamic and continuously evolving. Leveraging open access mobility data allows us to uncover these changes in human transit behaviour.

This study examines shifts in London’s Underground Transit System from
2019 to 2022, using Transport for London’s NUMBAT datasets, which
provide anonymized journey details. By analysing changes in link-loads
between stations, the study aims to map the evolving patterns of public
mobility in London.

Through detailed analysis and visualizations, this research identifies:

• Persistent Hubs: Stations maintaining high demand.

• Emerging Connections: New activity centres with increasing ridership.

• Weakening Ties: Declining traffic patterns and their implications.

These insights contribute to the broader conversation on ‘Smart Cities’
emphasizing the need for adaptable infrastructure and efficient transport
systems to meet the evolving needs of a dynamic metropolis.


## 1. Hypothesis Testing

### 1.1 Statistical Summary:
``` python
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
```

| Statistics | 2019 | 2022|
|:------| :------| :------|
|count | 267.00 | 267.00 |
|mean | 113006.37 | 88150.70|
|std | 161312.36 | 127162.41 |
|min | 947.61 | 975.71 |
|25% | 28724.16 |22271.96 |
|50% | 56763.08 |44963.79 |
|75% | 127839.24 |93537.82|
|max | 959180.61 |880832.60 |

### 1.2 Checking for Normality
* Visual Inspection
``` python
# Visual Inspection
plt.hist(group_19["total_weekly_exits"], bins=100)
plt.hist(group_22["total_weekly_exits"], bins=100)

plt.show()

```

![alt text](../images/Figure_1.png)

>There is a right-skewed distribution in both the datasets. It is typical with transportation datasets as few stations tend to get extremely high exit counts compared to most other stations.

* Shapiro Test
```python
# Defining Level of Significance
alpha = 0.05

# Testing for Normality
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

```

W = 0.6022887579660493, p = 2.2117475177553643e-24\
2019 violates the assumption of normality

W = 0.5977308606843916, p = 1.6847852307146335e-24\
2022 violates the assumption of normality

>Since the datasets are not normally distributed, a non-parametric paired test must be conducted for hypothesis testing.

### 1.3 Matched Pair Wilcoxon Test

``` python
# Perform Matched Pair Wilcoxon Test
stat, p_value = stats.wilcoxon(group_19, group_22)

print(f'Statistics={stat}, p={p_value}\n')

# Conclusion 
if p_value < alpha: 
    print('Reject Null Hypothesis (Significant difference between two samples)\n') 
else: 
    print('Do not Reject Null Hypothesis (No significant difference between two samples)\n')

con.close()

```

Results: \
Statistics=[536.], p=[5.8641191e-43]\

>Conclusion:\
Reject Null Hypothesis (Significant difference between two samples)


## 2. Shortlisting
NOTE: SQL Queries in Separate File
### 2.1 Percentage Change in Traffic: 2019 vs 2022

* Top 10 Stations with Most Percentage Increase

name|dest_id|total_weekly_exits_19|total_weekly_exits_22|percentage_change|
|:-----|:-----|:-----|:-----|:-----|
|Tottenham Court Road|728|419336.77|492527.83|+17.45%|
|Hyde Park Corner|614|49101.20|56128.27|+14.31%|
|Moorgate|645|256032.40|277082.05|+8.22%|
|Stonebridge Park|717|15199.10|16074.45|+5.76%|
|Mill Hill East|643|12888.94|13526.96|+4.95%|
|Kensington (Olympia)|618|947.61|975.71|+2.96%|
|Woodside Park|771|45319.15|44963.79|-0.78%|
|Kew Gardens|621|30983.85|30676.13|-0.99%|
|Wembley Park|752|160250.55|157452.54|-1.75%|
|Buckhurst Hill|531|17742.25|17310.12|-2.44%|
||


>On average, total weekly exits per station decreased by around 21.15% from 2019 to 2022.


>Only 6 stations experienced an increase in passenger traffic during this period.


* Top 10 Stations with Most Percentage Decline

|name|dest_id|total_weekly_exits_19|total_weekly_exits_22|percentage_change|
|:-----|:-----|:-----|:-----|:-----|
|Richmond|686|115757.78|47218.83|-59.21%|
|Chancery Lane|541|172220.75|92305.21|-46.40%|
|Ealing Broadway|560|175437.00|94925.53|-45.90%|
|Barbican|501|105851.58|59867.96|-43.44%|
|Lancaster Gate|629|66575.41|38278.31|-42.50%|
|Cannon Street LU|536|68557.89|39441.20|-42.47%|
|Heathrow Terminal 4 LU|781|22566.43|13085.56|-42.01%|
|Regent's Park|685|41939.19|24689.84|-41.13%|
|St. Paul's|697|167389.72|100628.91|-39.88%|
|Liverpool Street LU|634|719274.13|449881.55|-37.45%|
||

### 2.2 Top 20 Destinations by Total Weekly Exits

* Stations by Total Weekly Exits

![alt text](../images/ranking_change_slope.png)

* Top 20 Destinations by Total Weekly Exits

|Rank '19|Rank '22|Change|Name|
|:-----|:-----|:-----|:-----|
|3|1|+2|Waterloo LU|
|2|2|0|King's Cross St. Pancras|
|5|3|+2|Stratford|
|1|4|-3|Victoria LU|
|4|5|-1|Oxford Circus|
|7|6|+1|London Bridge LU|
|6|7|-1|Bank and Monument|
|13|8|+5|Tottenham Court Road|
|8|9|-1|Liverpool Street LU|
|9|10|-1|Paddington TfL|
|15|11|+4|Bond Street|
|10|12|-2|Canary Wharf LU|
|11|13|-2|Green Park|
|12|14|-2|Euston LU|
|19|15|+4|Leicester Square|
|14|16|-2|Piccadilly Circus|
|29|17|12|Moorgate|
|18|18|0|Highbury & Islington|
|17|19|-2|South Kensington|
|20|20|0|Canada Water|
|16|25|-9|Vauxhall LU*|
||

Moorgate is a new entry, Vauxhall dropped from the list, Tottehnam Court Road, Leicester Square and Bond Street being other significant changes.

### 2.3 Top 20 Most Absolute Changes in Total Weekly Exits by Destination

|Rank '19|Rank '22|Change|Name|
|:-----|:-----|:-----|:-----|
|73|129|-56|Richmond|
|145|108|+37|Hyde Park Corner|
|110|146|-36|Cannon Street LU|
|116|152|-36|Lancaster Gate|
|161|195|-34|Regent's Park|
|76|101|-25|Barbican|
|130|105|+25|Queen's Park|
|48|71|-23|Chancery Lane|
|194|171|+23|Kew Gardens|
|218|241|-23|Heathrow Terminal 4 LU|
|111|133|-22|Mansion House|
|45|66|-21|Ealing Broadway|
|154|134|+20|Woodside Park|
|125|110|+15|Ladbroke Grove|
|155|140|+15|Wood Lane|
|141|127|+14|Belsize Park|
|215|201|+14|Brent Cross|
|241|227|+14|Stonebridge Park|
|51|38|+13|Wembley Park|
|49|62|-13|St. Paul's|
||

### 2.4 Top 3 Destinations Preference by Station
* Top 3 Destinations by Origin (Count)

![alt text](../images/top_dest_by_count_2019.jpg)
"2019"
![alt text](../images/top_dest_by_count_2022.jpg)
"2022"

* Top 3 Destinations by Origin (Volume)

![alt text](../images/top_dest_by_weight_2019.jpg)
"2019"
![alt text](../images/top_dest_by_weight_2022.jpg)
"2022"

### 2.5 Most Popular Destinations by Origin (2019 vs. 2022)

* 2019

|Rank '19|Destination|Count '19|
|:-----|:-----|:-----|
|1|Stratford|26|
|2|Hammersmith (DIS)|18|
|3|Bank and Monument|17|
|4|King's Cross St. Pancras|13|
|5|Victoria LU|11|
|5|Oxford Circus|11|
|5|Harrow-on-the-Hill|11|
|8|London Bridge LU|10|
|8|Liverpool Street LU|10|
|10|Wembley Park|8|
|10|Waterloo LU|8|
|10|Shepherd's Bush LU|8|
|13|Wimbledon|7|
|13|Piccadilly Circus|7|
|13|Hammersmith (H&C)|7|
|13|Barking|7|
|17|Willesden Junction|6|
|17|Whitechapel|6|
|17|Uxbridge|6|
|17|Richmond|6|
|21|Paddington TfL|5|
|21|Ealing Broadway|5|
|23|Wood Green|3|
|23|Highbury & Islington|3|
|23|Golders Green|3|
|23|Canary Wharf LU|3|
|23|Bond Street|3|
|28|West Hampstead LU|2|
|28|Wembley Central|2|
|28|Tower Hill|2|
|28|Tooting Broadway|2|
|28|Heathrow Terminals 123 LU|2|
|28|Finchley Central|2|
|28|Embankment|2|
|28|Chalfont & Latimer|2|
|28|Camden Town|2|
|28|Blackfriars LU|2|
|28|Balham LU|2|
|39|Watford|1|
|39|Upminster|1|
|39|Tottenham Court Road|1|
|39|Southgate|1|
|39|Southfields|1|
|39|Sloane Square|1|
|39|Rickmansworth|1|
|39|Hornchurch|1|
|39|Holborn|1|
|39|Farringdon|1|
|39|Euston LU|1|
|39|Earl's Court|1|
|39|Dagenham Heathway|1|
|39|Canning Town|1|
|39|Burnt Oak|1|
|39|Amersham|1|
||||

* 2022

|Rank '22|Destination|Count '22|
|:-----|:-----|:-----|
|1|Stratford|28|
|2|Tottenham Court Road|27|
|3|Victoria LU|17|
|4|Hammersmith (DIS)|16|
|5|King's Cross St. Pancras|15|
|6|Waterloo LU|10|
|7|Paddington TfL|9|
|7|Harrow-on-the-Hill|9|
|9|Whitechapel|8|
|9|Wembley Park|8|
|9|Shepherd's Bush LU|8|
|9|London Bridge LU|8|
|9|Barking|8|
|14|Wimbledon|7|
|14|Willesden Junction|7|
|14|Uxbridge|7|
|14|Oxford Circus|7|
|14|Hammersmith (H&C)|7|
|19|Ealing Broadway|6|
|19|Bond Street|6|
|21|Wood Green|4|
|21|Liverpool Street LU|4|
|21|Highbury & Islington|4|
|21|Heathrow Terminals 123 LU|4|
|25|Tooting Broadway|3|
|25|Piccadilly Circus|3|
|25|Bank and Monument|3|
|28|Tower Hill|2|
|28|Richmond|2|
|28|Chalfont & Latimer|2|
|28|Balham LU|2|
|32|Woodside Park|1|
|32|Watford|1|
|32|Southgate|1|
|32|Southfields|1|
|32|South Kensington|1|
|32|Russell Square|1|
|32|Rickmansworth|1|
|32|Moorgate|1|
|32|Hornchurch|1|
|32|High Street Kensington|1|
|32|Golders Green|1|
|32|Finsbury Park LU|1|
|32|Euston Square|1|
|32|Embankment|1|
|32|Edgware|1|
|32|Colindale|1|
|32|Canning Town|1|
|32|Canary Wharf LU|1|
|32|Amersham|1|
||||

### 2.6 Changes in Most Preferred destinations by Station [Rankings Change]

|Rank '19|Rank '22|Change|Destination|
|:-----|:-----|:-----|:-----|
|39|2|+37|Tottenham Court Road|
|21|7|+14|Paddington TfL|
|17|9|+8|Whitechapel|
|28|21|+7|Heathrow Terminals 123 LU|
|39|32|+7|Watford|
|39|32|+7|Southgate|
|39|32|+7|Southfields|
|39|32|+7|Rickmansworth|
|39|32|+7|Hornchurch|
|39|32|+7|Canning Town|
|39|32|+7|Amersham|
|10|6|+4|Waterloo LU|
|13|9|+4|Barking|
|23|19|+4|Bond Street|
|17|14|+3|Willesden Junction|
|17|14|+3|Uxbridge|
|28|25|+3|Tooting Broadway|
|5|3|+2|Victoria LU|
|21|19|+2|Ealing Broadway|
|23|21|+2|Wood Green|
|23|21|+2|Highbury & Islington|
|10|9|+1|Wembley Park|
|10|9|+1|Shepherd's Bush LU|
|1|1|0|Stratford|
|28|28|0|Tower Hill|
|28|28|0|Chalfont & Latimer|
|28|28|0|Balham LU|
|4|5|-1|King's Cross St. Pancras|
|8|9|-1|London Bridge LU|
|13|14|-1|Wimbledon|
|13|14|-1|Hammersmith (H&C)|
|2|4|-2|Hammersmith (DIS)|
|5|7|-2|Harrow-on-the-Hill|
|28|32|-4|Embankment|
|5|14|-9|Oxford Circus|
|23|32|-9|Golders Green|
|23|32|-9|Canary Wharf LU|
|17|28|-11|Richmond|
|13|25|-12|Piccadilly Circus|
|8|21|-13|Liverpool Street LU|
|3|25|-22|Bank and Monument|
|||||

* Stations not in both the year's ranking

|in 2022 not in 2019|
|:-----|
|Woodside Park|
|South Kensington|
|Russell Square|
|Moorgate|
|High Street Kensington|
|Finsbury Park LU|
|Euston Square|
|Edgware|
|Colindale|
||

|in 2019 not in 2022|
|:-----|
|West Hampstead LU|
|Wembley Central|
|Finchley Central|
|Camden Town|
|Blackfriars LU|
|Upminster|
|Sloane Square|
|Holborn|
|Farringdon|
|Euston LU|
|Earl's Court|
|Dagenham Heathway|
|Burnt Oak|
||


### 2.7 Shortlist

|Destination|
|:-----|
|Richmond|
|Chancery Lane|
|Ealing Broadway|
|Barbican|
|Lancaster Gate|
|Cannon Street LU|
|Heathrow Terminal 4 LU|
|Regent's Park|
|St. Paul's|
|Liverpool Street LU|
|Tottenham Court Road|
|Hyde Park Corner|
|Moorgate|
|Stonebridge Park|
|Mill Hill East
|Kensington (Olympia)|
|Woodside Park|
|Kew Gardens|
|Wembley Park|
|Buckhurst Hill|
|Vauxhall LU|
|Leicester Square|
|Bond Street|
|Piccadilly Circus|
|Bank and Monument|
|Paddington TfL|
||


## 3. Analysis

### 3.1 Interactive Dashboard
[Exploring London's Changing Transit Patterns: 2019 vs 2022] 
 (https://public.tableau.com/app/profile/mihir.gajjar/viz/Book2_17256283898160/Dashboard1)

 ### 3.2 Top 3 Proportional Increase and Decrease in Links by Destination

| destination | inc_org | increase | dec_org | decline |
|:-----|:-----|:-----|:-----|:-----|
| Bank and Monument | Tottenham Court Road | 0.2497 | Ealing Broadway | -0.5242 |
|  | Victoria LU | 0.6189 | Chancery Lane | -0.6059 |
|  | Waterloo LU | 3.5813 | Liverpool Street LU | -0.6969 |
| Barbican | King's Cross St. Pancras | 1.2861 | Paddington TfL | -3.3499 |
|  | Moorgate | 1.2386 | Whitechapel | -1.1309 |
|  | Seven Sisters | 0.5817 | Stratford | -0.6961 |
| Bond Street | London Bridge LU | 1.9096 | Stratford | -1.1502 |
|  | Green Park | 1.0874 | Victoria LU | -0.6314 |
|  | Westminster | 1.1991 | Bank and Monument | -0.8216 |
| Buckhurst Hill | Canary Wharf LU | 1.5386 | Liverpool Street LU | -1.5746 |
|  | Loughton | 1.2378 | Bank and Monument | -1.4766 |
|  | North Greenwich | 0.6855 | Paddington TfL | -0.426 |
| Cannon Street LU | Victoria LU | 5.5678 | Blackfriars LU | -2.5834 |
|  | Earl's Court | 0.3374 | Tower Hill | -1.7356 |
|  | East Putney | 0.3371 | Aldgate East | -1.1899 |
| Chancery Lane | Bond Street | 0.7431 | Bank and Monument | -1.8904 |
|  | Euston LU | 0.2708 | Lancaster Gate | -0.6672 |
|  | Seven Sisters | 0.3177 | Ealing Broadway | -1.0395 |
| Ealing Broadway | North Acton | 3.1818 | Chiswick Park | -0.8464 |
|  | Shepherd's Bush LU | 3.8718 | Hammersmith (DIS) | -1.5726 |
|  | White City | 3.6365 | Bank and Monument | -1.5655 |
| Heathrow Terminal 4 LU | Hatton Cross | 2.0027 | Liverpool Street LU | -0.6262 |
|  | Heathrow Terminal 5 LU | 1.6571 | Earl's Court | -0.6155 |
|  | Heathrow Terminals 123 LU | 4.9283 | Bank and Monument | -0.7114 |
| Hyde Park Corner | Tottenham Court Road | 2.1078 | Richmond | -0.5904 |
|  | Covent Garden | 0.5271 | South Kensington | -0.522 |
|  | Leicester Square | 0.8595 | Earl's Court | -0.5384 |
| Kensington (Olympia) | South Kensington | 2.0765 | King's Cross St. Pancras | -1.2644 |
|  | Victoria LU | 4.6726 | Earl's Court | -1.7601 |
|  | Wimbledon | 2.922 | Gunnersbury | -1.4628 |
| Kew Gardens | Hammersmith (DIS) | 0.7308 | Ealing Broadway | -0.3792 |
|  | Turnham Green | 0.6334 | Euston LU | -0.2486 |
|  | Victoria LU | 2.4871 | Richmond | -4.5007 |
| Lancaster Gate | Bond Street | 0.9028 | Bank and Monument | -2.732 |
|  | London Bridge LU | 0.8804 | Chancery Lane | -1.3249 |
|  | Oxford Circus | 1.5366 | Liverpool Street LU | -2.7588 |
| Leicester Square | Tottenham Court Road | 3.3658 | Stratford | -0.8855 |
|  | Camden Town | 0.5037 | Liverpool Street LU | -0.5029 |
|  | Waterloo LU | 0.8548 | Victoria LU | -0.84 |
| Liverpool Street LU | Farringdon | 0.724 | Barbican | -0.6103 |
|  | Stratford | 1.2973 | Bank and Monument | -0.6906 |
|  | Tottenham Court Road | 1.3864 | Oxford Circus | -0.8645 |
| Mill Hill East | Leicester Square | 0.8965 | Bank and Monument | -1.2976 |
|  | Moorgate | 0.7923 | Highgate | -1.2176 |
|  | Tottenham Court Road | 3.4833 | Finchley Central | -2.7347 |
| Moorgate | Euston Square | 1.3702 | Euston LU | -1.0251 |
|  | King's Cross St. Pancras | 4.6218 | Bank and Monument | -1.6048 |
|  | Old Street | 2.5025 | Paddington TfL | -1.5275 |
| Paddington TfL | Queen's Park | 2.1174 | Canary Wharf LU | -1.3272 |
|  | Maida Vale | 0.9677 | Moorgate | -0.8651 |
|  | Warwick Avenue | 0.9383 | Barbican | -0.7746 |
| Piccadilly Circus | Knightsbridge | 0.5063 | Stratford | -0.4607 |
|  | Tottenham Court Road | 0.6357 | Victoria LU | -0.9026 |
|  | Wembley Park | 0.4308 | Liverpool Street LU | -0.4042 |
| Regent's Park | Piccadilly Circus | 0.796 | Stratford | -0.3664 |
|  | Queen's Park | 0.9018 | Canning Town | -0.4327 |
|  | Paddington TfL | 1.3136 | Victoria LU | -2.2657 |
| Richmond | Bank and Monument | 0.9463 | Gunnersbury | -1.1825 |
|  | Kew Gardens | 1.3747 | Hammersmith (DIS) | -1.978 |
|  | Victoria LU | 1.357 | Ealing Broadway | -1.2396 |
| St. Paul's | Bond Street | 0.69 | Paddington TfL | -0.6737 |
|  | Tottenham Court Road | 0.5221 | Lancaster Gate | -0.6468 |
|  | Stratford | 0.9666 | Ealing Broadway | -1.1035 |
| Stonebridge Park | Oxford Circus | 0.5255 | Victoria LU | -1.4553 |
|  | Paddington TfL | 10.2216 | Harrow & Wealdstone | -2.5836 |
|  | Piccadilly Circus | 0.571 | Wembley Central | -2.5195 |
| Tottenham Court Road | Euston LU | 2.1853 | Bank and Monument | -2.3247 |
|  | Leicester Square | 2.2323 | Stratford | -2.3388 |
|  | Waterloo LU | 2.1843 | St. Paul's | -0.8627 |
| Vauxhall LU | King's Cross St. Pancras | 1.1398 | Victoria LU | -1.3711 |
|  | Oxford Circus | 1.002 | Stratford | -0.4743 |
|  | Seven Sisters | 1.1386 | Euston LU | -0.5625 |
| Wembley Park | Bond Street | 1.5857 | Victoria LU | -1.0031 |
|  | Euston Square | 1.0767 | Kingsbury | -0.6061 |
|  | King's Cross St. Pancras | 1.1366 | Harrow-on-the-Hill | -0.6081 |
| Woodside Park | High Barnet | 2.0385 | Bank and Monument | -0.9648 |
|  | Moorgate | 1.3358 | Finchley Central | -0.6775 |
|  | Tottenham Court Road | 2.9329 | Victoria LU | -1.0754 |

### 3.3 Change in Number of Links
| destination | links_19 | links_22 | links_change |
|:-----|:-----|:-----|:-----|
| Bank and Monument | 259 | 265 | 6 |
| Barbican | 211 | 237 | 26 |
| Bond Street | 264 | 264 | 0 |
| Buckhurst Hill | 103 | 139 | 36 |
| Cannon Street LU | 149 | 191 | 42 |
| Chancery Lane | 227 | 223 | -4 |
| Ealing Broadway | 227 | 238 | 11 |
| Heathrow Terminal 4 LU | 164 | 147 | -17 |
| Hyde Park Corner | 237 | 245 | 8 |
| Kensington (Olympia) | 69 | 54 | -15 |
| Kew Gardens | 182 | 165 | -17 |
| Lancaster Gate | 188 | 185 | -3 |
| Leicester Square | 263 | 264 | 1 |
| Liverpool Street LU | 264 | 263 | -1 |
| Mill Hill East | 81 | 127 | 46 |
| Moorgate | 233 | 245 | 12 |
| Paddington TfL | 264 | 262 | -2 |
| Piccadilly Circus | 263 | 266 | 3 |
| Regent's Park | 185 | 179 | -6 |
| Richmond | 214 | 215 | 1 |
| St. Paul's | 242 | 240 | -2 |
| Stonebridge Park | 96 | 131 | 35 |
| Tottenham Court Road | 263 | 262 | -1 |
| Vauxhall LU | 258 | 258 | 0 |
| Wembley Park | 231 | 238 | 7 |
| Woodside Park | 117 | 154 | 37 |

### 3.4 Peak Traffic Hours 

| destination | conc_19 | conc_22 | conc_change |
|:-----|:-----|:-----|:-----|
| Bank and Monument | Weekdays AM Peak | Weekdays AM Peak | N |
| Barbican | Weekdays AM Peak | Weekdays AM Peak | N |
| Bond Street | Weekends Midday | Weekends Midday | N |
| Buckhurst Hill | Weekdays PM Peak | Weekdays PM Peak | N |
| Cannon Street LU | Weekdays AM Peak | Weekdays AM Peak | N |
| Chancery Lane | Weekdays AM Peak | Weekdays AM Peak | N |
| Ealing Broadway | Weekdays PM Peak | Weekdays PM Peak | N |
| Heathrow Terminal 4 LU | Weekends Midday | Weekends Midday | N |
| Hyde Park Corner | Weekends Midday | Weekends Midday | N |
| Kensington (Olympia) | Weekends Midday | Weekends Midday | N |
| Kew Gardens | Weekends Midday | Weekends Midday | N |
| Lancaster Gate | Weekdays PM Peak | Weekends Midday | Y |
| Leicester Square | Weekends Midday | Weekends Midday | N |
| Liverpool Street LU | Weekdays PM Peak | Weekends Midday | Y |
| Mill Hill East | Weekdays PM Peak | Weekdays PM Peak | N |
| Moorgate | Weekdays AM Peak | Weekdays AM Peak | N |
| Paddington TfL | Weekdays Midday | Weekends Midday | N |
| Piccadilly Circus | Weekends Midday | Weekends Midday | N |
| Regent's Park | Weekdays AM Peak | Weekends Midday | Y |
| Richmond | Weekends Midday | Weekends Midday | N |
| St. Paul's | Weekdays AM Peak | Weekdays AM Peak | N |
| Stonebridge Park | Weekdays PM Peak | Weekdays PM Peak | N |
| Tottenham Court Road | Weekends Midday | Weekends Midday | N |
| Vauxhall LU | Weekdays AM Peak | Weekends Midday | Y |
| Wembley Park | Weekdays PM Peak | Weekdays PM Peak | N |
| Woodside Park | Weekdays PM Peak | Weekdays PM Peak | N |

### 3.5 Sub-Regional Movement
* Increase

| inc_link_name | inc_link_count |
|:-----|:-----|
| central-central | 39 |
| central-west | 11 |
| west-west | 9 |
| central-north | 5 |
| east-east | 3 |
| north-central | 3 |
| west-central | 3 |
| east-central | 2 |
| north-north | 1 |
| south-central | 1 |
| south-west | 1 |

* Decrease

| dec_link_name | dec_link_count |
|:-----|:-----|
| central-central | 32 |
| east-central | 12 |
| west-west | 12 |
| central-west | 9 |
| west-central | 4 |
| central-east | 3 |
| central-north | 3 |
| north-north | 3 |

* Changes

| link_name | inc_link_count | dec_link_count | difference | inc_link_per | dec_link_per |
|:-----|:-----|:-----|:-----|:-----|:-----|
| central-central | 39 | 32 | 7 | 54.93% | 45.07% |
| central-east | 0 | 3 | -3 | 0.00% | 100.00% |
| central-north | 5 | 3 | 2 | 62.50% | 37.50% |
| central-west | 11 | 9 | 2 | 55.00% | 45.00% |
| east-central | 2 | 12 | -10 | 14.29% | 85.71% |
| east-east | 3 | 0 | 3 | 100.00% | 0.00% |
| north-central | 3 | 0 | 3 | 100.00% | 0.00% |
| north-north | 1 | 3 | -2 | 25.00% | 75.00% |
| south-central | 1 | 0 | 1 | 100.00% | 0.00% |
| south-west | 1 | 0 | 1 | 100.00% | 0.00% |
| west-central | 3 | 4 | -1 | 42.86% | 57.14% |
| west-west | 9 | 12 | -3 | 42.86% | 57.14% |


## Conclusion

From 2019 to 2022, total weekly exits per station dropped by 21.15% on average,
with only six stations experiencing traffic growth.

1. East-Central Decline: Mobility between Central and East regions have
significantly declined, while intra-East mobility has increased. Stratford rose
from the 5th to the 3rd most visited station, remaining the top destination for
the most stations. This suggests a decreasing popularity of Central London
destinations and increased local development for residents of the East.

2. Shifts in Intra-Central Traffic: Leisure-centric stations like Tottenham Court
Road have seen significant traffic growth, while six work-centric stations in
Central London—including Bank, Monument, Barbican, and Cannon Street—
have experienced a marked decline. Additionally, key stations like Lancaster
Gate, Liverpool St, Regent's Park and Vauxhall have shifted from weekday rush
to weekend midday peaks, highlighting Central London’s transformation into a
leisure district.

3. Moorgate's Rise: Moorgate is the only Central London work hub with rising
exits, driven by traffic from northern stations like Mill Hill East, indicating more
professionals commuting from North London.

4. Mill Hill East: Mill Hill East has experienced significant growth in traffic from
North to Central, particularly to leisure-centric stations like Tottenham Court
Road and work-centric stations like Moorgate, reinforcing its appeal as a
residential area for professionals.

5. Changing Centrality in the West: Ealing Broadway has seen a substantial
45.9% drop in total weekly exits, signalling a decline in its appeal as a
residential destination. Richmond experienced the largest drop, at 59.21%,
suggesting a loss of interest in tourist and leisure activities. However, stations
like Kensington (Olympia) and Stonebridge Park have seen traffic increases,
indicating their growing appeal as leisure and residential hubs, and a shift in
the West’s centrality.

Overall, the research suggests a post-pandemic reshaping of London’s
underground traffic, with local development in areas like Stratford, shifting
commuter patterns favouring North and parts of West London, and a decline in
Central London’s traditional work hubs as the city adapts to changing work
environments and leisure preferences.