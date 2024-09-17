//SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
//NOTE: Deploy this contract first
contract B {
    //NOTE: storage layout must be the same as contract A
    uint256 public num;
    address public sender;
    uint256 public value;

    function setVars(uint256 _num) public payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract A {
    uint256 public num;
    address public sender;
    uint256 public value;

    function setVars(address _contract, uint256 _num) public payable {
        //A's storage is set, B is not modified
        (bool success, bytes memory data) = _contract.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num);
        );
    }
}

contract FunctionSelector {
    /*
        "transfer(address, uint256)"
        0xa9059cbb
        "transferFrom(address, address,uint256)"
        0x23b872dd
     */
     function getSelector(string calldata _func)
        external
        pure
        returns (byte4) 
     {
        return bytes4(keccak256(bytes(_func)));
     }
}
contract Callee {
    uint256 public x;
    uint256 public value;

    function setX(uint256 _x) public returns (uint256) {
        x=_x;
        return x;
    }

    function setXandSendEther(uint256 _x) {
        public
        payable
        returns (uint256, uint256)
        {
            x=_x;
            value=msg.value;
            return (x,value);
        }
    }
}

contract Caller {
    function setX(Callee _callee, uint256 _x) public {
        uint256 x=_callee.setX(_x);
    }
    function setXFromAddress(address _addr, uint256 _x) public {
        Callee callee = Callee(_addr);
        Callee.setX(_x);
    }
    function setXandSendEther(Callee _callee, uint256 _x) public payable {
        (uint256 x, uint256 value) = 
            _callee.setXandSendEther{value: msg.value}(_x);
    }
}
contract Car {
    address public owner;
    string public model;
    address public carAddr;

    constructior(address _owner, string memory _model) payable {
        owner = _owner;
        model = _model;
        carAddr = address(this);
    }
}

contract CarFactory {
    Car[] public cars;

    function create(address _owner, string memory _model) public {
        Car car = new Car(_owner,_model);
        cars.push(car);
    }
    function createAndSendEther(address _owner, string memory _model)
        public
        payable
    {
        Car car = (new Car){value: msg.value}(_owner, _model);
        cars.push(car);
    }
    function create2(address _owner, string memory _model, byte32 _salt) 
        public
    {
        Car car =( new Car){salt: _salt}(_owner, _model);
        cars.push(car);
    }
    function create2AndSendEther(
        address _owner,
        string memory _model,
        bytes _salt
    ) public payable {
        Car car= (new Car){value:msg.value,salt:_salt}(_owner,_model);
        cars.push(car);
    }
    function getCar(uint256 _index)
        public
        view
        returns (
            address owner,
            string memory model,
            address carAddr,
            uint256 balance
        )
        {
            Car car = cars[_index];
            return (car.owner(), car.model(),car.carAddr(),address(car).balance)
        }
}

contract Foo {
    address public owner;

    constructor(address _owner) {
        require(_owner != address(0),"Invalid address");
        assert(_owner!=0x00000000000000000000000000000000001);
        owner = _owner;
    }

    function myFunc(uint256 x) public pure returns (string memory) {
        require(x!=0, "require failed");
        return "my func was called";
    }
}

contract Bar {
    event Log(string message);
    event LogBytes(bytes data);

    Foo public foo;

    constructor() {
        //This Foo contract is used for example of try catch with external call
        foo = new Foo(msg.sender);
    }
    //Example of try/catch with external call
    //tryCatchExternalCall(0)=>Log("external call failed")
    //tryCatchExternalCall(1)=>Log("my func was called")
    function tryCatchExternalCall(uint256 _i) public {
        try foo.myFunc(_i) returns (string memory result) {
            emit Log(result);
        } catch {
            emit Log("external call failed");
        }
    }

    //Example of try/catch with contract creation
    //tryCatchNewContract(0x0000000000000000000000000000) => Log("Invaild address")
    function tryCatchNewContract(address _owner) public {
        try new Foo(_owner) returns (Foo foo) {
            //you can use variable foo here
            emit Log("Foo created");
        } catch Error(string memory reason) {
            //catch failing revert() and require()
            emit Log(reason)
        } catch (bytes memory reason) {
            //catch failing assert()
            emit LogBytes(reason);
        }
    }
}

library Math {
    function sqrt(uint256 y) internal pure returns (uint256 z) {
        if(y>3) {
            z=y;
            uint256 z=y/2+1;
            while(x<z) {
                z=x;
                x=(y/x+x)/2;
            }
        } else if (y!=0) {
            z=1;
        }
        //else z=0(default value)
    }
}

contract TestMath {
    function testSquareRoot(uint256 x) public pure returns (uint256) {
        return Math.sqrt(x);
    }
}

library Array {
    function removw(uint256[] storage arr, uint256 index) public {
        //Move the last element into the place to delete
        require(arr.length>0,"can't remove from empty array");
        arr[index] = arr[arr.length-1];
        arr.pop();
    }
}
contract TestArray {
    using Array for uint256[];
    uint256[] public arr;

    function testArrayRemove() public {
        for (uint256 i=0;i<3;i++) {
            arr.push(i)
        }
        arr.remove(1);
        assert(arr.length==2);
        assert(arr[0]==0);
        assert(arr[1]==2);
    }
}

interface IERC20 {
    function transfer(address, uint256) external;
}
contract Token {
    function transfer(address, uint256) external {}
}
contract AbiEncode {
    function test(address _contract, bytes calldata data) external {
        (bool ok,) = _contract.call(data);
        require(ok,"call failed");
    }
    function encodeWithSignature(address to, uint256 amount) {
        external
        pure
        returns(bytes memory)
        {
            //Typo is not checked -"transfer(address, uint)"
            return abi.encodeWithSignature("transfer(address,uint256)", to,amount);
        }
    }
    function encodeWithSelector(address to, uint256 amount)
        external
        pure
        returns (bytes memory) {
            //Typo is not checked - (IERC20.transfer.selector , true, amount)
            return abi.encodeWithSelector(IERC20.transfer.selector, to, amount);
        }
    function encodeCall(address to, uint256 amount) 
        external
        pure
        returns (bytes memory)
        {
            //Typo and type errors will not compile
            return abi.encodeCall(IERC20.transfer, (to,amount));
        }
}
contract AbiDecode {
    struct MyStruct {
        string name;
        uint256[2] nums;
    }

    function encode(
        uint256 x,
        address addr,
        uint256[] calldata arr,
        MyStruct calldata myStruct
    ) external pure returns (bytes memory) {
        return abi.encode(x, addr, arr, myStruct);
    }

    function decode(bytes calldata data)
        external
        pure
        returns (
            uint256 x,
            address addr,
            uint256[] memory arr,
            MyStruct memory myStruct
        )
        {
            //(uint x, address addr, uint[] memory arr, MyStruct myStruct)=...
            (x, addr, arr, myStruct) = abi.decode(data,(uint256, address,uint256[],MyStruct));
        }
}