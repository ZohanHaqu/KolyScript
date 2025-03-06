# This is a simple KolyScript example
# It demonstrates defining variables, calculating, looping, and printing.

# Define a variable called 'x' and assign it a value of 10.
define x 10

# Print the value of 'x'
print x

# Calculate a simple expression (5 + 3) and store the result in 'y'
define y calculate 5 + 3

# Print the result of the calculation
print y

# Check if 'x' is greater than 5 and print a message accordingly
if x > 5 {
    echo "x is greater than 5!"
} else {
    echo "x is less than or equal to 5."
}

# Use a loop to print numbers from 1 to 5
for i from 1 to 5 {
    echo "Number: i"
}

# Wait for 2 seconds
wait 2

# Ask the user for their name and print a greeting
input name
echo "Hello, name! Welcome to KolyShell!"

# Exit the script
exit
