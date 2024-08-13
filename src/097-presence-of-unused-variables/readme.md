# Presence of unused variables

Unused variables are allowed in Solidity and they do not pose a direct security issue. It is best practice though to avoid them as they can:

- cause an increase in computations (and unnecessary gas consumption)
- indicate bugs or malformed data structures and they are generally a sign of poor code quality
- cause code noise and decrease readability of the code

## Remediation

Remove all unused variables from the code base.

## References

- [Unused local variables warnings discussion](https://github.com/ethereum/solidity/issues/718)
- [Shadowing of inherited state variables discussion](https://github.com/ethereum/solidity/issues/2563)

## Samples

### unused_state_variables.sol

```solidity
pragma solidity >=0.5.0;
pragma experimental ABIEncoderV2;

import "./base.sol";

contract DerivedA is Base {
    // i is not used in the current contract
    A i = A(1);

    int internal j = 500;

    function call(int a) public {
        assign1(a);
    }

    function assign3(A memory x) public returns (uint) {
        return g[1] + x.a + uint(j);
    }

    function ret() public returns (int){
        return this.e();

    }

}
```

### unused_state_variables_fixed.sol

```solidity
pragma solidity >=0.5.0;
pragma experimental ABIEncoderV2;

import "./base_fixed.sol";

contract DerivedA is Base {

    int internal j = 500;

    function call(int a) public {
        assign1(a);
    }

    function assign3(A memory x) public returns (uint) {
        return g[1] + x.a + uint(j);
    }

    function ret() public returns (int){
        return this.e();

    }

}
```

### unused_variables.sol

```solidity
pragma solidity ^0.5.0;

contract UnusedVariables {
    int a = 1;

    // y is not used
    function unusedArg(int x, int y) public view returns (int z) {
        z = x + a;  
    }

    // n is not reported it is part of another SWC category
    function unusedReturn(int x, int y) public pure returns (int m, int n, int o) {
        m = y - x;
        o = m/2;
    }

    // x is not accessed
    function neverAccessed(int test) public pure returns (int) {
        int z = 10;

        if (test > z) {
            // x is not used
            int x = test - z;

            return test - z;
        }

        return z;
    }

    function tupleAssignment(int p) public returns (int q, int r){
        (q, , r) = unusedReturn(p,2);

    }


}

```

### unused_variables_fixed.sol

```solidity
pragma solidity ^0.5.0;

contract UnusedVariables {
    int a = 1;

    function unusedArg(int x) public view returns (int z) {
        z = x + a;  
    }

    // n is not reported it is part of another SWC category
    function unusedReturn(int x, int y) public pure returns (int m, int n,int o) {
        m = y - x;
        o = m/2;
    }

    // x is not accessed
    function neverAccessed(int test) public pure returns (int) {
        int z = 10;

        if (test > z) {
            return test - z;
        }

        return z;
    }

    function tupleAssignment(int p) public returns (int q, int r){
        (q, , r) = unusedReturn(p,2);

    }

}

```