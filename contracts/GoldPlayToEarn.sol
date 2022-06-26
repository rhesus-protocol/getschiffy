// SPDX-License-Identifier: Unlicensed

pragma solidity ^ 0.8.7;


interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function decimals() external view returns (uint8);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this;
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;
    address private _previousOwner;
    uint256 private _lockTime;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        _previousOwner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

     /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _previousOwner = _owner;
        _owner = newOwner;
    }

    function geUnlockTime() public view returns (uint256) {
        return _lockTime;
    }

    //Locks the contract for owner for the amount of time provided
    function lock(uint256 time) public virtual onlyOwner {
        _owner = address(0);
        _lockTime = block.timestamp + time;
        emit OwnershipTransferred(_owner, address(0));
    }
    
    //Unlocks the contract for owner when _lockTime is exceeds
    function unlock() public virtual {
        require(_previousOwner == msg.sender, "You don't have permission to unlock");
        require(block.timestamp > _lockTime , "Contract is locked until 7 days");
        emit OwnershipTransferred(_owner, _previousOwner);
        _owner = _previousOwner;
    }
}

contract GoldPlayToEarn is Context, Ownable {
    using SafeMath for uint256;

    IERC20 public _goldToken;
    mapping(address => bool) private _accounts;
    mapping(address => bytes) private _keys;
    mapping(address => bytes32) private _hashCodes;
    mapping(address => uint256) private _walletEarned;
    mapping(address => bool) private _blacklisted;
    uint256 private _maxPossibleEarning;
    uint256 public globalEarned;

    event Registered(address indexed account);
    event Withdrawn(address indexed by, uint256 amount, uint256 timestamp);
    event Blacklisted(address indexed wallet, uint256 triedAmount);

    constructor(IERC20 goldTokenContract_, uint256 maximum_) {
        _goldToken = goldTokenContract_;
        _maxPossibleEarning = maximum_;
    }

    modifier onlyUnregistered() {
        require(!_accounts[_msgSender()], "Wallet already registered.");
        _;
    }

    modifier onlyRegistered() {
        require(_accounts[_msgSender()], "You are not registered.");
        _;
    }

    modifier notBlacklisted() {
        require(!_blacklisted[_msgSender()], "Wallet is blacklisted.");
        _;
    }

    modifier onlyHashMatched(bytes memory key_) {
        bytes32 hash_ = keccak256(key_);
        require(_hashCodes[_msgSender()] == hash_, "Key does not match.");
        _;
        _setKeyHash(_msgSender());
    }

    // First time wallet has to call this function to get registered before withdrawing funds, returns bool
    function register() public onlyUnregistered returns(bool){
        _accounts[_msgSender()] = true;
        _setKeyHash(_msgSender());
        emit Registered(_msgSender());
        return true;
    }
    
    // only registered and not blacklisted wallet will be able to call
    // required uint256 amount to withdraw, key_ which is set during registration
    function withdraw(uint256 amount_, bytes memory key_) public 
        onlyRegistered
        onlyHashMatched(key_)
        notBlacklisted
    {
        if(amount_ <= _maxPossibleEarning) {
            globalEarned = globalEarned.add(amount_);
            _walletEarned[_msgSender()] = _walletEarned[_msgSender()].add(amount_);
            _goldToken.transfer(_msgSender(), amount_);
            emit Withdrawn(_msgSender(), amount_, block.timestamp);
        } else {
            _blacklisted[_msgSender()] = true;
            emit Blacklisted(_msgSender(), amount_);
        }
    }

    // read if the user wallet is registered or not, returns bool
    function checkRegistration(address account_) public view returns(bool) {
        return _accounts[account_];
    }

    // get the hash key_ of the wallet need to call each time during withdraw process, returns bytes
    function getKey() public view returns(bytes memory) {
        return _keys[_msgSender()];
    }

    // read how much a wallet has withdrawn till date, returns uint256
    function totalWaleltEarned(address account) public view returns(uint256){
        return _walletEarned[account];
    }

    // read if the perticular wallet is blacklisted, returns bool
    function checkBlackListed(address account_) public view returns(bool) {
        return _blacklisted[account_];
    }

    function _setKeyHash(address account_) internal {
        _keys[account_] = abi.encodePacked(block.difficulty, block.timestamp);
        _hashCodes[account_] = keccak256(_keys[account_]);
    }

    function removeFromBlacklist(address account_) public onlyOwner {
        _blacklisted[account_] = false;
    }

    function blackListWallet(address account_) public onlyOwner {
        _blacklisted[account_] = true;
    }

    function adminWithdraw() public onlyOwner {
        payable(_msgSender()).transfer(address(this).balance);
        _goldToken.transfer(_msgSender(), _goldToken.balanceOf(address(this)));
    }

    receive() external payable {}

}