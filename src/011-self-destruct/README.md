# Self Destruct
Contracts can be deleted from the blockchain by calling selfdestruct.

selfdestruct sends all remaining Ether stored in the contract to a designated address.

## Vulnerability
A malicious contract can use selfdestruct to force sending Ether to any contract.

## Preventative Techniques
Don't rely on address(this).balance
