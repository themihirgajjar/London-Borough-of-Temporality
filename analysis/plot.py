import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns

# x axis values
x =['sun', 'mon', 'fri', 'sat', 'tue', 'wed', 'thu']

# y axis values
y =[5, 6.7, 4, 6, 2, 4.9, 1.8]

# plotting strip plot with seaborn
ax = sns.stripplot(x)

# giving labels to x-axis and y-axis
ax.set(xlabel ='Days', ylabel ='Amount_spend')

# giving title to the plot
plt.title('My first graph')

# function to show plot
plt.show()
