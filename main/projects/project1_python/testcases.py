import unittest
from library import Library
from book import Book
from user import User

class TestBook(unittest.TestCase):
    def setUp(self):
        # print("setUp Book Test")
        self.book1 = Book("Book1", "Joshua", "100")
        self.book2 = Book("Book2", "Josh", "101")
        self.book3 = Book("Book3", "Jo", "102")
        
    def tearDown(self):
        pass
        
    def test_borrow_book(self):
        self.book1.borrow_book()
        self.assertFalse(self.book1.available)
        self.book2.borrow_book()
        self.assertFalse(self.book2.available)
        self.book3.borrow_book()
        self.assertFalse(self.book3.available)
        
    def test_return_book(self):
        self.book1.return_book()
        self.assertTrue(self.book1.available)
        self.book2.return_book()
        self.assertTrue(self.book2.available)
        self.book3.return_book()
        self.assertTrue(self.book3.available)
        
    def test_str(self):
        self.assertEqual(str(self.book1), "Title: Book1, Author: Joshua, ISBN: 100, Available: True")
        self.assertEqual(str(self.book2), "Title: Book2, Author: Josh, ISBN: 101, Available: True")
        self.assertEqual(str(self.book3), "Title: Book3, Author: Jo, ISBN: 102, Available: True") 
    
class TestUser(unittest.TestCase):
    def setUp(self):
        # print("setUp User Test")
        self.user1 = User("User1", "100")
        self.user2 = User("User2", "101")
        self.user3 = User("User3", "102")
        
        self.user1.borrow_book("book4")
        self.user2.borrow_book("book5")
        self.user3.borrow_book("book6")
        
        
    def tearDown(self):
        pass
        # print("tearDown User Test")
        
    def test_borrow_book(self):
        self.user1.borrow_book("book1")
        self.assertIn("book1", self.user1.borrowed_books)
        self.user2.borrow_book("book2")
        self.assertIn("book2", self.user2.borrowed_books)
        self.user3.borrow_book("book3")
        self.assertIn("book3", self.user3.borrowed_books)
        
    def test_return_book(self):
        self.user1.return_book("book4")
        self.assertNotIn("book4", self.user1.borrowed_books)
        self.user2.return_book("book5")
        self.assertNotIn("book5", self.user2.borrowed_books)
        self.user3.return_book("book6")
        self.assertNotIn("book6", self.user3.borrowed_books)
    
    def test_view_borrowed_books(self):
        self.user1.view_borrowed_books()
        self.assertIn("book4", self.user1.borrowed_books)
        self.user2.view_borrowed_books()
        self.assertIn("book5", self.user2.borrowed_books)
        self.user3.view_borrowed_books()
        self.assertIn("book6", self.user3.borrowed_books)
        
        self.user1.borrow_book("book1")
        self.user1.view_borrowed_books()
        self.assertIn("book1", self.user1.borrowed_books)
        self.user2.borrow_book("book2")
        self.user2.view_borrowed_books()
        self.assertIn("book2", self.user2.borrowed_books)
        self.user3.borrow_book("book3")
        self.user3.view_borrowed_books()
        self.assertIn("book3", self.user3.borrowed_books)
    
