// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {GovHelpers} from 'aave-helpers/GovHelpers.sol';
import {AaveGovernanceV2} from 'aave-address-book/AaveGovernanceV2.sol';
import {AaveV3Basenet} from 'aave-address-book/AaveV3Basenet.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/ProtocolV3TestBase.sol';
import {AaveV3_BaseActivation} from '../src/contracts/AaveV3_BaseActivation.sol';
import {ICapsPlusRiskSteward} from 'aave-helpers/riskstewards/ICapsPlusRiskSteward.sol';
import {IAaveV3ConfigEngine} from 'aave-helpers/v3-config-engine/IAaveV3ConfigEngine.sol';

/**
 * @dev Test for AaveV3_BaseActivation
 */
contract AaveV3_BaseActivation_Test is ProtocolV3TestBase {
  AaveV3_BaseActivation internal proposal;
  address public constant RISK_COUNCIL = 0xfbeB4AcB31340bA4de9C87B11dfBf7e2bc8C0bF1;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('base'), 2480613);
    proposal = new AaveV3_BaseActivation();
  }

  function testProposalExecution() public {
    ReserveConfig[] memory allConfigsBefore = createConfigurationSnapshot(
      'preAaveV3_Base_BaseActivation',
      AaveV3Basenet.POOL
    );

    GovHelpers.executePayload(vm, address(proposal), AaveGovernanceV2.BASENET_BRIDGE_EXECUTOR);

    ReserveConfig[] memory allConfigsAfter = createConfigurationSnapshot(
      'postAaveV3_Base_BaseActivation',
      AaveV3Basenet.POOL
    );

    // diffReports('preAaveV3_Basenet_BasenetActivation', 'postAaveV3_Basenet_BasenetActivation');

    e2eTest(AaveV3Basenet.POOL);

    assertEq(
      address(proposal.PRICE_ORACLE_SENTINEL()),
      AaveV3Basenet.POOL_ADDRESSES_PROVIDER.getPriceOracleSentinel()
    );

    testIncreaseCapsMax();
  }

  function testIncreaseCapsMax() internal {
    address[] memory reserves = AaveV3Basenet.POOL.getReservesList();
    (uint256 borrowCapBefore, uint256 supplyCapBefore) = AaveV3Basenet
      .AAVE_PROTOCOL_DATA_PROVIDER
      .getReserveCaps(reserves[0]);

    IAaveV3ConfigEngine.CapsUpdate[] memory capUpdates = new IAaveV3ConfigEngine.CapsUpdate[](1);
    capUpdates[0] = IAaveV3ConfigEngine.CapsUpdate({
      asset: reserves[0],
      supplyCap: supplyCapBefore * 2,
      borrowCap: borrowCapBefore * 2
    });

    ICapsPlusRiskSteward steward = ICapsPlusRiskSteward(AaveV3Basenet.CAPS_PLUS_RISK_STEWARD);

    vm.startPrank(RISK_COUNCIL);
    steward.updateCaps(capUpdates);

    (uint256 borrowCapAfter, uint256 supplyCapAfter) = AaveV3Basenet
      .AAVE_PROTOCOL_DATA_PROVIDER
      .getReserveCaps(reserves[0]);

    ICapsPlusRiskSteward.Debounce memory debounce = steward.getTimelock(reserves[0]);
    assertEq(borrowCapAfter, capUpdates[0].borrowCap);
    assertEq(supplyCapAfter, capUpdates[0].supplyCap);
    assertEq(debounce.supplyCapLastUpdated, block.timestamp);
    assertEq(debounce.borrowCapLastUpdated, block.timestamp);
  }
}
