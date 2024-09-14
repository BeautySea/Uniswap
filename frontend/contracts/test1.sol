//SPDX-License-Indentifier: MIT
//compiler version must be greater than or equal to 0.8.26 and less than 0.9.0
pragma solidity ^0.8.26;

contract EtherUnits {
    uint256 public oneWei = 1 wei;
    bool public isOneWei =(oneWei ==1);

    uint256 public oneGwei = 1 gwei;
    bool public isOneGwei = (oneGwei==1e9);
    uint256 public oneEther =1 ether;
    bool public isOneEther =(oneEther==1e18);
}

contract Mapping {
    //Mapping from address to uint
    mapping(address=>uint256) public myMap;

    function get(address _addr) public view returns (uint256) {
        //Mapping always returns a value.
        //If the value was never set, it will return the default value.
        return myMap[_addr];
    }

    function set(address _addr, uint256 _i) public {
        //Update the value at this address
        myMap[_addr] = _i;
    }
    function remove(address _addr) public {
        //Reset the value to the default value.
        delete myMap[_addr];
    }
}

contract NestedMapping {
    //Nested mapping (mapping from address to another mapping)
    mapping(address=>mapping(uint256=>bool)) public nested;

    function get(address _addr1, uint256 _i) public view returns(bool) {
        //You can get the values from a nested mapping
        //even when it is not initialized
        return nested[_addr1][_i];
    }
    function set(address _addr1, uint256 _i, bool _boo) public {
        nested[_addr1][_i] = _boo;
    }
    function remove(address _addr1, uint256 _i, bool _boo) public {
        nested[_addr1][_i]  = _boo;
    }
    function remove(address _addr1, uint256 _i) {
        delete nested[_addr1][_i];
    }
}

contract Array {
    //Several ways to initialize an array
    uint256[] public arr;
    uint256[] public arr2 = [1,2,3];
    //Fixed sized array, all elements initialize to 0
    uint256[10] public myFixedSizeArr;

    function get(uint256 i) public view returns (uint256) {
        return arr[i];
    }
    function getArr() public view returns (uint256[] memory) {
        return arr;
    }
    function push(uint256 i) public {
        arr.push(i);
    }
    function pop() public {
        arr.pop();
    }
    function getLength() public view returns (uint256) {
        return arr.length;
    }
    function remove(uint256 index) public {
        //Delete does not change the length.
        //It resets the value at index to it's default value,
        //in this case 0
        delete arr[index];
    }
    function examples() external {
        //create array in memory, only fixed size can be created
        uint256[] memory a =new uint256[](5);
    }
}
contract ArrayRemoveByShifting {
    uint256[] public arr;
    function remove(uint256 _index) public {
        require(_index<arr.length, "index out of bound");

        for(uint256 i=_index;i<arr.length-1;i++) {
            arr[i]=arr[i+1];
        }
        arr.pop();
    }
    function test() external {
        arr=[1,2,3,4,5];
        remove(2);
        assert(arr[0]==1);
        assert(arr[1]==2);
        assert(arr[2]==4);
        assert(arr[3]==5);
        assert(arr.length==4);

        arr=[1];
        remove(0);

        assert(arr.length==0);
    }
}
contract ArrayReplaceFromEnd {
    uint256[] public arr;

    function remove(uint256 index) public {
        arr[index] = arr[arr.length-1];
        arr.pop();
    }
    function test() public {
        arr =[1,2,3,4];

        remove(1);
        assert(arr.length==3);
    }
}