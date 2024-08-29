The Short Address Attack requires an improperly padded input, which typically results from a client-side bug or vulnerability. Since Solidity and the EVM enforce proper padding, the `Attacker` contract will not be able to exploit the `VulnerableToken` contract directly. The attack is only relevant in cases where external clients or dApps send malformed data, not from within a Solidity contract.

## Steps to follow to simulate
- Run `anvil `
- Deploy the `VulnerableToken` Contract by running `forge script script/Deploy17ShortAddressAttack.s.sol --broadcast --rpc-url 127.0.0.1:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80`
- Copy the `VulnerableToken` contract address from console 
- run js file `node test/017-short-address/short_address_attack.js`