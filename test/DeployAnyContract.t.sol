// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../src/learning/DeployAnyContract.sol";
import {Test, console} from "forge-std/Test.sol";

contract DeployAnyContractTest is Test {
    DeployAnyContract public deployAnyContract;
    Helper public helper;

    function setUp() public {
        deployAnyContract = new DeployAnyContract();
        helper = new Helper();
    }

    function test_deploy() public {
        bytes memory code = helper.getBytecode();
        address contractAddress = deployAnyContract.deploy(code);
        TestContract testContract = TestContract(contractAddress);
        address owner = testContract.owner();
        vm.prank(owner);
        address newOwner = makeAddr("Owner");
        testContract.setOwner(newOwner);
        assertEq(testContract.owner(), newOwner);
    }

    function test_deployWithEth() public {
        bytes memory code = helper.getBytecode();
        address contractAddress = deployAnyContract.deploy{value: 1 ether}(code);
        assertEq(1 ether, contractAddress.balance);
    }

    function test_execute() public {
        bytes memory code = helper.getBytecode();
        address contractAddress = deployAnyContract.deploy(code);
        TestContract testContract = TestContract(contractAddress);

        address newOwner = makeAddr("newOwner");
        bytes memory sig = helper.getCalldata(newOwner);

        address owner = testContract.owner();
        vm.prank(owner);

        deployAnyContract.execute(contractAddress, sig);
        assertEq(testContract.owner(), newOwner);
    }

    function test_execute2() public {
        bytes memory code = helper.getBytecode();
        address contractAddress = deployAnyContract.deploy(code);
        TestContract testContract = TestContract(contractAddress);

        address newOwner = makeAddr("newOwner");
        bytes memory sig = helper.getCalldata(newOwner);

        address owner = testContract.owner();
        vm.prank(owner);

        deployAnyContract.execute(contractAddress, sig);
        assertEq(testContract.owner(), newOwner);
    }
}
