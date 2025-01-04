
x = 0
while x<10:
    x+=1
    print(x)

print("\n")

groceries = ["milk", "eggs", "bread", "butter", "bacon"]
print(groceries)

for item in groceries:
    groceries[groceries.index(item)] += "ay"
    # item += "ay"
    print(item)

print(groceries)

print("\n")

friends = ["bob", "joe",]
friends.append("sally")

friendsTuple = tuple(friends)
print(friendsTuple)

print("\n")

compDir = {"Dan Pickles" : "(123) 456-7890", "Randolph Scott" : "(456) 789-0123", "Howard Johnson" : "(789) 123-4567"}
print("Company Directory ",compDir)
print("number for Randolph Scott: \n",compDir.get("Randolph Scott"))
