import requests
import sqlite3
import pandas as pd
from bs4 import BeautifulSoup

url = 'https://web.archive.org/web/20230902185655/https://en.everybodywiki.com/100_Most_Highly-Ranked_Films'
db_name = 'Movies.db'
table_name = 'Top_50_Since_2000'
csv_path = '/home/project/top_50_films_since_2000.csv'
df = pd.DataFrame(columns=["Average Rank","Film","Year"])
count = 0

html_page = requests.get(url).text
data = BeautifulSoup(html_page, 'html.parser')

tables = data.find_all('tbody')
rows = tables[0].find_all('tr')

for row in rows:
    col = row.find_all('td')
    if len(col)!=0:
        data_dict = {"Average Rank": col[0].contents[0],
                    "Film": col[1].contents[0],
                    "Year": col[2].contents[0]}
        df1 = pd.DataFrame(data_dict, index=[0])
        df = pd.concat([df,df1], ignore_index=True)

# Filter out rows where 'Year' is 'unranked'
df = df[df["Year"] != 'unranked']

# Ensure the 'Year' column is integer type
df["Year"] = df["Year"].astype(int)

# Filter the DataFrame
df = df[df["Year"] >= 2000]

# Select the top 25 rows
df = df.head(25)

print(df)
df.to_csv(csv_path)

conn = sqlite3.connect(db_name)
df.to_sql(table_name, conn, if_exists='replace', index=False)
conn.close()