## `IPNFT`






### `init(address masterChef_)` (public)





### `meta(uint256 tokenId) → uint256, uint256, uint256` (public)



Get metadata of `tokenId`.

### `musicId(uint256 tokenId) → uint256` (public)



Get `musicId` of `_meta`.

### `gain(uint256 tokenId) → uint256` (public)



Get `gain` of `_meta`.

### `setGain(uint256 tokenId, uint256 gain_)` (public)



Change `gain` of `_meta`.

### `mint(address to, uint256 tokenId, uint256 musicId_, uint256 gain_)` (public)



Mint NFT with amount of `musicId_` and `gain_`.

### `updateNftEpoch(uint256 tokenId)` (public)



Update `lastUpdatedEpoch` of `tokenId`.

### `setEpoch(uint256 epoch_)` (public)



Update current epoch.


