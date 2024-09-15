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