# Deleting a Mapping Within a Struct in Solidity

In Solidity, deleting a mapping within a struct can be challenging due to the way mappings are handled in storage. Mappings cannot be directly deleted, and attempting to delete a struct containing a mapping can lead to issues. Let's explore this in detail with an example and prevention strategies.

### Example

Consider the following struct with a mapping:

```solidity
pragma solidity ^0.8.0;

contract Example {
    struct User {
        uint256 purchaseDate;
    }

    struct Card {
        string name;
        uint256 price;
        uint256 lifeSpan;
        mapping(address => User) users;
    }

    mapping(uint256 => Card) public cards;

    function addCard(uint256 id, string memory name, uint256 price, uint256 lifeSpan) public {
        cards[id] = Card(name, price, lifeSpan);
    }

    function addUser(uint256 cardId, address user, uint256 purchaseDate) public {
        cards[cardId].users[user] = User(purchaseDate);
    }

    function deleteCard(uint256 id) public {
        delete cards[id]; // This will not delete the mapping inside the struct
    }
}
```

In this example, the `deleteCard` function attempts to delete a `Card` struct from the `cards` mapping. However, this will not delete the `users` mapping inside the `Card` struct. The mapping will still exist in storage, potentially leading to unexpected behavior.

### Prevention

To properly handle the deletion of mappings within structs, consider the following strategies:

1. **Iterate and Delete**: Iterate through the keys of the mapping and delete each entry individually. Note that this requires maintaining a separate array of keys, as Solidity does not provide a way to iterate over mapping keys directly.

   ```solidity
   contract Example {
       struct User {
           uint256 purchaseDate;
       }

       struct Card {
           string name;
           uint256 price;
           uint256 lifeSpan;
           mapping(address => User) users;
           address[] userKeys;
       }

       mapping(uint256 => Card) public cards;

       function addCard(uint256 id, string memory name, uint256 price, uint256 lifeSpan) public {
           cards[id] = Card(name, price, lifeSpan);
       }

       function addUser(uint256 cardId, address user, uint256 purchaseDate) public {
           cards[cardId].users[user] = User(purchaseDate);
           cards[cardId].userKeys.push(user);
       }

       function deleteCard(uint256 id) public {
           Card storage card = cards[id];
           for (uint256 i = 0; i < card.userKeys.length; i++) {
               delete card.users[card.userKeys[i]];
           }
           delete cards[id];
       }
   }
   ```

2. **Use Structs Without Mappings**: If possible, avoid using mappings within structs. Instead, use arrays or other data structures that can be more easily managed and deleted.

3. **Clear Data Manually**: Manually clear the data within the mapping before deleting the struct. This ensures that all entries are properly removed from storage.

By following these strategies, you can effectively manage and delete mappings within structs in Solidity, ensuring that your smart contracts behave as expected.

If you have any further questions or need more examples, feel free to ask!

Source: Conversation with Copilot, 8/13/2024
(1) Mapping | Solidity 0.8. https://www.youtube.com/watch?v=Q-wRG7pngn0.
(2) Mapping with Struct in Solidity | Part - 28 | Solidity Course | Code Eater - Blockchain | English. https://www.youtube.com/watch?v=iKUwRAXFa7c.
(3) 06. Solidity Mappings & Structs Tutorial. https://www.youtube.com/watch?v=gfXewa4xmYE.
(4) Solidity: Delete a struct having mapping inside from its array without .... https://ethereum.stackexchange.com/questions/134712/solidity-delete-a-struct-having-mapping-inside-from-its-array-without-leaving-a.
(5) solidity - delete an element from mapping of address to struct array .... https://ethereum.stackexchange.com/questions/45374/delete-an-element-from-mapping-of-address-to-struct-array.
(6) Deleting mapping from mapping in Solidity - Stack Overflow. https://stackoverflow.com/questions/48515633/deleting-mapping-from-mapping-in-solidity.
(7) undefined. https://codedamn.com/learn/learn-solidity?coupon=INSTRUCTOR.
(8) undefined. https://codedamn.com/learn/smart-contract-testing?coupon=INSTRUCTOR.
(9) undefined. https://codedamn.com/exam/solidity-exam?coupon=INSTRUCTOR.
(10) undefined. https://goo.gl/EiKpPP.
(11) undefined. https://goo.gl/L4ppLK.
(12) undefined. https://coursetro.com.