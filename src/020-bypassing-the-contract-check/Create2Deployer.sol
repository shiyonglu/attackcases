// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Create2Deployer {
    event Deployed(address addr, uint256 salt);

    function deploy(uint256 salt, bytes memory bytecode) public {
        address addr;
        assembly {
            addr := create2(0, add(bytecode, 0x20), mload(bytecode), salt)
        }
        require(addr != address(0), "Deployment failed");
        emit Deployed(addr, salt);
    }

    function computeAddress(
        bytes32 salt,
        bytes32 bytecodeHash
    ) public view returns (address) {
        return
            address(
                uint160(
                    uint(
                        keccak256(
                            abi.encodePacked(
                                bytes1(0xff),
                                address(this),
                                salt,
                                bytecodeHash
                            )
                        )
                    )
                )
            );
    }
}
