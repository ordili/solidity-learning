// SPDX-License-Identifier: MIK
pragma solidity ^0.8.13;

import "solidity-by-example/Create2.sol";
import {Test, console} from "forge-std/Test.sol";

contract Create2Test is Test {
    Factory public factory;

    TestContract public testContract;

    FactoryAssembly public factoryAssembly;

    uint256 _foo = 100;
    bytes32 _salt = hex"4f6e654d6f72654c6f6e67537472696e67546f4d616b65497433326279746573";

    address _owner = makeAddr("owner");

    function setUp() public {
        factory = new Factory();
        testContract = new TestContract{salt: _salt}(_owner, _foo);
    }

    function test_deploy() public {
        address contractAddress = factory.deploy(_owner, _foo, _salt);
        //        assertEq(contractAddress, address(testContract));
    }

    //    function test_assembly() public {
    //        bytes memory contractCode = factoryAssembly.getBytecode(_owner, _foo);
    //        address contractAddress = factoryAssembly.getAddress(contractCode, _salt);
    //        assertEq(contractAddress, address(testContract));
    //    }
}
