# What is integer overflow and underflow?
Integer overflow occurs when the result of an arithmetic operation on an integer exceeds the maximum representable value for that data type.
For example, if you have an 8-bit unsigned integer (uint8) with a maximum value of 255 and you add 1 to it, the result will be 256, which is greater than the maximum value for a uint8, causing an overflow.
In most programming languages, when an overflow occurs, the value wraps around to the minimum representable value, which is 0 for unsigned integers.

```solidity 

uint8 x = 255;
x = x + 1; // This causes an overflow, and 'x' becomes 0.

``` 

Integer underflow is the opposite of overflow. It occurs when the result of an arithmetic operation on an integer falls below the minimum representable value for that data type.
For example, if you subtract 1 from an unsigned integer with a value of 0, it will result in an underflow, and the value will wrap around to the maximum representable value for that data type.

```solidity
uint8 y = 0;
y = y - 1; // This causes an underflow, and 'y' becomes 255 (maximum value for a uint8).
```


# How does it happen?
Overflow occurs when the result of an arithmetic operation exceeds the maximum value representable for the data type, while underflow happens when the result falls below the minimum representable value for that data type. These errors can lead to unexpected and potentially insecure behavior in programs and smart contracts.

# Example of underflow.



# How to prevent?
There exists a number of solutions for overflwo and underflow in solidity inclusing using the library, or use manual check and even use large data types. large data types wtill increase memory and gas cost. 
## Safe Math Libraries:
Use established safe math libraries like OpenZeppelin's SafeMath or Solidity's built-in SafeMath library (available from Solidity version 0.8.0 and later).
These libraries provide functions for performing arithmetic operations with overflow and underflow checks, ensuring that your calculations won't result in unexpected behavior.
Example (using Solidity's built-in SafeMath library):

```solidity
// Import SafeMath library
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract SafeMathExample {
    using SafeMath for uint256;

    uint256 public total;

    function add(uint256 a, uint256 b) public {
        total = a.add(b); // Safe addition with overflow check
    }

    function subtract(uint256 a, uint256 b) public {
        total = a.sub(b); // Safe subtraction with underflow check
    }
}
```


## Explicit check:
Implement manual checks to ensure that arithmetic operations won't lead to overflow or underflow.
You can use conditional statements (if statements) to verify that the result of an operation is within acceptable bounds before updating state variables.
Example (explicit check):

 ```solidity 
uint256 public total;

function safeAdd(uint256 a, uint256 b) public {
    require(a + b >= a, "Overflow detected");
    total = a + b;
}

function safeSubtract(uint256 a, uint256 b) public {
    require(a >= b, "Underflow detected");
    total = a - b;
}




``` 


## Use Larger Data Types:
Choose data types with larger ranges if possible to reduce the likelihood of overflow or underflow. For example, use uint256 instead of uint8 when dealing with larger values.
 

# How to use our code: 
First you need to deploy the contact Underflow and copy the address.
Then you need to deploy the contact Attacker and at the time of deployement it will take the address of the Undeflow contact.
When deployment is done use any value >=5 and execute the transfer funciton. 
Check the balance of your account.