class TestLibrary(unittest.TestCase):
    def setUp(self):
        # The books have to be created before they can be added to the library
        self.book1 = Book("Book1", "Joshua", "101")
        self.book2 = Book("Book2", "Josh", "102")
        self.book3 = Book("Book3", "Jo", "103")
        self.book7 = Book("Book7", "Joshua", "107")
        self.book8 = Book("Book8", "Josh", "108")
        self.book9 = Book("Book9", "Jo", "109")

        # The users have to be created before they can be added to the library
        self.user1 = User("User1", "100")
        self.user2 = User("User2", "101")
        self.user3 = User("User3", "102")

        self.library1 = Library()
        self.library1.add_book(self.book1)
        self.library1.add_book(self.book2)
        self.library1.add_book(self.book3)

        self.library1.add_user(self.user1)
        self.library1.add_user(self.user2)
        self.library1.add_user(self.user3)

        self.library1.add_book(self.book7)
        self.library1.add_book(self.book8)
        self.library1.add_book(self.book9)
        self.library1.borrow_book(self.user1, self.book7)
        self.library1.borrow_book(self.user2, self.book8)
        self.library1.borrow_book(self.user3, self.book9)
        
    def tearDown(self):
        pass
    
    def test_add_book(self):
        self.assertIn(self.book1, self.library1.books)
        self.assertIn(self.book2, self.library1.books)
        self.assertIn(self.book3, self.library1.books)

        self.book4 = Book("Book4", "Joshua", "104")
        self.book5 = Book("Book5", "Josh", "105")
        self.book6 = Book("Book6", "Jo", "106")

        self.library1.add_book(self.book4)
        self.assertIn(self.book4, self.library1.books)
        self.library1.add_book(self.book5)
        self.assertIn(self.book5, self.library1.books)
        self.library1.add_book(self.book6)
        self.assertIn(self.book6, self.library1.books)
        
    def test_remove_book(self):
        self.assertIn(self.book1, self.library1.books)
        self.library1.remove_book(self.book1)
        self.assertNotIn(self.book1, self.library1.books)
        self.assertIn(self.book2, self.library1.books)
        self.library1.remove_book(self.book2)
        self.assertNotIn(self.book2, self.library1.books)
        self.assertIn(self.book3, self.library1.books)
        self.library1.remove_book(self.book3)
        self.assertNotIn(self.book3, self.library1.books)
        
    def test_add_user(self):
        self.assertIn(self.user1, self.library1.users)
        self.assertIn(self.user2, self.library1.users)
        self.assertIn(self.user3, self.library1.users)

        self.user4 = User("User4", "104")
        self.user5 = User("User5", "105")
        self.user6 = User("User6", "106")
        
        self.library1.add_user(self.user4)
        self.assertIn(self.user4, self.library1.users)
        self.library1.add_user(self.user5)
        self.assertIn(self.user5, self.library1.users)
        self.library1.add_user(self.user6)
        self.assertIn(self.user6, self.library1.users)

    def test_remove_user(self):
        self.assertIn(self.user1, self.library1.users)
        self.library1.remove_user(self.user1)
        self.assertNotIn(self.user1, self.library1.users)
        self.assertIn(self.user2, self.library1.users)
        self.library1.remove_user(self.user2)
        self.assertNotIn(self.user2, self.library1.users)
        self.assertIn(self.user3, self.library1.users)
        self.library1.remove_user(self.user3)
        self.assertNotIn(self.user3, self.library1.users)

    def test_borrow_book(self):
        self.library1.borrow_book(self.user1, self.book1)
        self.assertIn(self.book1, self.user1.borrowed_books)
        self.library1.borrow_book(self.user2, self.book2)
        self.assertIn(self.book2, self.user2.borrowed_books)
        self.library1.borrow_book(self.user3, self.book3)
        self.assertIn(self.book3, self.user3.borrowed_books)
        
    def test_return_book(self):
        self.assertIn(self.book7, self.user1.borrowed_books)
        self.library1.return_book(self.user1, self.book7)
        self.assertNotIn(self.book7, self.user1.borrowed_books)

        self.assertIn(self.book8, self.user2.borrowed_books)
        self.library1.return_book(self.user2, self.book8)
        self.assertNotIn(self.book8, self.user2.borrowed_books)

        self.assertIn(self.book9, self.user3.borrowed_books)
        self.library1.return_book(self.user3, self.book9)
        self.assertNotIn(self.book9, self.user3.borrowed_books)
    
    def test_list_available_books(self):
        available_books = self.library1.list_available_books()
        self.assertIn(self.book1, available_books)
        self.assertIn(self.book2, available_books)
        self.assertIn(self.book3, available_books)
        self.assertNotIn(self.book7, available_books)
        self.assertNotIn(self.book8, available_books)
        self.assertNotIn(self.book9, available_books)
        
    def test_list_not_available_books(self):
        not_available_books = self.library1.list_not_available_books()
        self.assertIn(self.book7, not_available_books)
        self.assertIn(self.book8, not_available_books)
        self.assertIn(self.book9, not_available_books)
        self.assertNotIn(self.book1, not_available_books)
        self.assertNotIn(self.book2, not_available_books)
        self.assertNotIn(self.book3, not_available_books)

if __name__ == "__main__":
    unittest.main()
