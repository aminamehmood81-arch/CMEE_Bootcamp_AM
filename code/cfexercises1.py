"""Small functions: square root, larger value, sorting, and three factorials."""                              

def foo_1(x):
    """Return the square root of x."""
    return x ** 0.5

def foo_2(x, y):
    """Return the larger of x and y."""
    if x > y:
        return x
    return y

def foo_3(x, y, z):
    """Return a list of x, y, z in ascending order."""
    if x > y:
        x, y = y, x
    if x > z:
        x, z = z, x
    if y > z:
        y, z = z, y
    return [x, y, z]

def foo_4(x):
    """Return the factorial of x."""
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return result


def foo_5(x):
    """Return the factorial of x (recursive)."""
    if x <= 1:
        return 1
    return x * foo_5(x - 1)

def foo_6(x):
    """Return the factorial of x (while loop)."""
    facto = 1
    while x >= 1:
        facto = facto * x
        x = x - 1
    return facto


def main():                         
    """Show example results and check the factorial versions agree."""
    print(foo_1(9))                            # expect 3.0
    print(foo_2(3, 7))                         # expect 7
    print(foo_3(5, 1, 3))                      # expect [1, 3, 5]
    print(foo_4(0), foo_5(0), foo_6(0))        # expect 1 1 1
    print(foo_4(5) == foo_5(5) == foo_6(5))    # expect True
    print(foo_4(0) == foo_5(0) == foo_6(0))    # expect True


if __name__ == "__main__":
    main()