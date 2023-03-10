// Dependency file: @openzeppelin/contracts/utils/Context.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

// pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}


// Dependency file: @openzeppelin/contracts/access/Ownable.sol

// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

// pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/utils/Context.sol";

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}


// Dependency file: src/ILogic.sol

// pragma solidity ^0.8.17;

// Interface for Molecule Smart Contract
interface ILogic {
    function check(bytes memory data) external view returns (bool);
}


// Root file: src/LogicAML.sol

pragma solidity ^0.8.17;

// import "@openzeppelin/contracts/access/Ownable.sol";
// import "src/ILogic.sol";

/// @title Molecule Protocol LogicAML contract
/// @dev This contract implements the ILogicAddress interface with address input
///      It will return true if the `account` exists in the List
contract LogicAML is Ownable, ILogic {
    constructor() {}

    mapping(address => bool) private batchData;

    event ListAdded(address[] addrs);
    event ListRemoved(address[] addrs);

    // To update the LogicAML list
    function updateList(address[] memory _addAddress)
        external
        onlyOwner
        returns (bool)
    {
        for (uint256 i = 0; i < _addAddress.length; i++) {
            batchData[_addAddress[i]] = true;
        }
        emit ListAdded(_addAddress);
        return true;
    }

    // Remove address from the List
    function removeFromList(address[] memory _removeAddress)
        external
        onlyOwner
    {
        for (uint256 i = 0; i < _removeAddress.length; i++) {
            batchData[_removeAddress[i]] = false;
        }
        emit ListRemoved(_removeAddress);
    }

    // checks whether the address is present inside the list and returns true if its present
    function check(bytes memory data) external view returns (bool) {
        address account = abi.decode(data, (address));
        return batchData[account];
    }
}
