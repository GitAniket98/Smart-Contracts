// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract verifySig {

// Function to verify the signature
    function verify(address _signer, string memory _message, bytes memory _sig) external pure returns (bool) {
        bytes32 messageHash = getMessageHash(_message);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
        return recover(ethSignedMessageHash, _sig) == _signer;
    }


// Function to create message hash
    function getMessageHash(string memory _message) public pure returns (bytes32){
        return keccak256(abi.encodePacked(_message));
    }


// Function to create Ethereum Signed Message hash for the hashed message from above function

    function getEthSignedMessageHash(bytes32 _messageHash) public pure returns(bytes32){
       return keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash)
        );
    }


// Fuction to recover the account used for signing the message
// Fetches the signer of the message

    function recover(bytes32 _ethSignedMessageHash, bytes memory _sig) public pure returns (address){
        (bytes32 r, bytes32 s, uint8 v) = _split(_sig);
       return ecrecover(_ethSignedMessageHash, v, r, s);
    }

// Function to get the r, s and v values from the signature
// v, r and s are components of the Elleptic Curve Cryptography Signature

    function _split(bytes memory _sig) internal pure returns (bytes32 r, bytes32 s, uint8 v){
        require(_sig.length == 65, "Invalid Signature length");

        assembly {
            r:= mload(add(_sig, 32))
            s:= mload(add(_sig, 64))
            v:= byte(0, mload(add(_sig, 96)))

        }
    }
}
