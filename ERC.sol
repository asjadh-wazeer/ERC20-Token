//SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.5.0 <0.9.0; // ---------------------------------------------------------------------------- // EIP-20: ERC-20 Token Standard // https://eips.ethereum.org/EIPS/eip-20 // -----------------------------------------

interface ERC20Interface { 

function totalSupply() external view returns (uint); 
function balanceOf(address tokenOwner) external view returns (uint balance); 
function transfer(address to, uint tokens) external returns (bool success);

function allowance(address tokenOwner, address spender) external view returns (uint remaining);
function approve(address spender, uint tokens) external returns (bool success);
function transferFrom(address from, address to, uint tokens) external returns (bool success);

event Transfer(address indexed from, address indexed to, uint tokens);
event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

//// Now we are creating ERC20 token by using ERC20 interface
// First of all we will make a contract

contract Block is ERC20Interface{

//Now we are going to declare our state variable
string public name="Block"; //Name of the token
string public symbol="BLK"; //


string public decimal="0"; //This variable is tells us upto how much decimal places our token will be visible
//(Generally for ERC20 token  it is upto 18 decimals)

uint public override totalSupply; //I'm actually implementing ERC20 interface //This will tell us total supply of ERC token
address public founder; //Who is actually founder of this ERC20 all
mapping(address=>uint) public balances; //This will keep up the track of balances belonh in to the particular addresses
mapping(address=>mapping(address=>uint)) allowed;//Nested map, which e are making for approval process

    constructor() {
    totalSupply=100000; //This much token in supply
    founder=msg.sender;
    balances[founder]=totalSupply; //Initially all the total supply of a BLK or block token present into our balance of our founder
    }


    //We are going to determine balance of a particular token
    function balanceOf(address tokenOwner) public view override returns(uint balance){
    return balances[tokenOwner]; //We are going to use mapping
    }


    //We can transfer ether to particular address
    function transfer(address to,uint tokens) public override returns(bool success){ //Here we will transfer token, not ether //uint tokens--> Number of tokens that we want to transfer
    require(balances[msg.sender]>=tokens); //Check whether msg.sender as enough amount of token in his account
    balances[to]+=tokens; //balances[to]=balances[to]+tokens;
    balances[msg.sender]-=tokens;
    emit Transfer(msg.sender,to,tokens); //Now we are going to emit tranfer event
    return true; //If this all true, then we are going to return 
    }


    //Approval process
    function approve(address spender,uint tokens) public override returns(bool success){
    // The address of the spender is a person whom we are actually approving, You are allow to use my tokens //Now you are allow to take money (tokens) from my account
    require(balances[msg.sender]>=tokens); //Check balance of the owner whether... 
    require(tokens>0); //Number of tokens that are been transfered, it must be greater than zero
    allowed[msg.sender][spender]=tokens; //we are going to use mapping //msg.sender is actually allowing this spender of these number of tokens
    emit Approval(msg.sender,spender,tokens);
    return true;
    }


    //Allowance function
    function allowance(address tokenOwner,address spender) public view override returns(uint noOfTokens){ //number of tokens that token owner actually approve this spender 
    return allowed[tokenOwner][spender];
    }


    //Now we can transfer ether from one address to another address
    function transferFrom(address from,address to,uint tokens) public override returns(bool success){
    require(allowed[from][to]>=tokens); //In this case we are going to check alowed mapping, The approval has been given for the token or not
    require(balances[from]>=tokens); //Checking
    balances[from]-=tokens;
    balances[to]+=tokens;
    return true;
    }

}
