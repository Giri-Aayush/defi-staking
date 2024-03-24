// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract Staking is ReentrancyGuard {
    using SafeERC20 for IERC20;
    IERC20 public immutable STAKING_TOKEN;
    uint256 public immutable REWARD_PER_DAY;

    struct Stake {
        uint256 amount;
        uint256 startTimestamp;
    }

    mapping(address => Stake[]) private _userStakes;
    mapping(address => uint256) private _userRewards;

    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount, uint256 reward);
    event RewardClaimed(address indexed user, uint256 reward);

    constructor(IERC20 stakingToken, uint256 rewardPerDay) {
        STAKING_TOKEN = stakingToken;
        REWARD_PER_DAY = rewardPerDay;
    }

    function stake(uint256 amount) external nonReentrant {
        require(amount > 0, "Staking amount must be greater than 0");
        STAKING_TOKEN.safeTransferFrom(msg.sender, address(this), amount);
        _userStakes[msg.sender].push(Stake(amount, block.timestamp));
        emit Staked(msg.sender, amount);
    }

    function getUserStakes(address user) external view returns (Stake[] memory) {
        return _userStakes[user];
    }

    function withdraw() external nonReentrant {
        uint256 totalReward = _calculateReward(msg.sender);
        uint256 totalStake = _calculateTotalStake(msg.sender);
        delete _userStakes[msg.sender];
        _userRewards[msg.sender] += totalReward;
        STAKING_TOKEN.safeTransfer(msg.sender, totalStake);
        STAKING_TOKEN.safeTransfer(msg.sender, _userRewards[msg.sender]);
        emit Withdrawn(msg.sender, totalStake, _userRewards[msg.sender]);
        _userRewards[msg.sender] = 0;
    }

    function viewRewards(address user) external view returns (uint256) {
        return _calculateReward(user) + _userRewards[user];
    }

    function getUserReward(address user) external view returns (uint256) {
        return _userRewards[user];
    }

    function claimRewards() external nonReentrant {
        uint256 reward = _calculateReward(msg.sender);
        require(reward > 0, "No rewards to claim");
        _userRewards[msg.sender] += reward;
        emit RewardClaimed(msg.sender, reward);
    }

    function _calculateReward(address user) private view returns (uint256) {
        uint256 totalReward = 0;
        for (uint256 i = 0; i < _userStakes[user].length; i++) {
            Stake memory userStake = _userStakes[user][i];
            uint256 elapsedDays = (block.timestamp - userStake.startTimestamp) / 1 days;
            uint256 stakeReward = elapsedDays * userStake.amount / 1000 * REWARD_PER_DAY;
            totalReward += stakeReward;
        }
        return totalReward;
    }

    function _calculateTotalStake(address user) private view returns (uint256) {
        uint256 totalStake = 0;
        for (uint256 i = 0; i < _userStakes[user].length; i++) {
            totalStake += _userStakes[user][i].amount;
        }
        return totalStake;
    }
}