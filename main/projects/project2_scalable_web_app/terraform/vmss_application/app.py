from flask import Flask, render_template
import pyodbc

app = Flask(__name__)

# Database connection function
def fetch_data_from_db():
    conn = pyodbc.connect(
        "Driver={ODBC Driver 18 for SQL Server};"
        "Server=jdmssqlserver.database.windows.net;"
        "Database=jdmssqlserver-db1;"
        "Authentication=ActiveDirectoryMsi;"
        "Encrypt=yes;"
        "TrustServerCertificate=no;"
        "Connection Timeout=30;"
    )
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM Table1")
    rows = cursor.fetchall()
    columns = [column[0] for column in cursor.description]
    conn.close()
    return columns, rows

@app.route("/")
def index():
    # Fetch table data
    columns, rows = fetch_data_from_db()
    return render_template("index.html", columns=columns, rows=rows)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=81)
