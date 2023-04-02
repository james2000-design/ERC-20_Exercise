// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
// The ERC20 standard functions
interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);


    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract DiamundToken is IERC20 {

    string public constant name = "Diamund Token";
    string public constant symbol = "DMDT";
    uint8 public constant decimals = 18;


    mapping(address => uint256) balances;

    mapping(address => mapping (address => uint256)) allowed;

    uint256 totalSupply_ = 10 ether;


   constructor() {
       // Let the owner hold 50% of the totalSupply
    balances[msg.sender] = totalSupply_ / 2;
    }

    function totalSupply() public override view returns (uint256) {
    return totalSupply_;
    }

    function balanceOf(address deployer) public override view returns (uint256) {
        return balances[deployer];
    }
// THE TRANSFER FUNCTION
    function transfer(address recipient, uint256 _value) public override returns (bool) {
        require(_value <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender]- _value;
        balances[recipient] = balances[recipient]+ _value;
        emit Transfer(msg.sender, recipient, _value);
        return true;
    }

// APPROVED TOKEN TO BE SPENT
    function approve(address spender, uint256 _value) public override returns (bool) {
        allowed[msg.sender][spender] = _value;
        emit Approval(msg.sender, spender, _value);
        return true;
    }
// FUNCTION TO ALLOWANCES
    function allowance(address deployer, address spender) public override view returns (uint) {
        return allowed[deployer][spender];
    }

    function transferFrom(address deployer, address recipient, uint256 _value) public override returns (bool) {
        require(_value <= balances[deployer]);
        require(_value <= allowed[deployer][msg.sender]);

        balances[deployer] = balances[deployer]- _value;
        allowed[deployer][msg.sender] = allowed[deployer][msg.sender]- _value;
        balances[recipient] = balances[recipient]+ _value;
        emit Transfer(deployer, recipient, _value);
        return true;
    }
}