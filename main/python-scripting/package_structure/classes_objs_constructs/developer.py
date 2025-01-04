from pydantic import BaseModel

class User(BaseModel):
    id: int
    name: str
    
    id = 0
    name = ""
    
    def report(self):
        print("ID: " + str(self.id) + " Name: " + self.name)



class Person:
    name : str
    salary : float
    
    def report(self):
        print("Name: " + self.name)


class Developer(Person):
    language : str

    def __init__(self, name, salary, language):
        self.name = name
        self.salary =   salary
        self.language = language

    def report(self):
        print("Name: " + self.name + " Language: " + self.language)
        
        
class Customer(Person):
    cash : float
    
    def __init__(self, name, cash):
        self.name = name
        self.cash = cash


# here we create an object and call its method
Dan = Developer("Dan Pickles", 100000, "Python")
Randolph = Developer("Randolph Scott", 90000, "SQL")
Howard = Developer("Howard Johnson", 70000, "Java")

John = Customer("John Doe", 1000)

Dan.report()
Randolph.report()
Howard.report()

John.report()


Jane = User()
Jane.report()
