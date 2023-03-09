//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

error Staking_UserAlreadyExist();
error Staking_NotEnoughBalance();
error Staking_UserNotStaking();
error Staking_TxFailed();
error Staking_NotStakedLongEnough();

contract Staking is AccessControl, Pausable {
    //state variables
    uint256 public s_stakingTime;
    uint256 totalDeposit;

    // variable immutable
    uint256 private immutable i_amount;

    // variable constant
    uint256 private constant firstPoolTime = 5 days;
    uint256 private constant secondPoolTime = 10 days;
    uint256 private constant threePoolTime = 15 days;
    uint256 private constant poolOnePercentage = 10;
    uint256 private constant poolTwoPercentage = 20;
    uint256 private constant poolThreePercentage = 30;

    //mapping
    mapping(address => uint256) balanceOfUser;
    mapping(address => bool) stakingStatus;
    mapping(address => uint256) timePeriod;

    //events
    event Stake(address indexed account, uint256 amount);
    event Withdraw(address indexed account, uint256 amount);
    event WithdrewAllFunds(address indexed account, uint256 amount);

    //construtor
    constructor(uint256 amount) {
        i_amount = amount;
    }

    function stake(address _user, uint256 _amount) public payable {
        if (_amount < i_amount) {
            revert Staking_NotEnoughBalance();
        }
        uint256 stakingStarts;
        if (!stakingStatus[_user]) {
            stakingStarts = block.timestamp;
            timePeriod[_user] = stakingStarts;
        }
        stakingStatus[_user] = true;
        balanceOfUser[_user] += _amount;
        s_stakingTime = stakingStarts;

        uint256 _totalDeposit = _amount;
        totalDeposit += _totalDeposit;

        emit Stake(msg.sender, _amount);
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

        uint256 _totalDeposit = _amount;
        totalDeposit -= _totalDeposit;

        emit Withdraw(msg.sender, _amount);
    }

    function _userExitingStaking(address _user, uint256 _amount) internal {
        stakingStatus[_user] = false;
        balanceOfUser[_user] -= _amount;
        (bool success, ) = _user.call{value: _amount}("");
        if (!success) {
            revert Staking_TxFailed();
        }

        uint256 _totalDeposit = _amount;
        totalDeposit -= _totalDeposit;

        emit WithdrewAllFunds(msg.sender, _amount);
    }

    function poolOneReward() internal view returns (uint256 rewardPerUser) {
        if (!stakingStatus[msg.sender]) {
            revert Staking_UserNotStaking();
        }
        if (timePeriod[msg.sender] < firstPoolTime) {
            revert Staking_NotStakedLongEnough();
        }
        uint256 _totalDeposit = totalDeposit;
        uint256 _poolOneReward = (_totalDeposit * poolOnePercentage) / 100;

        uint256 _userShare = balanceOfUser[msg.sender];
        uint256 _userReward = _userShare / _totalDeposit;

        rewardPerUser = _userReward * _poolOneReward;

        return rewardPerUser;
    }

    function poolTwoReward() internal {
        if (!stakingStatus[msg.sender]) {
            revert Staking_UserNotStaking();
        }
        if (timePeriod[msg.sender] < firstPoolTime) {
            revert Staking_NotStakedLongEnough();
        }
    }

    function poolThreeReward() internal {}
}
