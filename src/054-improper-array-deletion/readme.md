# Improper Array Deletion Vulnerability

#### Description:
In Solidity, using the `delete` function to remove an element from an array does not actually reduce the array's length. Instead, it sets the value at the specified index to zero, which can lead to unexpected behavior and potential vulnerabilities.

#### Example:
Consider the following Solidity code:

```solidity
pragma solidity ^0.8.0;

contract Example {
    uint[] public numbers;

    function addNumber(uint _number) public {
        numbers.push(_number);
    }

    function deleteNumber(uint index) public {
        delete numbers[index];
    }

    function getLength() public view returns (uint) {
        return numbers.length;
    }
}
```

In this example, if we add numbers `[1, 2, 3, 4, 5]` to the array and then call `deleteNumber(2)`, the array will become `[1, 2, 0, 4, 5]`. The length of the array remains 5, but the value at index 2 is set to zero¹.

#### Prevention:
1. **Use Push and Pop Functions**: Instead of using `delete`, use the `push` and `pop` functions to manage array elements. This ensures that the array length is adjusted correctly.
   ```solidity
   pragma solidity ^0.8.0;

   contract Example {
       uint[] public numbers;

       function addNumber(uint _number) public {
           numbers.push(_number);
       }

       function removeNumber(uint index) public {
           require(index < numbers.length, "Index out of bounds");
           numbers[index] = numbers[numbers.length - 1];
           numbers.pop();
       }

       function getLength() public view returns (uint) {
           return numbers.length;
       }
   }
   ```

2. **Shift Elements**: Another approach is to shift elements from right to left to fill the gap created by the deleted element.
   ```solidity
   pragma solidity ^0.8.0;

   contract Example {
       uint[] public numbers;

       function addNumber(uint _number) public {
           numbers.push(_number);
       }

       function removeNumber(uint index) public {
           require(index < numbers.length, "Index out of bounds");
           for (uint i = index; i < numbers.length - 1; i++) {
               numbers[i] = numbers[i + 1];
           }
           numbers.pop();
       }

       function getLength() public view returns (uint) {
           return numbers.length;
       }
   }
   ```

By following these best practices, you can ensure that your arrays are managed correctly, preventing unexpected behavior and potential vulnerabilities.



¹: [Improper Array Deletion in Solidity](https://blog.solidityscan.com/improper-array-deletion-82672eed8e8d)

Source: Conversation with Copilot, 8/14/2024
(1) Improper Array Deletion. What is an Array in Solidity? | by Shashank .... https://blog.solidityscan.com/improper-array-deletion-82672eed8e8d.
(2) GitHub - crytic/not-so-smart-contracts: Examples of Solidity security .... https://github.com/crytic/not-so-smart-contracts.
(3) Common Solidity Security Vulnerabilities & How to Avoid Them. https://metana.io/blog/common-solidity-security-vulnerabilities-how-to-avoid-them/.
(4) Solidity Array Members and Manipulation Techniques. https://blog.finxter.com/solidity-array-members-and-manipulation-techniques/.
(5) Array Remove By Shifting In Solidity | How To Remove Array Element In Solidity | Solidity Course. https://www.youtube.com/watch?v=ThoabOGcrmk.
(6) Array | Solidity 0.8. https://www.youtube.com/watch?v=vTxxCbwMPwo.
(7) Array Remove An Element By Shifting | Solidity 0.8. https://www.youtube.com/watch?v=szv2zJcy_Xs.
(8) Common Vulnerabilities in Solidity and How to Address Them. https://bing.com/search?q=how+to+prevent+solidity+Improper+Array+Deletion+vulnerability.
(9) Common Vulnerabilities in Solidity and How to Address Them. https://www.soliditylibraries.com/tools/common-vulnerabilities-solidity-address/.
(10) Delegatecall Vulnerabilities In Solidity - Halborn. https://www.halborn.com/blog/post/delegatecall-vulnerabilities-in-solidity.
(11) undefined. https://solidityscan.com/signup.
(12) undefined. https://secure-contracts.com/%29.
(13) undefined. https://remix.ethereum.org.
(14) undefined. https://solidity-by-example.org/array.