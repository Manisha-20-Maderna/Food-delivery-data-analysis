import pandas as pd
from sqlalchemy import create_engine
import os

# MySQL connection settings
user = 'root'                  
password = 'M28#22'              
host = 'localhost'
database = 'food_delivery'      

# Create SQLAlchemy connection string
engine = create_engine(f"mysql+pymysql://{user}:{password}@{host}/{database}")

# Folder where your raw CSV files are saved
folder = "E:/Food delivery data"

# Map of original file names to MySQL table names
file_table_map = {
    "order_details_table.csv": "raw_order_details",
    "location_details_table.csv": "raw_location_details",
    "delivery_person_table (1).csv": "raw_delivery_person"
}

# Loop to read and upload each file to MySQL
for file_name, table_name in file_table_map.items():
    file_path = os.path.join(folder, file_name)

    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        continue

    print(f" Reading: {file_name}")
    df = pd.read_csv(file_path)

    print(f"Uploading to MySQL table: {table_name}")
    df.to_sql(table_name, con=engine, if_exists='replace', index=False)
    print(f"{table_name} loaded successfully.\n")

print(" All raw food delivery data uploaded to MySQL.")
