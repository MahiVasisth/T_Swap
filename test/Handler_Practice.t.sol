// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Test, console } from "forge-std/Test.sol";
import { TSwapPool } from "../../src/TSwapPool.sol";
import { ERC20Mock } from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";


contract TSwapPoolTest is Test {
    TSwapPool public pool;
    ERC20Mock public weth;
    ERC20Mock public _poolToken;
    

    
    constructor(TSwapPool _pool){
       pool = _pool;
       weth = ERC20Mock(_pool.getWeth());
       _poolToken = ERC20Mock(_pool.getPoolToken());

    }
    function swapPoolTokenforwethbasedonOutputWeth(uint256 outputWeth) public {
       outputWeth = bound(outputWeth , 0 , type(uint64).max);
       if(outputWeth >= weth.balanceOf(address(pool))){
        return ;
       }
       uint256 poolTokenAmount = pool.getInputAmountBasedOnOutput(
        outputWeth , 
        poolToken.balanceOf(address(pool)),
        weth.balanceOf(address(pool))
    );
    if(poolTokenAmount > type(uint64).max) {
        return;
    }
    starting_Y = int256(weth.balanceOf(address(this)));
    starting_X = int256(poolToken.balanceOf(address(this)));

}

}