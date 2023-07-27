# from sqlalchemy import create_engine

# engine = create_engine(
#     "postgresql://postgres:postgres@localhost:5432/your_test_db", echo=True, future=True
# )

from sqlalchemy import create_engine, text
import pandas as pd
from pandas.io.json import build_table_schema

# # Replace these with your connection details
# USERNAME = 'mockuser'
# PASSWORD = 'mockpassword'
# HOST = 'localhost'
# DB_NAME = 'mockdb'

# Establish the connection
DATABASE_URL = f"postgresql://postgres:postgres@localhost:5432/your_test_db"
engine = create_engine(DATABASE_URL)

# Query for the first 100 records
with engine.connect() as connection:
    result = connection.execute(text("SELECT * FROM mock_data_types LIMIT 100"))
    records = result.fetchall()

# Convert the result to a pandas DataFrame
df = pd.DataFrame(records, columns=result.keys())

df['col_timestamp'] = df['col_timestamp'].dt.tz_localize(None)
df['col_timestamptz'] = df['col_timestamptz'].dt.tz_localize(None)

print(df.head())
print(df.dtypes)

# Serialize to JSON
# json_data = df.to_json(orient="table")

# print(json_data)

print("----")
# Using build table schema

schema = build_table_schema(df)


# Here, we're combining the schema and the data for a full representation
full_representation = {"schema": schema, "data": df.to_dict(orient="records")}

import json

def custom_serializer(obj):
    if isinstance(obj, memoryview):
        return str(obj)
    elif isinstance(obj, pd.Timestamp):
        return obj.strftime('%Y-%m-%d %H:%M:%S')
    else:
        return str(obj)

full_representation = {"schema": schema, "data": df.to_dict(orient="records")}
json_output = json.dumps(full_representation, default=custom_serializer, indent=4)
print(json_output)