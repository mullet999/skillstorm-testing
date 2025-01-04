
file_path = "numbers.txt"

def read_file():
    with open(file_path, "r") as file:
        print("\n","file opened for read: ",not file.closed,"\n")
        for line in file: 
            print(line)
    print("\n","file closed: ",file.closed,"\n")
      
def write_file():  
    with open(file_path, "a") as file:
        print("\n","file opened for append: ",not file.closed,"\n")
        file.write("\nHello File")
    print("\n","file closed: ",file.closed,"\n")


read_file()
write_file()
read_file()
