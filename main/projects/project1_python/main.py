# I will use this to start my "application" and accept user input to run functions from the library, book, and user classes.

from library import Library
from book import Book
from user import User

librarys = []
running = True
managing_librarys = False
managing_users = False
managing_books = False

while running == True:
    print("Welcome to the Library Management System!")

    if len(librarys) == 0:
        print("No libraries found. Would you like to create one? (y/n)")
        choice = input("Enter your choice (y/n): ")
        if choice == "y":
            library_name = input("Enter the name of the library: ")
            library = Library(library_name)
            librarys.append(library)
            print(str(library_name) + " created.")
        else:
            print("Goodbye!")
            running = False
            break
    else:
        print("Libraries found:")
        print("What would you like to do:")
        print("Select an option:")
        print("1. Create a new library?")
        print("2. Manage libraries?")
        print("3. Delete a library?")
        print("4. Exit")
        choice = input("Enter your choice (1-4): ")

        if choice == "1":
            library_name = input("Enter the name of the library: ")

            if any(library_name == library.name for library in librarys): 
                print("Library already exists.")
                continue
            else:
                library = Library(library_name)
                librarys.append(library)
                print(str(library_name) + " created.")

        elif choice == "2":           
            for i, library in enumerate(librarys):
                print(f"{i + 1}. {library.name}")
            print("0. Back")
            print("which library would you like to view?")
            l = len(librarys)
            choice = input("Enter your choice: ")
            if int(choice) == 0:
                continue
            elif int(choice) > l or int(choice) < 1:
                print("Invalid choice.")
                continue
            else:
                library = librarys[int(choice) - 1]
                managing_librarys = True
                while managing_librarys == True:
                    print("Library " + library.name + " Selected.")
                    print("What would you like to do:")
                    print("Select an option:")
                    print("1. Manage users")
                    print("2. Manage books")
                    print("3. View available books")
                    print("4. Borrow a book")
                    print("5. View borrowed books")
                    print("6. Return a book")
                    print("7. Back")
                    choice = input("Enter your choice (1-7): ")

                    if choice == "1":
                        managing_users = True
                        while managing_users == True:
                            print("Select an option:")
                            print("1. View users?")
                            print("2. Add a user?")
                            print("3. Remove a user?")
                            print("4. Back")
                            choice = input("Enter your choice (1-4): ")
                            if choice == "1":
                                if len(library.users) == 0:
                                    print("No users found.")
                                    continue
                                else:
                                    print("Users:")
                                    for user in library.users:
                                        print(user.name)

                            elif choice == "2":
                                user_name = input("Enter the name of the user: ")
                                if any(user_name == user.name for user in library.users): 
                                    print("User already exists.")
                                    continue
                                else:
                                    if len(library.users) == 0:
                                        user_id = "1"
                                    else:
                                        user_id = str(int(max(user.user_id for user in library.users)) + 1)
                                    user = User(user_name, user_id)
                                    library.add_user(user)
                                    print( user_name + " added.")

                            elif choice == "3":
                                user_name = input("Enter the name of the user: ")
                                user =  next((user for user in library.users if user.name == user_name), None)
                                if user:
                                    library.remove_user(user)
                                    print(user_name + " removed.")
                                else:
                                    print("User not found.")

                            elif choice == "4":
                                managing_users = False
                                break

                    elif choice == "2":
                        managing_books = True
                        while managing_books == True:
                            print("Select an option:")
                            print("1. View books?")
                            print("2. Add a book?")
                            print("3. Remove a book?")
                            print("4. Back")
                            choice = input("Enter your choice (1-4): ")
                            if choice == "1":
                                if len(library.books) == 0:
                                    print("No books found.")
                                    continue
                                else:
                                    print("Books:")
                                    for book in library.books:
                                        print(book.title)

                            elif choice == "2":
                                book_title = input("Enter the title of the book: ")
                                if any(book_title == book.title for book in library.books):
                                    print("Book already exists.")
                                else:
                                    if len(library.books) == 0:
                                        isbn = "0000001"
                                    else:
                                        isbn = str(int(max(book.isbn for book in library.books)) + 1).zfill(len(isbn))
                                    author = input("Enter the author of the book: ")
                                    book = Book(book_title, author, isbn)
                                    library.add_book(book)
                                    print(book_title + " added.")

                            elif choice == "3":
                                book_title = input("Enter the title of the book: ")
                                book = next((book for book in library.books if book.title == book_title), None)
                                if book:
                                    library.remove_book(book)
                                    print(book_title + " removed.")
                                else:
                                    print("Book not found.")

                            elif choice == "4":
                                managing_books = False
                                break

                    elif choice == "3":
                        if len(library.books) == 0:
                            print("No books found.")
                            continue
                        else:
                            print("Available books:")
                            for book in library.list_available_books():
                                print(book)

                    elif choice == "4":
                        if len(library.users) == 0 or len(library.books) == 0:
                            print("No users and/or books found.")
                            continue
                        else:
                            user_name = input("Enter the name of the user: ")
                            user = next((user for user in library.users if user.name == user_name), None)
                            if user == None:
                                print("User not found.")
                                continue
                            else:
                                book_title = input("Enter the name of the book: ")
                                book = next((book for book in library.books if book.title == book_title), None)
                                if book == None:
                                    print("Book not found.")
                                    continue
                                else:
                                    library.borrow_book(user, book)
                                    print(user_name + " borrowed " + book_title + ".")

                    elif choice == "5":
                        if len(library.books) == 0:
                            print("No books found.")
                            continue
                        else:
                            print("Borrowed books:")
                            for book in library.list_not_available_books():
                                print(book)

                    elif choice == "6":
                        if len(library.users) == 0 or len(library.books) == 0:
                            print("No users and/or books found.")
                            continue
                        else:
                            user_name = input("Enter the name of the user: ")
                            book_title = input("Enter the name of the book: ")
                            user = next((user for user in library.users if user.name == user_name), None)
                            book = next((book for book in library.books if book.title == book_title), None)
                            if user == None or book == None:
                                print("User or book not found.")
                                continue
                            else:
                                if not any(book_title == borrowed_book.title for borrowed_book in user.borrowed_books):
                                    print("User has not borrowed this book.")
                                    continue
                                else:
                                    library.return_book(user, book)
                                    print(user_name + " returned " + book_title + ".")

                    elif choice == "7":
                        managing_librarys = False
                        break
                    else:
                        print("Invalid choice. Please try again.")

        elif choice == "3":
            library_name = input("Enter the name of the library to delete: ")
            library = next((library for library in librarys if library.name == library_name), None)
            if library == None:
                print("Library not found.")
            else:
                librarys.remove(library)
                print(library_name + " deleted.")

        elif choice == "4":
            print("Goodbye!")
            running = False
            break




    





