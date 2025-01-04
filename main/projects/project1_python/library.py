
class Library:
    from user import User
    from book import Book

    name = str
    
    books = list
    users = list
    
    def __init__(self, name=None):
        self.books = []
        self.users = []
        self.name = name
        
    # add_book: Adds a new book to the library.
    def add_book(self, book):
        self.books.append(book)
        
    # remove_book: Removes a book from the library.
    def remove_book(self, book):
        self.books.remove(book)
        
    # add_user: Registers a new user.
    def add_user(self, user):
        self.users.append(user)
        
    # remove_user: Removes a user from the library.
    def remove_user(self, user):
        self.users.remove(user)
        
    # borrow_book: Facilitates borrowing by interacting with User and Book classes. 
    def borrow_book(self, user, book):
        if book in self.books and user in self.users:
            book.borrow_book()
            user.borrow_book(book)
        else:
            print("Book or user not found.")
            
    # return_book: Facilitates returning by interacting with User and Book classes.
    def return_book(self, user, book):
        if book in self.books and user in self.users:
            book.return_book()
            user.return_book(book)
        else:
            print("Book or user not found.")
            
    # list_available_books: Displays all available books in the library.
    def list_available_books(self):
        available_books = [book for book in self.books if book.available]
        # for book in available_books:
            # print(str(book))
        return available_books
        # for book in self.books:
        #     if book.available:
        #         print(book)
                
    # Extra List books not available
    def list_not_available_books(self):
        not_available_books = [book for book in self.books if not book.available]
        # for book in not_available_books:
            # print(str(book))
        return not_available_books
        # for book in self.books:
        #     if not book.available:
        #         print(book)
    
 
