// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// 블록체인 세미나 실습 #1

// Hello, World! 출력하는 컨트랙트

// 함수는 다음과 같이 있습니다:
// 1. hello(): "Hello, {name}!"을 반환하는 함수. {name}은 디폴트로 "World"입니다
// 2. changeNameToCallerAddr(): 함수 호출자의 이름을 저장하는 함수
// 3. changeNameToString(string): 인자로 받은 이름을 저장하는 함수

// 컨트랙트 선언
contract Hello {
    // public 변수는 외부에서 다이렉트로 읽기가 가능하다
    string public name = "World";

    // public 함수: 외부에서 접근 가능. 여기에서 외부란 다른 컨트랙트나 사용자(호출지갑)를 의미
    // view 함수: 상태를 변경하지 않고 데이터를 읽기만 하는 함수. 수수료 없이 무료로 실행 가능
    function hello() public view returns (string memory) {
        return string(abi.encodePacked("Hello, ", name, "!"));
    }

    // view가 아닌 함수. 상태를 변경하는 함수이며, 수수료가 발생한다
    function changeNameToCallerAddr() public {
        name = toString(msg.sender); // 주소는 address라는 고유의 타입이므로, 문자열로 변환하여 저장
    }

    // 인자로 받은 이름을 저장하는 함수
    function changeNameToString(string memory _name) public {
        name = _name;
    }

    // 주소를 문자열로 변환하는 util 함수
    // internal 함수: 컨트랙트 내부에서만 접근 가능
    // pure 함수: 상태를 변경하지 않고, 컨트랙트의 데이터도 읽지 않는 함수. 이에 반해 view는 컨트랙트의 데이터를 읽을 수 있음
    function toString(address _addr) internal pure returns (string memory) {
        bytes32 value = bytes32(uint256(uint160(_addr)));
        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(42);
        str[0] = "0";
        str[1] = "x";

        for (uint256 i = 0; i < 20; i++) {
            str[2 + i * 2] = alphabet[uint8(value[i + 12] >> 4)];
            str[3 + i * 2] = alphabet[uint8(value[i + 12] & 0x0f)];
        }

        return string(str);
    }
}

// 그 외 알면 좋은 것:
// private: 오직 컨트랙트 내부에서만 접근 가능
// external: 오직 외부에서만 접근 가능
// payable 함수: 이더리움을 송금받을 수 있는 함수
