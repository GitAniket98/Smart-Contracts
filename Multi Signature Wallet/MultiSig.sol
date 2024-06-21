// SPDX-License-Identifier: MIT

pragma solidity ^0.8;

contract MultiSig {
    event Deposit(address indexed sender, uint amount);
    event Submit(uint indexed txId);
    event Approve(address indexed owner, uint indexed txId);
    event Revoke(address indexed owner, uint indexed txId);
    event Execute(uint indexed txId);

    struct Transaction {
        address to;
        uint amount;
        bytes data;
        bool executed;
        uint txId;
    }

    address[] public owners;

    Transaction[] public transactions;
    mapping(address => bool) public isOwner;
    mapping(uint => mapping(address => bool)) public approved;

    uint public required;
    // Modifier to check for onlyOwner

    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not owner");
        _;
    }
    // Modifier to check for transaction execution
    modifier notExecuted(uint256 _txId) {
        require(!transactions[_txId].executed, "Already executed");
        _;
    }

    modifier txExists(uint256 _txId) {
        require(_txId < transactions.length, "Transaction does not exist");
        _;
    }

    modifier notApproved(uint256 _txId) {
        require(!approved[_txId][msg.sender], "transaction already approved");
        _;
    }

    constructor(address[] memory _owners, uint _required) {
        require(_owners.length > 0, "No owners");
        require(_required > 0 && _required <= _owners.length);

        for (uint i; i < _owners.length; i++) {
            address owner = _owners[i];

            require(owner != address(0), "Invalid owner");
            require(!isOwner[owner], "Owner not uinque");

            owners.push(owner);
        }

        required = _required;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function submitTransaction(
        address _to,
        uint _amount,
        bytes memory _data
    ) public onlyOwner {
        uint256 _txId = transactions.length;

        transactions.push(
            Transaction({
                to: _to,
                amount: _amount,
                data: _data,
                executed: false,
                txId: _txId
            })
        );

        emit Submit(_txId);
    }

    function approve(
        uint256 _txId
    ) external onlyOwner txExists(_txId) notExecuted(_txId) notApproved(_txId) {
        approved[_txId][msg.sender] = true;
        emit Approve(msg.sender, _txId);
    }

    function execute(
        uint256 _txId
    ) external onlyOwner txExists(_txId) notExecuted(_txId) {
        require(
            getApprovalCount(_txId) >= required,
            "Approvals are less than required"
        );

        Transaction storage transaction = transactions[_txId];

        transaction.executed == true;

        (bool success, ) = transaction.to.call{value: transaction.amount}(
            transaction.data
        );

        require(success, "Transaction failed");
        emit Execute(_txId);
    }

    function getApprovalCount(uint256 _txId) private view returns (uint count) {
        for (uint i = 0; i < owners.length; i++) {
            if (approved[_txId][owners[i]] == true) {
                count += 1;
            }
        }
    }

    function revoke(
        uint256 _txId
    ) external onlyOwner txExists(_txId) notExecuted(_txId) {
        require(
            approved[_txId][msg.sender] == true,
            "Transaction not approved"
        );

        approved[_txId][msg.sender] == false;

        emit Revoke(msg.sender, _txId);
    }
}
