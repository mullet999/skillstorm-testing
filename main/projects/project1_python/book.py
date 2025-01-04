
class Book:
    title: str
    author: str
    isbn: str # Unique identifier
    available: bool

    def __init__(self, title, author, isbn, available=True):
        self.title = title
        self.author = author
        self.isbn = isbn
        self.available = available

    # __str__: A string representation of the book.
    def __str__(self):
        return f"Title: {self.title}, Author: {self.author}, ISBN: {self.isbn}, Available: {self.available}"

    # borrow_book: Marks the book as borrowed (not available).
    def borrow_book(self):
        self.available = False

    # return_book: Marks the book as returned (available).
    def return_book(self):
        self.available = True
        
    
