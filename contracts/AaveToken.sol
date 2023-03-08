// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

error AaveToken_NotOwner();

contract AaveToken is ERC20, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER");

    constructor() ERC20("AaveToken", "AT") {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function mint(address user, uint amount) public {
        if (!hasRole(DEFAULT_ADMIN_ROLE, msg.sender)) {
            revert AaveToken_NotOwner();
        }
        _mint(user, amount);
    }
}
