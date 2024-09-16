//SPDX-License-Indentifier: MIT
//compiler version must be greater than or equal to 0.8.26 and less than 0.9.0
pragma solidity ^0.8.26;

contract DataLocations {
    uint256[] public arr;
    mapping(uint256=>address) map;

    struct MyStruct {
        uint256 foo;
    }
    mapping(unit256 => MyStruct) myStructs;
    function f() public {
        //call _f with state variables
        _f(arr,map,mySturcts[1]);

        //get a struct from a mapping
        MyStruct storage myStruct = myStructs[1];
        //create a struct in memory
        MyStruct memory myMemStruct = MyStruct(0);
    }
    function _f(
        uint256[] storage _arr,
        mapping(uint256=>address) storage _map,
        MyStruct storage _myStruct
    ) internal {

    }
    function g(uin256[] memory _arr) public returns (uint256[] memory) {

    }
    function h(uint256[] calldata _arr) external {

    }
}

interface ITest {
    function val() external view returns (uin256);
    function test() external;
}
contract Callback {
    uint256 public val;

    fallback() external {
        val = ITest(msg.sender).val(); 
    }
    function test(address target) external {
        ITest(target).test();
    }
}
contract TestStorage {
    uint256 public val;

    function test() public {
        val=123;
        bytes memory b="";
    }
}
contract TestTransientStorage {
    bytes32 constant SLOT =0;

    function test() public {
        assembly {
            tstore(SLOT,321)
        }
        bytes memory b="";
        msg.sender.call(b);
    }
    function val() public view returns (uint256 v) {
        assembly {
            v:= tload(SLOT)
        }
    } 
}
contract ReentrancyGuard {
    bool private locked;
    modifier lock() {
        require(!locked);
        locked = true;
        _;
        locked = false;
    }
    function test() public lock {
        //Ignore call error
        bytes memory b="";
        msg.sender.call(b);
    }
}
contract ReentrancyGuardTransient {
    bytes32 constant SLOT =0;

    modifier lock() {
        assembly {
            if tload(SLOT) {revert(0,0)}
            tstore(SLOT,1)
        }
        _;
        assembly {
            tstore(SLOT,0)
        }
    }

    function test() external lock {
        //Ignore call error
        bytes memory b="";
        msg.sender.call(b);
    }
}

contract Function {
    //Function can return multiple values.
    function returnMany() public pure returns (uintj256, bool, uint256) {
        return (1,true,2)
    }
    //Return values can be named.
    function named() public pure returns (uint256 x, bool b, uint256 y) {
        return (1,true,2);
    }

    //Return values can be assigned to their name.
    //In this case the return statement can be omitted.
    function assigned() public pure returns (uint256 x, bool b, uint256) {
        x=1;
        b=true;
        y=2;
    }

    //Use destructuring assignment when calling another
    function assigned() public pure returns (uint256 x, bool b, uint256 y) {
        x=1;
        b=true;
        y=2;
    }
    //Use destructuring assignment when calling another

    function destructuringAssignments() 
    public
    pure
    returns (uint256, bool uint256, uint256, uint256) {
        (uint256 i,bool b, uint256 j) = returnMany();

        (uint256 x, uint256 y) = (4,5,6);
        return (i,b,j,x,y);
    }

}
contract XYZ {
    function someFuncWithManyInputs(
        uint256 x,
        uint256 y,
        uint256 z,
        address a,
        bool b,
        string memory c
    ) public pure returns (uint256) {}
    function callFunc() external pure returns (uint256) {
        return someFuncWithManyInputs(1,2,3,address(0),true,"c");
    }
    function callFuncWithKeyValue() external pure returns (uint256) {
        return someFuncWithManyInputs({
            a: address(0),
            b:true,
            c:"c",
            x:1,
            y:2,
            z:3
        })
    }
}

contract ViewAndPure {
    uint256 public x=1;

    function addToX(uint256 y) public view returns (uint256) {
        return x+y;
    }
    //Promise not to modify or read from the state.
    function add(uint256 i, uint256 j) public pure returns (uin256) {
        return i+j;
    }
}

contract Error {
    function testRequrie(uint256 _i) public pure {
        require(_i>10, "Input must be greater than 10");
    }

    function testRevert(uint256 _i) public pure {
        if(_i<=10) {
            revert("Input must be greater than 10");
        }
    }
    uint256 public num;

    function testAssert() public view {
        assert(num==0);
    }

    error InsufficientBalance(uint256 balance, uint256 withdrawAmount);
    function testCustomError(uint256 _withdrawAmount) public view {
        uint256 bal = address(this).balance;
        if(bal<_withdrawAmount) {
            revert InsufficientBalance({
                balance: bal,
                withdrawAmount: _withdrawAmount
            })
        }
    }
}

