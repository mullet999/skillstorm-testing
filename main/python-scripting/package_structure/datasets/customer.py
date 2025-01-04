
import csv

# Using the following Customer class, 
# Write a function that parses the CSV file and returns a list of Customer objects.
# Call this function and print the data for each object to the console.

file_path = "customers.csv"

class Customer: 
    name: str
    email: str
    balance: float

    def __init__(self, name, email, balance):
        self.name = name
        self.email = email
        self.balance = balance
      
        
        
class CSV_Parser:

    def parse_file(self):
        # store users in a list and return it
        customer_list = []

        # open the csv file
        with open(file_path, "r") as file:

            # delimiter is the character that separates each column
            csv_reader = csv.reader(file, delimiter=",")
            
            # skip the headers with next() or a line counter
            next(csv_reader)

            for row in csv_reader: 
                c = Customer(row[0] + " " + row[1], row[2], float(row[3]))
                customer_list.append(c)
         
        return customer_list
    
c_list = CSV_Parser().parse_file()
print(c_list)
for c in c_list:
    print(c.name, c.email, c.balance)
