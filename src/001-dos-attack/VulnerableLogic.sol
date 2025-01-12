/**
 *  DOS attack to BadBank.subtractAmount().
 *   When a malicious user donates some collateral tokens to BadBank, the condition of ollateralToken.balanceOf(address(this)) == totalCollateral - amount) will be broken.
 */

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenA is ERC20 {
    constructor() ERC20("TokenA", "AAA") {}

    function mint(address account, uint256 amount) public {
        _mint(account, amount);
    }
}

contract TokenB is ERC20 {
    constructor() ERC20("TokenB", "BBB") {}

    function mint(address account, uint256 amount) public {
        _mint(account, amount);
    }
}

contract BadBank {
    ERC20 collateralToken;
    uint256 public totalCollateral;
    address admin;

    modifier onlyAdmin() {
        require(msg.sender == admin, "only admin is allowed.");
        _;
    }

    constructor(address _collateralToken, address _admin) {
        collateralToken = ERC20(_collateralToken);
        admin = _admin;
        collateralToken.approve(admin, type(uint256).max);
    }

    function addAmount(uint256 amount) public onlyAdmin {
        require(collateralToken.balanceOf(address(this)) >= totalCollateral + amount);

        totalCollateral += amount;
    }

    function subtractAmount(uint256 amount) public onlyAdmin {
        require(collateralToken.balanceOf(address(this)) == totalCollateral - amount);

        totalCollateral -= amount;
    }
}
