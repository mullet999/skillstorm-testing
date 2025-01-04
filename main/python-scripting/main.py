from package_structure.hello_world.hello_world import hello
import package_structure.calculator.calculator as calculator

def runCalculator():
    print("\n","### Calculates 2 numbers ###")
    try:
        number1 = int(input("Type in number 1: "))
    except:
        print("Not a number setting to 0")
        number1 = 0
    try:
        number2 = int(input("Type in number 2: "))
    except:
        print("Not a number setting to 0")
        number2 = 0
    print("\n")
    print("Number 1 + Number 2 = ",calculator.addNum(number1, number2))
    print("\n")
    print("Number 1 - Number 2 = ",calculator.subtractNum(number1, number2))
    print("\n")
    print("Number 1 * Number 2 = ",calculator.multiplyNum(number1, number2))
    print("\n")
    if number2 == 0:
        print("undifined")
    else:    
        print("Number 1 / Number 2 = ",calculator.divideNum(number1, number2))
    print("\n")


# Gets a list of function names defined in the current file.
def get_functions():

    import inspect
    import sys

    current_module = sys.modules[__name__]
    functions = []
    for name, obj in inspect.getmembers(current_module):
        i = 1
        if inspect.isfunction(obj) and obj.__module__ == __name__:
            if obj.__name__ != 'get_functions' and obj.__name__ != 'main':
                functions.append(str(i) + ":" + name)
                i+=1
    return functions

def main():
    print("\n","What function do you want to run?")
    print("Posible functions are: ",get_functions())
    functionNumber = int(input("Type in function number: "))
    if functionNumber == 1:
        runCalculator()
main()

# Stopped on Python Programming II