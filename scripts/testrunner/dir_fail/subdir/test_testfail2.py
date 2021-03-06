import unittest
from testfail2 import DummyTest2

class Test_Test21(unittest.TestCase):
    
    def setUp(self):
        self.dummytest = DummyTest2()
        
    def test_test1(self):
        self.assertTrue(self.dummytest.dummy1(),1)
        
    def test_test2(self):
        self.assertTrue(self.dummytest.dummy2(),2)
        
class Test_Test22(unittest.TestCase):
    def setUp(self):
        self.dummytest = DummyTest2()
        
    def test_test1(self):
        self.assertTrue(self.dummytest.dummy3(),3)
        
    def test_test2(self):
        self.assertTrue(self.dummytest.dummy4(),4)

if __name__ == "__main__":

    suite = unittest.TestLoader().loadTestsFromTestCase(Test_Test21)
    suite = unittest.TestLoader().loadTestsFromTestCase(Test_Test22)
    unittest.TextTestRunner(verbosity=2).run(suite)
