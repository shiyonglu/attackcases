/**
 ***  Accounting probblem: 
 **** Two problems: 1) when totalBalance == 0, remainingRewards is decreased but rewardPerToken is not increased
 *                  2) when released reward amount < totalBalance, rewardPerToken is not increased while remainingRewards is decreased
 ***  As a result, the total reward accounted is less then 3 ether, some rewards are lsot in accounting 
 */

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract VulnerableContract is ERC20{
  constructor() ERC20("TokenA", "AAA"){
        owner = msg.sender;
  }
        address owner; 
        uint256 rewardPerToken;
        uint256 totalBalance;
        mapping (address => uint256) public balances;
        mapping (address => uint256) userRewardPerToken;
        mapping (address => uint256) public rewards;

        // rewards
        uint256 public remainingRewards;
        uint256 public rewardRate;
        uint256 public rewardEnd;
        uint256 public lastAccrue;

        

       modifier onlyOwner{
            require(msg.sender == owner);
            _;
       }

        
        function accrueGlobal() internal{
             if(lastAccrue == 0) {
                 lastAccrue = block.timestamp; // initialization
                 console2.log("1111111111111");
                 return;
             }  
             uint256 until = block.timestamp > rewardEnd? rewardEnd: block.timestamp;
             if(until <= lastAccrue) return;

             uint256 amount = rewardRate * (until - lastAccrue);
              console2.log("rewardRate: ", lastAccrue);
             console2.log("amount: ", amount);
             console2.log("until: ", until);
             console2.log("lastAccure: ", lastAccrue);
             remainingRewards -= amount;
             console2.log("2222222222222222");
             if(totalBalance > 0) {
                  console2.log("modify rewardPerToken:");
                  rewardPerToken += amount/totalBalance;
                  if(amount < totalBalance) console2.log("small amount is accrued");
                  console2.log("new rewardPertoken: %d", rewardPerToken);
             } 

             lastAccrue = until;
             console2.log("33333333333333");
             console2.log("remainingRewards after accrueGlobal: ", remainingRewards);
             console2.log("rewardPerToken after accrueGlobal: %d", rewardPerToken);

        }

        function addRewards(uint256 period) onlyOwner public payable{
               require(msg.value != 0); // make sure we add some rewards here
               require(period > 0);

               accrueGlobal();
               console2.log("remainingRewards before adding: ", remainingRewards);
               remainingRewards += msg.value;
               rewardEnd = block.timestamp + period;
               rewardRate = remainingRewards / period;
        }

        function deposit() public payable {
            accrueGlobal();  
            accrue(msg.sender);

            balances[msg.sender] += msg.value;
            totalBalance += msg.value;
            _mint(msg.sender, msg.value);             
        }

        function accrue(address user) internal {  
             console2.log("accrue is called.");
             
             console2.log("rewardPerToken: %d", rewardPerToken);
             console2.log("userRewardPerToken[user]: %d", userRewardPerToken[user]);
             console2.log("balances[user]: ", balances[user]);

             rewards[user] += (rewardPerToken - userRewardPerToken[user]) * balances[user];
             console2.log("rewards[user]: %d", rewards[user]);
             userRewardPerToken[user] = rewardPerToken;

             console2.log("accrue is completed.");
        }

        function claimRewards(uint256 amount) public{
             accrueGlobal();
             accrue(msg.sender);
             rewards[msg.sender] -= amount;
             (bool success, ) = address(msg.sender).call{value: amount}("");
             require(success);        
        }

        function withdraw(uint256 amount) public {
             accrueGlobal();
             accrue(msg.sender);
             balances[msg.sender] -= amount;
             totalBalance -= amount;
             _burn(msg.sender, amount);
             (bool success, ) = address(msg.sender).call{value: amount}("");
             require(success);
        }
  
}



contract MyTest is Test{
      VulnerableContract  vc;

  function setUp() public {
      vc = new VulnerableContract();
  }

  function testRewards() public{
      address user1 = address(333); 
      address user2 = address(222);

      vc.addRewards{value: 3e18}(2 days);
      console2.log("vc.remainingRewards", vc.remainingRewards());

      vm.startPrank(user1);
      vm.deal(user1, 0.02 ether);
      vc.deposit{value: 0.01 ether}();
      vm.stopPrank();

      vm.warp(block.timestamp + 1 days);
     
      
      vm.startPrank(user2);
      vm.deal(user2, 0.02 ether);
      vc.deposit{value: 0.01 ether}();
      vm.stopPrank();
      console2.log("vc.remainingRewards after 1 days", vc.remainingRewards());

      
      vm.warp(block.timestamp + 3 days);
      vm.startPrank(user1);
      vc.withdraw(1000);
      assertEq(vc.balances(user1), 0.01 ether - 1000);
      console2.log("rewards for user1: %d", vc.rewards(user1));
      vm.stopPrank();   

      console2.log("vc.remainingRewards after 3 days", vc.remainingRewards());

 
      vm.startPrank(user2);
      vc.withdraw(2000);
      assertEq(vc.balances(user2), 0.01 ether - 2000);
      console2.log("rewards for user2: %d", vc.rewards(user2));
      vm.stopPrank();   
      
      console2.log("final remaining rewards: ", vc.remainingRewards());
      console2.log("rewards for user1: %d", vc.rewards(user1));
      console2.log("rewards for user2: %d", vc.rewards(user2)); 
      uint256 totalReward = vc.remainingRewards() + vc.rewards(user1) + vc.rewards(user2);
      console2.log("totalReward: %d", totalReward);
     
      assertTrue(totalReward < 3 ether);
  }
}
