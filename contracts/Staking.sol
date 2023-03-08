//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

error Staking_UserAlreadyExist();
error Staking_NotEnoughBalance();
error Staking_UserNotStaking();
error Staking_TxFailed();

contract Staking is AccessControl, Pausable {
    //state variables
    uint256 public s_stakingTime;

    // variable immutable
    uint256 private immutable i_amount;
    // variable constant
    uint256 private constant fixedDay = 10 days;

    //mapping
    mapping(address => uint256) balanceOfUser;
    mapping(address => bool) stakingStatus;

    //events

    //construtor
    constructor(uint256 amount) {
        i_amount = amount;
    }

    function stake(address _user, uint256 _amount) public payable {
        if (_amount < i_amount) {
            revert Staking_NotEnoughBalance();
        }
        s_stakingTime = block.timestamp();
        stakingStatus[_user] = true;
        balanceOfUser[_user] += _amount;
        
    }

    function withdraw(address _user, uint256 _amount) public {
        if (stakingStatus[_user] = false) {
            revert Staking_UserNotStaking();
        }
        if (balanceOfUser[_user] == 0) {
            revert Staking_NotEnoughBalance();
        }
        if (_amount == balanceOfUser[_user]) {
            _userExitingStaking(_user, _amount);
        }

        balanceOfUser[_user] -= _amount;
        (bool success, ) = _user.call{value: _amount}("");
        if (!success) {
            revert Staking_TxFailed();
        }
    }

    function _userExitingStaking(address _user, uint256 _amount) internal {
        stakingStatus[_user] = false;
        balanceOfUser[_user] -= _amount;
        (bool success, ) = _user.call{value: _amount}("");
        if (!success) {
            revert Staking_TxFailed();
        }
    }

    function _rewardToUser() internal {
        if(to)

    }
}
