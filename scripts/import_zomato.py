import pandas as pd
import mysql.connector

csv_path = r"D:\my career\Zomato market analysis\Datasets\processed\zomato_featured.csv"

df = pd.read_csv(csv_path)

conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="yashtheranger",
    database="zomato_market_analysis"
)

cursor = conn.cursor()

columns = [
    "Restaurant ID", "Restaurant Name", "Country Code", "City",
    "Address", "Locality", "Locality Verbose", "Longitude",
    "Latitude", "Cuisines", "Average Cost for two", "Currency",
    "Has Table booking", "Has Online delivery", "Is delivering now",
    "Price range", "Aggregate rating", "Rating color", "Rating text",
    "Votes", "Rating Bucket", "Price Segment", "Primary Cuisine",
    "Cuisine Count", "Popularity Category", "Service Segment"
]

placeholders = ", ".join(["%s"] * len(columns))
column_names = ", ".join(f"`{col}`" for col in columns)

query = f"""
INSERT INTO restaurants ({column_names})
VALUES ({placeholders})
"""

data = [
    tuple(None if pd.isna(value) else value for value in row)
    for row in df[columns].itertuples(index=False, name=None)
]

cursor.executemany(query, data)
conn.commit()

print("Rows imported:", cursor.rowcount)

cursor.close()
conn.close()