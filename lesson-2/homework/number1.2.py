name = "Tom" #input("What is your name? ")
age = 33 #int(input("Age: "))

print("Your name is " + name + " and you are " + str(age) + " years ")
print(f"Your name is {name} and you are {age} years old.")
print("Your name is {name} and you are {age} years old.".format(name=name, age=age))
