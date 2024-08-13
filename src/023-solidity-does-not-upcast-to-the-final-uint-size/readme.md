# Explanation of Vulnerability
No Upcasting During Multiplication:

# In Solidity, arithmetic operations on smaller integer types (like uint8) do not automatically upcast to larger types (like uint256). The multiplication a * b is performed using uint8 arithmetic, which can overflow.
Potential Overflow:

The maximum value for uint8 is 255. If the product of a and b exceeds 255, it will overflow and wrap around according to the rules of uint8 arithmetic, resulting in incorrect values.
Mitigation Strategy
To prevent overflow, explicitly cast the uint8 values to uint256 before performing the multiplication. This ensures that the multiplication is performed using uint256 arithmetic, which can handle larger values.