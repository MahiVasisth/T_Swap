//SPDX-License-Identifier : MIT
pragma solidity ^0.8.20;
import {Test} from "forge-std/Test.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import {TSwapPool} from "../../src/TSwapPool.sol";

  contract TSwappractice is Test {
    TSwapPool public pool;
    ERC20Mock public poolToken;    
    ERC20Mock public wethToken;    
    address liquidityProvider = makeAddr("liquidityProvider");
    address user = makeAddr("user");
    function setUp() public {
        poolToken = new ERC20Mock();
        wethToken = new ERC20Mock();
        pool = new TSwapPool(address(poolToken),address(wethToken),"LTokenA","LA");
        wethToken.mint(liquidityProvider, 200e18);
        poolToken.mint(liquidityProvider, 200e18);

        wethToken.mint(user, 10e18);
        poolToken.mint(user, 10e18);
      }
   
      function testdeposit_practice() public {
        vm.startPrank(liquidityProvider); 
        poolToken.approve(address(pool),100e18);
        wethToken.approve(address(pool),100e18);
        pool.deposit(100e18,100e18,100e18,uint64(block.timestamp));
        assertEq(pool.balanceOf(liquidityProvider),100e18);
        assertEq(poolToken.balanceOf(liquidityProvider),100e18);
        assertEq(wethToken.balanceOf(liquidityProvider),100e18);
        assertEq(wethToken.balanceOf(address(pool)), 100e18);
        assertEq(poolToken.balanceOf(address(pool)), 100e18);
    }

    function testwithdraw_practice() public {
      vm.startPrank(liquidityProvider); 
      poolToken.approve(address(pool),100e18);
      wethToken.approve(address(pool),100e18);
      pool.deposit(100e18,100e18,100e18,uint64(block.timestamp));
      pool.withdraw(100e18,100e18,100e18 , uint64(block.timestamp));
      assertEq(pool.balanceOf(liquidityProvider),0);
      assertEq(poolToken.balanceOf(liquidityProvider),200e18);
      assertEq(wethToken.balanceOf(liquidityProvider),200e18);
      assertEq(wethToken.balanceOf(address(pool)), 0);
      assertEq(poolToken.balanceOf(address(pool)), 0);
    }
   
     function test_getoutput_amountbasedon_weth() public {
      uint256 inputAmount = 1e18;
      uint256 inputReserves = 1e18;
      uint256 outputReserves = 1e18;
       uint256 actual_result = pool.getOutputAmountBasedOnInput(inputAmount,inputReserves,outputReserves);
        uint256 inputAmountMinusFee = inputAmount * 997;
        uint256 numerator = inputAmountMinusFee * outputReserves;
        uint256 denominator = (inputReserves * 1000) + inputAmountMinusFee;
        uint256 expected_result = numerator / denominator;
        assert(actual_result == expected_result);
     }
     function testCollectFees() public {
      vm.startPrank(liquidityProvider);
      wethToken.approve(address(pool), 100e18);
      poolToken.approve(address(pool), 100e18);
      pool.deposit(100e18, 100e18, 100e18, uint64(block.timestamp));
      vm.stopPrank();

      vm.startPrank(user);
      uint256 expected = 9e18;
      poolToken.approve(address(pool), 10e18);
      pool.swapExactInput(poolToken, 10e18, wethToken, expected, uint64(block.timestamp));
      vm.stopPrank();

      vm.startPrank(liquidityProvider);
      pool.approve(address(pool), 100e18);
      pool.withdraw(100e18, 90e18, 100e18, uint64(block.timestamp));
      assertEq(pool.totalSupply(), 0);
      assert(wethToken.balanceOf(liquidityProvider) + poolToken.balanceOf(liquidityProvider) > 400e18);
  }

    }