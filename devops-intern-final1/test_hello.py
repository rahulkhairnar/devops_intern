import unittest
import subprocess
import os
import sys

# We change the current working directory to the project folder before running tests
# The CI environment needs to find the files, so we execute the python script directly.
class TestHelloScript(unittest.TestCase):
    """Test suite for the hello.py script."""
    
    def test_output_is_hello_devops(self):
        """Verify that running hello.py produces the expected output."""
        
        # Execute hello.py using subprocess and capture the output
        result = subprocess.run(
            [sys.executable, "hello.py"], # Use sys.executable to ensure the correct python version is used
            capture_output=True,
            text=True,
            check=True
        )
        
        expected_output = "Hello, DevOps!\n"
        
        self.assertEqual(result.stdout, expected_output, "Output does not match 'Hello, DevOps!'")

if __name__ == '__main__':
    unittest.main(exit=False)
