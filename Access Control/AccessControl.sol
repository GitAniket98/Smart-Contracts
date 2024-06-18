
// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract AccessControl {
    mapping(bytes32 => mapping(address => bool)) public roles;
    

    // Keeping roles in bytes32 saves gas
    // the bytes values for the roles are pre-fetched by making them public and the re-deployed 
    // by making it private
    // Here only 2 roles are defined 
    // Can add more roles as per requirements

    bytes32 private constant ADMIN = keccak256(abi.encodePacked("ADMIN"));
    //0xdf8b4c520ffe197c5343c6f5aec59570151ef9a492f2c624fd45ddde6135ec42
    bytes32 private constant USER = keccak256(abi.encodePacked("USER"));
    //0x2db9fd3d099848027c2383d0a083396f6c41510d7acfd92adc99b6cffcf31e96

    event GrantRole(bytes32 indexed _role, address indexed _account);
    event RevokeRole(bytes32 indexed _role, address indexed _account);

    constructor() {
        _grantRole(ADMIN, msg.sender);
    }
    

    // Modifier to restrict usage of functions to specified roles
    modifier onlyRole(bytes32 _role) {
        require(roles[_role][msg.sender], "Not Authorized");
        _;
    }
    
    // Internal function for granting role
    function _grantRole(bytes32 _role, address _account) internal {
        roles[_role][_account] = true;
        emit GrantRole(_role, _account);
    }
    
    // Function for Granting roles 
    // Only accessible by addresses with ADMIN roles
    function grantRole(bytes32 _role, address _account) external onlyRole(ADMIN) {
        _grantRole(_role, _account);
    }

    // Function for Revoking roles 
    // Only accessible by addresses with ADMIN roles
    function revokeRole(bytes32 _role, address _account) external onlyRole(ADMIN) {
        roles[_role][_account] = false;
        emit RevokeRole(_role, _account);
    }



}
