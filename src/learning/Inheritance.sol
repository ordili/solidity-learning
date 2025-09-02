// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Base {
    function foo() public pure virtual returns (string memory) {
        return "Base-Foo";
    }
}

contract L2ChildA is Base {
    function foo() public pure virtual override returns (string memory) {
        return "L2ChildA-Foo";
    }
}

contract L2ChildB is Base {
    function foo() public pure virtual override returns (string memory) {
        return "L2ChildB-Foo";
    }
}

// Contracts can inherit from multiple parent contracts.
// When a function is called that is defined multiple times in
// different contracts, parent contracts are searched from
// right to left, and in a depth-first manner.
contract L3ChildAB is L2ChildA, L2ChildB {
    function foo() public pure override(L2ChildA, L2ChildB) returns (string memory) {
        return super.foo();
    }
}

contract L3ChildBA is L2ChildB, L2ChildA {
    function foo() public pure override(L2ChildB, L2ChildA) returns (string memory) {
        return super.foo();
    }
}

contract L3ChildBA2 is L2ChildB, L2ChildA {
    function foo() public pure override(L2ChildA, L2ChildB) returns (string memory) {
        return super.foo();
    }
}

// Inheritance must be ordered from "most base-like" to "most derived".
// Swapping the order of Base and L2ChildA  will throw a compilation error.
contract L3ChildMix is Base, L2ChildA {
    function foo() public pure override(L2ChildA, Base) returns (string memory) {
        return super.foo();
    }
}
