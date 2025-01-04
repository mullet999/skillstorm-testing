
print("\n","### Basic Calculator ###")
number1 = 10
print("Number 1: ",number1)
number2 = 5
print("Number 2: ",number2)

def addNum(number1, number2):
    number = number1 + number2
    return number
print("Number 1 + Number 2 = ",addNum(number1, number2))


def subtractNum(number1, number2):
    number = number1 - number2
    return number
print("Number 1 - Number 2 = ",subtractNum(number1, number2))

def multiplyNum(number1, number2):
    number = number1 * number2
    return number
print("Number 1 * Number 2 = ",multiplyNum(number1, number2))

def divideNum(number1, number2):
    number = number1 / number2
    return number
print("Number 1 / Number 2 = ",divideNum(number1, number2))

print("\n")

print("### Minimum ###")
minList = [5,10,2,8,20,4]
print("List: ",minList)
def minimum(list):
    minimum = list[0]
    for l in list:
        if l < minimum:
            minimum = l
    return minimum
print("Minimum: ",minimum(minList))
