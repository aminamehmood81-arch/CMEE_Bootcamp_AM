"""Examples of for and while loops."""

# FOR loops
for i in range(5):
    print(i)  # this loop ends at 4 as the count starts from 0

my_list = [0, 2, "geronimo!", 3.0, True, False]
for k in my_list:
    print(k)  # prints each value of different types e.g. integer, string, float, boolean

total = 0
summands = [0, 1, 11, 111, 1111]
for s in summands:
    total = total + s
    print(total)  #  prints the running total: 0, 1, 12, 123, 1234

# While loop
z = 0
while z < 100:
    z = z + 1
    print(z)  # it will read from 1 upto 100 because we are adding 1