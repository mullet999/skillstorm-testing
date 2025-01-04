
class User:
    name: str
    user_id: str #unique identifier
    borrowed_books: list

    def __init__(self, name, user_id):
        self.name = name
        self.user_id = user_id
        self.borrowed_books = []
    
    # borrow_book: Allows the user to borrow a book (if available).
    def borrow_book(self, book):
        self.borrowed_books.append(book)

    # return_book: Allows the user to return a borrowed book.
    def return_book(self, book):
        self.borrowed_books.remove(book)

    # view_borrowed_books: Shows all books currently borrowed by the user.
    def view_borrowed_books(self):
        for book in self.borrowed_books:
            print(book)
        

