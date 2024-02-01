pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "../../src/reentrancy/Bank.sol";
// import "../src/attack002.sol";

/* this contract, Bob: deployer
   address(1): Alice: trustAccount, 
*/

contract testBank is Test {
    Bank mybank;
    Attacker alice;

    

    function setUp() public {
        mybank = new Bank();
        // alice = new Attacker(payable(mybank));
        
        (bool success, ) = address(mybank).call{value: 1000000}("");
        if(!success) revert();
        
        (success, ) = address(1).call{value: 1000}("");
        if(!success) revert();
        

        // assertEq(address(mybank).balance, 1000000);
   
    }

   
    function testSteal() public
    {
          // 
    }


}    
