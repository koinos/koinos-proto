@0xc0c529faac9105c3; # unique file ID, generated by `capnp id`

using Common = import "../common.capnp";
using BlockStore = import "../block_store.capnp";
using Json = Common.Json;

$import "/capnp/c++.capnp".namespace("koinos::rpc::block_store");

using Go = import "/go.capnp";
$Go.package("koinos");
$Go.import("koinos/rpc/block_store");

struct BlockStoreReservedRequest {}

struct BlockStoreReservedResponse {}

struct GetBlocksByIDRequest {
   blockID           @0 :List(Common.Hash);
   returnBlockBlob   @1 :Bool = false;
   returnReceiptBlob @2 :Bool = false;
}

struct GetBlocksByIDResponse {
   blockItems @0 :List(BlockStore.BlockItem);
}

struct GetBlocksByHeightRequest {
   headBlockID         @0 :Common.Hash $Json.hex;
   ancestorStartHeight @1 :UInt32;
   numBlocks           @2 :UInt32;
   returnBlock         @3 :Bool;
   returnReceipt       @4 :Bool;
}

struct GetBlocksByHeightResponse {
   blockItems @0 :List(BlockStore.BlockItem);
}

struct AddBlockRequest {
   blockToAdd @0 :BlockStore.BlockItem;
}

struct AddBlockResponse {}

struct GetHighestBlockRequest {}

struct GetHighestBlockResponse {
   topology @0 :Common.BlockTopology;
}

struct BlockStoreErrorResponse {
   errorText @0 :Text;
   errorData @1 :Text;
}

struct BlockStoreRequest {
   union {
      blockStoreReserved @0 :BlockStoreReservedRequest;
      getBlocksByID      @1 :GetBlocksByIDRequest;
      getBlocksByHeight  @2 :GetBlocksByHeightRequest;
      addBlock           @3 :AddBlockRequest;
      getHighestBlock    @4 :GetHighestBlockRequest;
   }
}

struct BlockStoreResponse {
   union {
      blockStoreReserved @0 :BlockStoreReservedResponse;
      errorResponse      @1 :BlockStoreErrorResponse;
      getBlocksByID      @2 :GetBlocksByIDResponse;
      getBlocksByHeight  @3 :GetBlocksByHeightResponse;
      addBlock           @4 :AddBlockResponse;
      getHighestBlock    @5 :GetHighestBlockResponse;
   }
}