contract Account {
    uint256 oldBalance = balance;
    uint256 newBalacne = balance + _amount;

    require(newBalance >= oldBalance, "Overflow");
    balance = newBalance;

    assert(balance>=oldBalance);
}

function withdraw(uint256 _amount) public {
    uint256 oldBalance = balance;

    require(balance>=_amount, "Underflow");

    if(balance<_amount) {
        revert("Underflow");
    }
    balance-= _amount;

    assert(balance<=oldBalance);
}

contract FunctionModifier {
     
     address public owner;
     uint256 public x=10;
     bool public locked;

     constructor() {
        owner = msg.sender;
     }

     modifier onlyOwner() {
        require(msg.sender==owner, "Not owner");

        _;
     }

     modifier validAddress(address _addr) {
        require(_addr !=address(0), "Not valid address");
        _;
     }

     modifier validAddress(address _addr) {
        require(_addr != address(0), "Not valid address");
        _;
     }
     function changeOwner(address _newOwner) 
        public
        onlyOwner
        validAddress(_newOwner) {
            owner = _newOwner;
        }
    modifier noReentrancy() {
        require(!locked,"No reentrancy");
        locked =true;
        _;
        locked =false;
    }
    function decrement(uint256 i) public noReentrancy {
        x-=i;
        if(i>1) {
            decrement(i-1);
        }
    }
} 

contract Event {

    event Log(address indexed sender, string message);
    event AnotherLog();

    function test() public {
        emit Log(msg.sender,"Hello World!");
        emit Log(msg.sender,"Hello EVM!");
        emit AnotherLog();
    } 
}

contract EventDrivenArchitecture {
    event TransferInitiated(
        address indexed from, address indexed to, uint256 value
    );
    event TransferConfirmed(
        address indexed from, address indexed to, uint256 value 
    );

    mapping(bytes32=>bool) public transferConfirmations;

    function initiateTransfer(address to, uint256 value) public {
        emit TransferInitated(msg.sender, to, value);
        //...(initiate transfer logic)
    }
    function confirmTransfer(bytes32 transferId) public {
        require(
            !transferConfirmations[transferId], "Transfer already confirmed"
        );
        transferConfirmations[transferId]  = true;
        emit TransferConfirmed(msg.sender, address(this),0);
        //...(confirm transfer logic)
    }
 }

//Event Subscription and Real-Time Updates
interface IEventSubscriber {
    function handleTransferEvent(address from, address to, uint256 value)
        external;
}

contract EventSubscription {
    event LogTransfer(address indexed from, address indexed to, uint256 value);

    mapping(address=>bool) public subscribers;
    address[] public subscriberList;

    function subscribe() public {
        require(!subscribers[msg.sender],"Already subscribed");
        subscribers[msg.sender]=true;
        subscriberList.push(msg.sender);
    }
    function unsubscribe() public {
        require(subscribers[msg.sender],"Not subscribed");
        subscribers[msg.sender] = false;
        for(uint256 i=0; i<subscriberList.length;i++) {
            if(subscriberList[i]==msg.sender) {
                subscriberList[i] = subscriberList[subscriberList.length-1];
                subscriberList.pop();
                break;
            }
        }
    }
    function transfer(address to, uint256 value) public {
        emit LogTransfer(msg.sender, to, value);
        for(uint256 i=0;i<subscriberList.length;i++) {
            IEventSubscriber(subscriberList[i]).handleTransferEvent(
                msg.sender, to, value
            )
        }
    }
}

contract X {
    string public name;

    constructor(string memory _name) {
        name = _name;
    }
}

contract Y {
    string public text;
    constructor(string memory _text) {
        text = _text;
    }
}

contract B is X("Input to X"), Y("Input to Y") {}
contract C is X, Y {
    constructor(string memory _name, string memory _text) X(_name) Y(_text) {}
}

contract A {
    function foo() public pure virtual returns (string memory) {
        return "A";
    }
}

//contracts inherit other contracts by using the keyword "is"
contract B is A {
    //Override A.foo()
    function foo() public pure virtual override returns (string memory) {
        return "B"
    }
}
contract C is A {
    function foo() public pure virtual override returns (string memory) {
        return "C";
    }
}

//Contracts can inherit from multiple parent contracts
//When a function is called that is defined multiple times in 
//different contracts, parent contracts are searched from
//right to left, and in depth-first manenr.

