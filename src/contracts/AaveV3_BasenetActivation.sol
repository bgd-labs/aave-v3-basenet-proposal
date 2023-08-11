// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3PayloadBasenet, IEngine, Rates, EngineFlags} from 'aave-helpers/v3-config-engine/AaveV3PayloadBasenet.sol';
import {AaveV3Basenet} from 'aave-address-book/AaveV3Basenet.sol';
import {IPriceOracleSentinel} from 'aave-v3-core/contracts/interfaces/IPriceOracleSentinel.sol';

/**
 * @title Basenet Activation
 * @author BGD labs
 * - Snapshot: TODO
 * - Discussion: TODO
 */
contract AaveV3_BasenetActivation is AaveV3PayloadBasenet {
  address public constant WETH = 0x4200000000000000000000000000000000000006;
  address public constant WETH_PRICE_FEED = 0x71041dddad3595F9CEd3DcCFBe3D1F4b0a16Bb70;

  // address public constant wstETH = 0x0;
  // address public constant wstETH_PRICE_FEED = 0x945fD405773973d286De54E44649cc0d9e264F78;

  address public constant cbETH = 0x2Ae3F1Ec7F1F5012CFEab0185bfc7aa3cf0DEc22;
  address public constant cbETH_PRICE_FEED = 0x80f2c02224a2E548FC67c0bF705eBFA825dd5439;

  address public constant USDbC = 0xd9aAEc86B65D86f6A7B5B1b0c42FFA531710b6CA;
  address public constant USDbC_PRICE_FEED = 0x7e860098F58bBFC8648a4311b374B1D669a2bc6B;

  address public constant PRICE_ORACLE_SENTINEL = 0xe34949A48cd2E6f5CD41753e449bd2d43993C9AC;

  function eModeCategoriesUpdates()
    public
    view
    override
    returns (IEngine.EModeCategoryUpdate[] memory)
  {
    IEngine.EModeCategoryUpdate[] memory eModeUpdates = new IEngine.EModeCategoryUpdate[](1);

    eModeUpdates[0] = IEngine.EModeCategoryUpdate({
      eModeCategory: 1,
      ltv: 93_00,
      liqThreshold: 90_00,
      liqBonus: 2_00,
      priceSource: address(0),
      label: 'ETH correlated'
    });

    return eModeUpdates;
  }

  function newListings() public pure override returns (IEngine.Listing[] memory) {
    IEngine.Listing[] memory listings = new IEngine.Listing[](3);

    listings[0] = IEngine.Listing({
      asset: WETH,
      assetSymbol: 'WETH',
      priceFeed: WETH_PRICE_FEED,
      rateStrategyParams: Rates.RateStrategyParams({
        optimalUsageRatio: _bpsToRay(80_00),
        baseVariableBorrowRate: 0,
        variableRateSlope1: _bpsToRay(3_80),
        variableRateSlope2: _bpsToRay(80_00),
        stableRateSlope1: _bpsToRay(4_00),
        stableRateSlope2: _bpsToRay(80_00),
        baseStableRateOffset: _bpsToRay(3_00),
        stableRateExcessOffset: _bpsToRay(5_00),
        optimalStableToTotalDebtRatio: _bpsToRay(20_00)
      }),
      enabledToBorrow: EngineFlags.ENABLED,
      stableRateModeEnabled: EngineFlags.DISABLED,
      borrowableInIsolation: EngineFlags.DISABLED,
      withSiloedBorrowing: EngineFlags.DISABLED,
      flashloanable: EngineFlags.ENABLED,
      ltv: 80_00,
      liqThreshold: 83_00,
      liqBonus: 5_00,
      reserveFactor: 15_00,
      supplyCap: 200,
      borrowCap: 160,
      debtCeiling: 0,
      liqProtocolFee: 10_00,
      eModeCategory: 1
    });

    // listings[1] = IEngine.Listing({
    //   asset: wstETH,
    //   assetSymbol: 'wstETH',
    //   priceFeed: WSTETH_PRICE_FEED,
    //   rateStrategyParams: Rates.RateStrategyParams({
    //     optimalUsageRatio: _bpsToRay(45_00),
    //     baseVariableBorrowRate: 0,
    //     variableRateSlope1: _bpsToRay(4_50),
    //     variableRateSlope2: _bpsToRay(80_00),
    //     stableRateSlope1: _bpsToRay(4_00),
    //     stableRateSlope2: _bpsToRay(80_00),
    //     baseStableRateOffset: _bpsToRay(3_00),
    //     stableRateExcessOffset: _bpsToRay(5_00),
    //     optimalStableToTotalDebtRatio: _bpsToRay(20_00)
    //   }),
    //   enabledToBorrow: EngineFlags.ENABLED,
    //   stableRateModeEnabled: EngineFlags.DISABLED,
    //   borrowableInIsolation: EngineFlags.DISABLED,
    //   withSiloedBorrowing: EngineFlags.DISABLED,
    //   flashloanable: EngineFlags.ENABLED,
    //   ltv: 78_50,
    //   liqThreshold: 81_00,
    //   liqBonus: 7_50,
    //   reserveFactor: 15_00,
    //   supplyCap: 100,
    //   borrowCap: 20,
    //   debtCeiling: 0,
    //   liqProtocolFee: 10_00,
    //   eModeCategory: 1
    // });

    listings[1] = IEngine.Listing({
      asset: cbETH,
      assetSymbol: 'cbETH',
      priceFeed: cbETH_PRICE_FEED,
      rateStrategyParams: Rates.RateStrategyParams({
        optimalUsageRatio: _bpsToRay(45_00),
        baseVariableBorrowRate: 0,
        variableRateSlope1: _bpsToRay(7_00),
        variableRateSlope2: _bpsToRay(300_00),
        stableRateSlope1: _bpsToRay(4_00),
        stableRateSlope2: _bpsToRay(80_00),
        baseStableRateOffset: _bpsToRay(3_00),
        stableRateExcessOffset: _bpsToRay(5_00),
        optimalStableToTotalDebtRatio: _bpsToRay(20_00)
      }),
      enabledToBorrow: EngineFlags.ENABLED,
      stableRateModeEnabled: EngineFlags.DISABLED,
      borrowableInIsolation: EngineFlags.DISABLED,
      withSiloedBorrowing: EngineFlags.DISABLED,
      flashloanable: EngineFlags.ENABLED,
      ltv: 67_00,
      liqThreshold: 74_00,
      liqBonus: 7_50,
      reserveFactor: 15_00,
      supplyCap: 100,
      borrowCap: 20,
      debtCeiling: 0,
      liqProtocolFee: 10_00,
      eModeCategory: 1
    });

    listings[2] = IEngine.Listing({
      asset: USDbC,
      assetSymbol: 'USDbC',
      priceFeed: USDbC_PRICE_FEED,
      rateStrategyParams: Rates.RateStrategyParams({
        optimalUsageRatio: _bpsToRay(90_00),
        baseVariableBorrowRate: 0,
        variableRateSlope1: _bpsToRay(4_00),
        variableRateSlope2: _bpsToRay(60_00),
        stableRateSlope1: _bpsToRay(50),
        stableRateSlope2: _bpsToRay(60_00),
        baseStableRateOffset: _bpsToRay(1_00),
        stableRateExcessOffset: _bpsToRay(8_00),
        optimalStableToTotalDebtRatio: _bpsToRay(20_00)
      }),
      enabledToBorrow: EngineFlags.ENABLED,
      stableRateModeEnabled: EngineFlags.DISABLED,
      borrowableInIsolation: EngineFlags.ENABLED,
      withSiloedBorrowing: EngineFlags.DISABLED,
      flashloanable: EngineFlags.ENABLED,
      ltv: 77_00,
      liqThreshold: 80_00,
      liqBonus: 5_00,
      reserveFactor: 15_00,
      supplyCap: 1_000_000,
      borrowCap: 800_000,
      debtCeiling: 0,
      liqProtocolFee: 10_00,
      eModeCategory: 0
    });
  }

  function _postExecute() internal override {
    AaveV3Basenet.ACL_MANAGER.addRiskAdmin(AaveV3Basenet.CAPS_PLUS_RISK_STEWARD);

    AaveV3Basenet.POOL_ADDRESSES_PROVIDER.setPriceOracleSentinel(PRICE_ORACLE_SENTINEL);
  }
}
