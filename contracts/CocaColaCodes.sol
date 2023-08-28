// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract CocaColaCodes is ERC721Enumerable  {
  using Counters for Counters.Counter;
  Counters.Counter private _nextTokenId;

  // TIER LEVELS (PRIZES)
  uint256 public constant TIER_1_CODES = 2; // sticker
  uint256 public constant TIER_2_CODES = 4; // backpack
  uint256 public constant TIER_3_CODES = 6; // shirt
  uint256 public constant TIER_4_CODES = 8; // retro product

  // TIER (PRIZES)
  struct Tier {
    uint256 id;
    uint256 maxSupply;
    uint256 totalSupply;
    uint256 codesToMint;
    string name;
  }
  mapping(uint256 => Tier) private _tier;
  mapping(address => mapping(uint256 => uint256)) private _ownerTierBalance;
  mapping(address => mapping(uint256 => mapping(uint256 => uint256))) private _ownerTierToken;
  uint256 private constant _maxTiers = 10;
  uint256 private _totalTiers;

  // CODES STATUS
  uint256 private _totalCodesInitialized;
  uint256 private _totalCodesRedeemed;
  mapping(uint256 => bool) private _validCode;
  mapping(uint256 => address) private _codeRedeemed;

  // WALLET STATUS
  mapping(address => uint256) private _walletCodeBalance;

  // EVENTS
  event TierInitialized(uint256 id, uint256 maxSupply, uint256 codesToMint, string name);
  event CodeInitialized(uint256 code);
  event CodeRedeemed(address indexed wallet, uint256 code, uint256 walletCodeBalance);
  event PrizeMinted(address indexed wallet, uint256 walletCodeBalance, uint256 indexed tierId, uint256 tierPrizesRemaining);

  constructor(
    string memory name_,
    string memory symbol_
  ) ERC721(name_, symbol_) {
    // start at token id = 1
    _nextTokenId.increment();
  }
  
  /**
  ////////////////////////////////////////////////////
  // External Functions 
  ///////////////////////////////////////////////////
  */

  // Initialize tiers (prizes)
  // Called by Coca Cola after contract deployed: add access control
  function initTier(
    uint256 id_,
    uint256 maxSupply_,
    uint256 codesToMint_,
    string memory name_
  ) external virtual {
    require(id_ < _maxTiers, "TIER_UNAVAILABLE");
    require(_tier[id_].id == 0, "TIER_ALREADY_INITIALIZED");
    require(maxSupply_ > 0, "INVALID_MAX_SUPPLY");
    require(codesToMint_ > 0, "INVALID_CODES_TO_MINT");

    _tier[id_] = Tier(id_, maxSupply_, 0, codesToMint_, name_);
    _totalTiers++;

    emit TierInitialized(id_, maxSupply_, codesToMint_, name_);
  }

  // Initialize codes
  // Called by Coca Cola after contract deployed: add access control
  function initCodes(uint256[] memory codes_) external {
    uint256 code;
    for (uint256 i = 0; i < codes_.length; i++) {
      code = codes_[i];
      require(_validCode[code] == false, "CODE_ALREADY_INITIALIZED");
      _validCode[code] = true;
      _totalCodesInitialized++;
      emit CodeInitialized(code);
    }
  }

  // Input and check codes
  // Called by customer or Coca Cola: if Coca Cola, add access control
  function redeemCodes(address wallet_, uint256[] memory codes_) external {
    uint256 code;
    for (uint256 i = 0; i < codes_.length; i++) {
      code = codes_[i];
      require(_validCode[code] == true, "CODE_NOT_INITIALIZED");
      require(_codeRedeemed[code] == address(0), "CODE_ALREADY_REDEEMED");
      _codeRedeemed[code] = wallet_;
      _totalCodesRedeemed++;
      _walletCodeBalance[wallet_]++;
      emit CodeRedeemed(wallet_, code, _walletCodeBalance[wallet_]);
    }
  }

  // Mint NFT prize
  // Called by customer or Coca Cola: if Coca Cola, add access control
  function mintPrize(address wallet_, uint256 tierId_) external {
    Tier storage tier = _tier[tierId_];
    require(tier.totalSupply + 1 <= tier.maxSupply, "TIER_MAX_SUPPLY_REACHED");
    require(_walletCodeBalance[wallet_] >= tier.codesToMint, "CODES_TOO_LOW");
    _mintPrize(wallet_, tierId_);
  }

  /**
  ////////////////////////////////////////////////////
  // Internal Functions 
  ///////////////////////////////////////////////////
  */
  function _mintPrize(address wallet_, uint256 tierId_) internal {
    Tier storage tier = _tier[tierId_];
    uint256 tokenId = _maxTiers + (tier.totalSupply * _maxTiers) + tierId_;
    _safeMint(wallet_, tokenId);
    tier.totalSupply++;
    _ownerTierToken[wallet_][tierId_] [
      _ownerTierBalance[wallet_][tierId_]
    ] = tokenId;
    _ownerTierBalance[wallet_][tierId_]++;

    _walletCodeBalance[wallet_] -= tier.codesToMint;

    emit PrizeMinted(wallet_, _walletCodeBalance[wallet_], tierId_, (tier.maxSupply - tier.totalSupply));
  }

  /**
  ////////////////////////////////////////////////////
  // View only functions
  ///////////////////////////////////////////////////
  */

  function maxTiers() external view virtual returns (uint256) {
    return _maxTiers;
  }

  function totalTiers() external view virtual returns (uint256) {
    return _totalTiers;
  }

  function tierInfo(
    uint256 tierId_
    ) external view virtual returns (uint256 maxSupply, uint256 totalSupply, uint256 codesToMint, string memory name) {
      require(tierId_ <= _totalTiers, "TIER_UNAVAILABLE");
      Tier storage tier = _tier[tierId_];
      return (tier.maxSupply, tier.totalSupply, tier.codesToMint, tier.name);
  }

  // TODO: incorrect?
  function tierTokenByIndex(
    uint256 tierId_,
    uint256 index_
  ) external view returns (uint256) {
    require(tierId_ <= _totalTiers, "TIER_UNAVAILABLE");
    return (index_ * _maxTiers) + tierId_;
  }

  function tierTokenOfOwnerByIndex(
    address owner_,
    uint256 tierId_,
    uint256 index_
  ) external view returns (uint256) {
    require(tierId_ <= _totalTiers, "TIER_UNAVAILABLE");
    require(index_ < _ownerTierBalance[owner_][tierId_], "INVALID_INDEX");
    return _ownerTierToken[owner_][tierId_][index_];
  }

  function balanceOfTier(
    address owner_,
    uint256 tierId_
  ) external view virtual returns (uint256) {
    require(tierId_ <= _totalTiers, "TIER_UNAVAILABLE");
    return _ownerTierBalance[owner_][tierId_];
  }

  function totalCodesInitialized() external view virtual returns (uint256) {
    return _totalCodesInitialized;
  }

  function totalCodesRedeemed() external view virtual returns (uint256) {
    return _totalCodesRedeemed;
  }

  function validCode(uint256 code) external view virtual returns (bool) {
    return _validCode[code];
  }

  function codeRedeemed(uint256 code) external view virtual returns (address) {
    return _codeRedeemed[code];
  }

  function walletCodeBalance(address wallet) external view virtual returns (uint256) {
    return _walletCodeBalance[wallet];
  }
}