contract D is B, C {
    //D.foo() returns "C"
    //Since C is the right mist parent contract with function foo()
    function foo() public pure override(B,C) returns (string memory) {
        return super.foo();
    }
} 

contract E is C, B {
    //E.foo() returns "B"
    //since B is the right most parent contract with function foo()
    function foo() public pure override(C,B) returns (string memory) {
        return super.foo();
    }
 }
 contract A {
    string public name ="contract A";
    function getName() public view returns (string memory) {
        return name;
    }
 }

 //Shadowing is disallowed in Solidity 0.6
 //This will not compile

 contract C is A {
    //This is the correct way to override inherited state variables
    constructor() {
        name ="Contract C";
    }
 }

 contract A {
    //This is called an event. You can emit events from your function
    //and they are logged into the transaction log.
    //In our case, this will be useful for tracing function calls.
    event Log(string message);

    function foo() public virtual {
        emit Log("A.foo called");
    }
    function bar() public virtual {
        emit Log("A.bar called");
    }
 }

 contract B is A {
    function foo() public virtual override {
        emit Log("B.foo called");
        A.foo();
    }
    function bar() public virtual override {
        emit Log("B.bar called");
        super.bar();
    }
 }
 contract C is A {
    function foo() public virtual override {
        emit Log("C.foo called");
        A.foo();
    }
    function bar() public virtual override {
        emit Log("C.bar called");
        super.bar();
    }
 }

 contract D is B, C {

 }

 contract Base {
    //Private function can only be called
    //inside this contract
    //contracts that inherit this contract cannot call this function

    function privateFunc() private pure returns (string memory) {
        return "private function called";
    }

    function testPrivateFunc() public pure returns (string memory) {
        return privateFunc();
    }

    //Internal function can be called
    //inside this contract
    //inside contracts that inherit this contract
    function internalFunc() internal pure returns (string memory) {
        return "internal function called";
    }
    function testInternalFunc() public pure virtual returns (string memory) {
        return interanlFunc();
    }

    //Public functions can be called
    //inside this contract
    //inside contracts that inherit this contract
    // by other contracts and accounts

    function publicFunc() public pure returns (string memory) {
        return "public function called"
    }

    //External functions can only be called
    // by other contracts and accounts
    function externalFunc() external pure returns (string memory) {
        return "external function called";
    }

    //This function will not compile since we're trying to call
    //an external funtion here.
    //function testExternalFunc() public pure returns (string memory) {
        return externalFunc();
    //}

    //State variables
    string private privateVar = "my private variables";
    string internal internalVar = "my internal variables";
    string public publicVar ="my public variable";
    //State variables cannot be external so this code won't compile
    //string external externalVar = "my external variable";
 }

 contract Child is Base {
    //Inherited contracts do not have access to private functions
    //and state variables
    //function testPrivateFunc() public pure returns (string memory) {
    //return privateFunc();
    //}

    //Internal function can be called inside child contracts.
    function testInternalFunc() public pure override returns (string memory) {
        return internalFunc();
    }
 }

 contract Counter {
    uint256 public count;
    function increment() external {
        count +=1;
    }
 }

 interface ICounter {
    function count() external view returns (uint256);
    function increment() external;
 }

 contract MyContract {
    function incrementCounter(address _counter) external {
        ICounter(_counter).increment();
    }
    function getCount(address _counter) external view returns (uint256) {
        return ICounter(_counter).count();
    }
 }

 //Uniswap example
 interface UniswapV2Factory {
    function getPair(address tokenA, address tokenB)
    external
    view
    returns (address pair);
 }
 interface UniswapV2Pair {
    function getReserves() 
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
 }

 contract UniswapExample {
    address private factory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address private dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address private weth =  0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    function getTokenReserves() external view returns (uint256, uint256) {
        address pair = UniswapV2Factory(factory).getPair(dai,weth);
        (uint256 reserve0, uint256 reserve1,) = 
            UniswapV2Pair(pair).getReserves();
            return (reserve0, reserve1);
    }
 }

 contract Payable {
    //Payable address can send Ether via transfer or send
    address payable public owner;

    //Payable constructor can receive Ether
    constructor() payable {
        owner = payable(msg.sender);
    }

    //Function to deposit Ether into this contract
    //Call this function along with some Ether.
    //The balane of this contract will be automatically updated.
    function deposit() public payable {}

    //Call this function along with some Ether.
    //The function will throw an error since this function is not payable.
    function notPayable() public {}

    //Function to withdraw all Ether from this contract
    function withdraw() public {
        //get the amount of Ether stored from this contract.
        uint256 amount = address(this).balance;
        //send all Ether to owenr
        (bool success,) = owner.call{value: amount}("");
        require(success, "Failed to send Ether");
    }
    function transfer(address payable _to, uint256 _amount) public {
        //Note that "to" is declared as payable
        (bool success,) = _to.call{value:_amount}("");
        require(success, "Failed to send Ether");
    }

 }

 contract ReceiveEther {
    //Function to receive Ether. msg.data must be empty
    receive() external payable {}
    //Fallback function is called when msg.data is not empty
    fallback() external payable {}

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
 } 

 contract SendEther {
    function sednViaTransfer(address payable _to) public payable {
        //This function is no longer recommended for sending Ether
        _to.transfer(msg.value);
    }

    function sendViaSend(address payable _to) public payable {
        //Send returns a boolean value indicating success or failure.
        //This function is not recommed for sending Ether.
        bool sent = _to.send(msg.value);
        require(sent,"Failed to send Ether");

    }
    function sendViaCall(address payable _to) public payable {
        //Call returns a boolean value indicating success or failure.
        //This is the current recommended method to use.
        (bool sent, bytes memory data) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
 }

 contract Fallback {
    event Log(string func, uint256 gas);

    //Fallback function must be declared as external
    fallback() external payable {
        //send / transfer (forwards 2300 gas to this fallback function)
        //call(forwards all of the gas)
        emit Log("fallback",gasLeft());
    }

    //Receive is a variant of fallback that is triggered when msg.data is empty
    receive() external payable {
        emit Log("receive",gasLeft());

        //Helper function to check the balance of this contract
        function getBalance() public view returns (uint256) {
            return address(this).balance;
        }
    }
 }
 contract SendToFallback {
    function transferToFallback(address payable _to) public payable {
        _to.transfer(msg.value);
    }
    function callFallback(address payable _to) public payable {
        (bool sent,) = _to.call{value:msg.value}("");
        require(sent, "Failed to send Ether");
    }
 }

 contract FallbackInputOutput {
    address immutable target;

    constructor(address _target) {
        target = _target;
    }

    fallback(bytes calldata data) external payable returns (bytes memory) {
        (bool ok, bytes memory res) = target.call{value:msg.value}(data);
        require(ok,"call failed");
        return res;
    }
 }

 contract Counter {
    uint256 public count;

    function get() external view returns (uint256) {
        return count;
    }
    function inc() external returns (uint256) {
        count +=1;
        return count;
    }
 }

 contract TestFallbackInputOutput {
    event Log(bytes res);
    function test(address _fallback, bytes calldata data) external {
        (bool ok, bytes memory res) = _fallback.call(data);
        require(ok, "call failed");
        emit Log(res);
    }
    function getTestData() external pure returns (bytes memory, bytes memory) {
        return 
          (abi.encodeCall(Counter.get, ()),abi.encodeCall(Counter.inc,()));
    }
 }

contract Receiver {
    event Received(address caller, uint256 amount, string message);

    fallback() external payable {
        emit Received(msg.sender, msg.value, "Fallback was called");
    }
    function foo(string memory _message, uint256 _x) 
        public
        payable
        returns(uint256)
        {
            emit Received(msg.sender, msg.value, _message);

            return _x+1;
        }
}
contract Caller {
    event Response(bool success, bytes data);

    function testCallFoo(address payable _addr) public payable {
        (bool success, bytes memory data) = _addr.call{
            value: msg.value,
            gas:5000
        }(abi.encodeWithSignature("foo(string,uint256)","call foo",123));

        emit Response(success, data);
    } 
}

contract Receiver {
    event Received(address caller, uint256 amount, string message);

    fallback() external payable {
        emit Received(msg.sender, msg.value,"Fallback was called");
    }
    function foo(string memory _message, uint256 _x) 
        public
        payable
        returns (uint256) 
        {
            emit Received(msg.sender, msg.value, _message);
            return _x+1;
        }
}

contract Caller {
    event Response(bool success, bytes data);

    //Let's imagine that contract Caller does not have the source code for the 
    function testCallFoo(address payable _addr) public payable {
        (bool success, bytes memory data) = _addr.call{
            value: msg.value,
            gas: 5000
        }(abi.encodeWithSignature("foo(string,uint256)","call foo",123));
        emit Response(success,data);
    }
}

//Calling a function that does not exist triggers the fallback function
function testCallDoesNotExist(address payable _addr) public payable {
    (bool success, bytes memory data) = _addr.call{value:msg.value} (
        abi.encodeWithSignature("doesNotExist()")
    );

    emit Response(success, data);
}