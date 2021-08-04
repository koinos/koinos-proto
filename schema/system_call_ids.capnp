@0xacced203f4b9dd66; # unique file ID, generated by `capnp id`

$import "/capnp/c++.capnp".namespace("koinos::chain");

using Go = import "/go.capnp";
$Go.package("koinos");
$Go.import("koinos/chain");

enum SystemCallID {
   prints                        @0;
   verifyBlockHeader             @1;
   applyBlock                    @2;
   applyTransaction              @3;
   applyReservedOperation        @4;
   applyUploadContractOperation  @5;
   applyExecuteContractOperation @6;
   applySetSystemCallOperation   @7;
   dbPutObject                   @8;
   dbGetObject                   @9;
   dbGetNextObject               @10;
   dbGetPrevObject               @11;
   executeContract               @12;
   getEntryPoint                 @13;
   getContractArgsSize           @14;
   getContractArgs               @15;
   setContractReturn             @16;
   exitContract                  @17;
   getHeadInfo                   @18;
   hash                          @19;
   recoverPublicKey              @20;
   verifyBlockSignature          @21;
   verifyMerkleRoot              @22;
   getTransactionPayer           @23;
   getMaxAccountResources        @24;
   getTransactionResourceLimit   @25;
   getLastIrreversibleBlock      @26;
   getCaller                     @27;
   requireAuthority              @28;
   getTransactionSignature       @29;
   getContractID                 @30;
   getHeadBlockTime              @31;
   getAccountNonce               @32;
}
