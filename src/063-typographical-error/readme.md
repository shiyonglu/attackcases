# Typographical Error

### Description:
A typographical error can occur for example when the intent of a defined operation is to sum a number to a variable (+=) but it has accidentally been defined in a wrong way (=+), introducing a typo which happens to be a valid operator. Instead of calculating the sum it initializes the variable again.

### Remediation:
The weakness can be avoided by performing pre-condition checks on any math operation or using a vetted library for arithmetic calculations such as SafeMath developed by OpenZeppelin.

**NOTE**: The statement x =+ 1 used to be valid, but later versions of solidity make this syntax invalid. In the past, this could be misread as an increment.

### References:
[https://swcregistry.io/docs/SWC-129](https://swcregistry.io/docs/SWC-129)