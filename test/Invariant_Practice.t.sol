// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Test, console } from "forge-std/Test.sol";
import { TSwapPool } from "../../src/TSwapPool.sol";
import { PoolFactory } from "../../src/PoolFactory.sol";
import { ERC20Mock } from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import { IERC20 } from "@openzeppelin/contracts/interfaces/IERC20.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";


contract Invariant is StdInvariant , Test {
    TSwapPool public pool;
    ERC20Mock public poolToken;    
    ERC20Mock public wethToken;    
    ERC20Mock public tokenA;    
    ERC20Mock public tokenB;    
    PoolFactory public factory;
    address liquidityProvider = makeAddr("liquidityProvider");
    // address user = makeAddr("user");
    int256 constant starting_X = 100e18;
    int256 constant starting_Y = 50e18;
    function setUp() public {
        poolToken = new ERC20Mock();
        wethToken = new ERC20Mock();
        tokenA = new ERC20Mock();
        tokenB = new ERC20Mock();
        
        factory = new PoolFactory(address(wethToken));
        pool = new TSwapPool(factory.createPool(address(poolToken)));
        wethToken.mint(address(this), uint256(starting_X));
        poolToken.mint(address(this), uint256(starting_Y));
        poolToken.approve(address(pool),type(uint256).max);
        wethToken.approve(address(pool), type(uint256).max);
        pool.deposit(uint256(starting_Y),uint256(starting_Y),uint256(starting_X), uint64(block.timestamp));
    }

     function statefulfuzz_constantproductformulastayssame() public {

     }

}