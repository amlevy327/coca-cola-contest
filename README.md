# coca-cola-contest

The Coca-Cola Company
Contest using Smart Contracts
🔴 Contest Conundrum: Cap Collection Chaos

Remember the contest? Collecting bottle cap IDs?
Hoarding countless caps, afraid to lose them.
Embrace the digital evolution of contests!

🖥️ Why Blockchain? Elegance in Tracking.

Imagine this: sip, input, toss.
Code auto verified & added to account.
Reach goal, mint prize as digital token!

🔗 Sip to Success: Smart Contracts.

Deploy 1 contract & adds codes.
Input code, contract validates, count updated.
Hit target, mint NFT prize!

🟢 The Evolution: Clutter to Convenience

🔍 Clutter-free, digital participation.
🏆 Fresh twist on classic thrill.
🤝🏻 Reach expanded, simplicity enjoyed.

### Step by step:
1. Coca Cola deploys contract for promotion.
2. Coca Cola initializes all tiers (prizes) on contract.
3. Coca Cola initializes all codes on contract.
4. Customer redeems valid codes. Added to balance.
5. When balance high enough for desired tier (prize), customer mints NFT prize!

## Play around yourself!

### Mumbai testnet smart contracts:
- CocaColaCodes: [0xC444be6365CECC9c85a03043c023A1fC97cB44ed](https://mumbai.polygonscan.com/address/0xC444be6365CECC9c85a03043c023A1fC97cB44ed)

### How to interact through PolygonScan
1. Obtain Mumbai MATIC. [FAUCET](https://faucet.polygon.technology/).
2. Redeem codes. Use #5 redeemCodes. Inputs: wallet_ = your wallet, codes_ = array of valid codes. [WRITE CONTRACT](https://mumbai.polygonscan.com/address/0xC444be6365CECC9c85a03043c023A1fC97cB44ed#writeContract).
- Valid codes as of this writing: [119,129,139,149,159,169,179,189,199,1109,1119,1129,1139, 1119,1129,1139,1149,1159,1169,1179,1189,1199,11109,11119,11129,11139]
3. When code balance high enough, mint NFT prize! Use #4 mintPrize. Inputs: wallet_ = your wallet, tierId_ = prize you want to mint. [WRITE CONTRACT](https://mumbai.polygonscan.com/address/0xC444be6365CECC9c85a03043c023A1fC97cB44ed#writeContract).
4. 3. Verify received status NFT!
- Option 1: Click "View Transaction". Check "Tokens Transferred" field.
- Option 2: Read #6 balanceOfTier. Inputs: owner_ = your wallet, tierId_ = tier id from step 3. Should return value of 1. [READ CONTRACT](https://mumbai.polygonscan.com/address/0xC444be6365CECC9c85a03043c023A1fC97cB44ed#readContract). 