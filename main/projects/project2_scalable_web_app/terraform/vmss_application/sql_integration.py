import pyodbc
from azure.identity import DefaultAzureCredential

# Database connection details
server = 'jdmssqlserver.database.windows.net'
database = 'jdmssqlserver-db1'
table_name = 'Table1'  # Replace with the desired table name

# Use the managed identity of the VMSS
credential = DefaultAzureCredential()

# Get the access token for Azure SQL
token = credential.get_token("https://database.windows.net/")
access_token = token.token

# Corrected attribute dictionary key
SQL_COPT_SS_ACCESS_TOKEN = 1256  # Correct integer constant for access token

try:
# Connect to the database
    conn = pyodbc.connect(
        "Driver={ODBC Driver 18 for SQL Server};"
        "Server=jdmssqlserver.database.windows.net;"
        "Database=jdmssqlserver-db1;"
        "Authentication=ActiveDirectoryMsi;"
        "Encrypt=yes;"
        "TrustServerCertificate=no;"
        "Connection Timeout=30;"
    )
    print("Connection successful!")
except pyodbc.Error as e:
    print(f"Error connecting to the database: {e}")

cursor = conn.cursor()

# Check if the table exists, and create it if it doesn't
table_creation_query = f"""
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = '{table_name}')
BEGIN
    CREATE TABLE {table_name} (
        ID INT IDENTITY(1,1) PRIMARY KEY,
        Column1 NVARCHAR(255) NOT NULL,
        Column2 NVARCHAR(255) NOT NULL
    )
END
"""
cursor.execute(table_creation_query)
conn.commit()
print(f"Table '{table_name}' is ready for data.")

# Insert data into the table
data_to_insert = ("Example Data", "12345")  # Replace with your actual data
cursor.execute(
    f"INSERT INTO {table_name} (Column1, Column2) VALUES (?, ?)",
    data_to_insert[0], data_to_insert[1]  # Positional parameters
)
conn.commit()
print(f"Data inserted into table '{table_name}' successfully.")


cursor.execute(
    f"SELECT * FROM {table_name}"
)
# Fetch and print the data
rows = cursor.fetchall()
for row in rows:
    print(row)

# Close the connection
cursor.close()
conn.close()

