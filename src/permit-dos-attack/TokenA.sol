// Deployed on Polygon on 1/11/2024, 
// gas fee: spent 0.10860865MATIC which is around 8 cents on 1/11/2024
// Polygonscan page: https://polygonscan.com/token/0xd03c5c70936b4f85e6b70e453d42c86d3a53f1cc

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.23;


contract TokenA{
    string public constant name = "TokenA";
    string public constant symbol = "AAA";
    uint8 public constant decimals = 18; // 18 decimals is the strongly suggested default, avoid changing it
    uint public constant _totalSupply = 1_000_000_000 * 1e18; // one billion 

    address public contractOwner;
 
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    event Transfer(address indexed from, address indexed to, uint rawAmt);
    event Approval(address indexed tokenOwner, address indexed spender, uint rawAmt);
    event RenounceOwnership(address oldOwner, address newOwner); 
   
   constructor() { 
        contractOwner = msg.sender;
        balances[msg.sender] = _totalSupply; // The trustAccount has all tokens initially 
        emit Transfer(address(0), msg.sender, _totalSupply);
   }
    
    modifier onlyOwner(){
       require(msg.sender == contractOwner, "only the contract owner can call this function. ");
       _;
    }
    
    
    function renounceCwnership()
    onlyOwner
    public 
    {
        address oldOwner = contractOwner;
        contractOwner = address(this);
        emit RenounceOwnership(oldOwner, address(this));    
    }

    function totalSupply() public pure returns (uint) {
        return _totalSupply;
    }


    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];

    }
    
 
    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    // called by the owner
    function approve(address spender, uint rawAmt) public returns (bool success) {
        
        allowed[msg.sender][spender] = rawAmt;
        emit Approval(msg.sender, spender, rawAmt);
        return true;
    }

    function transfer(address to, uint rawAmt) public returns (bool success) {
        balances[msg.sender] = balances[msg.sender] - rawAmt;
        balances[to] = balances[to] + rawAmt;
        emit Transfer(msg.sender, to, rawAmt);
        return true;
    }
    
    // ERC the allowence function should be more specic +-
    function transferFrom(address from, address to, uint rawAmt) public returns (bool success) {
        allowed[from][msg.sender] = allowed[from][msg.sender] - rawAmt; // this will ensure the spender indeed has the authorization
        balances[from] = balances[from] - rawAmt;
        balances[to] = balances[to] + rawAmt;
        emit Transfer(from, to, rawAmt);
        return true;
    }       
}
