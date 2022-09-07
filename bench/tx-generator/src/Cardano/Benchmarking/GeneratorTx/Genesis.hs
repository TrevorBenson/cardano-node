{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}
module Cardano.Benchmarking.GeneratorTx.Genesis
  ( genesisFundForKey
  , genesisExpenditure
  )
where

import           Cardano.Prelude hiding (TypeError, filter)
import qualified Data.ListMap as ListMap
import           Prelude (error, filter)

import           Cardano.Api
import           Cardano.Api.Shelley (fromShelleyLovelace, fromShelleyPaymentCredential,
                   fromShelleyStakeReference, ReferenceScript(..))
import           Control.Arrow ((***))

import           Cardano.Benchmarking.FundSet
import           Cardano.Benchmarking.GeneratorTx.Tx

import           Cardano.Ledger.Shelley.API (Addr (..), ShelleyGenesis, sgInitialFunds)
import           Ouroboros.Consensus.Shelley.Eras (StandardShelley)

genesisFunds :: forall era. IsShelleyBasedEra era
  => NetworkId -> ShelleyGenesis StandardShelley -> [(AddressInEra era, Lovelace)]
genesisFunds networkId g
 = map (castAddr *** fromShelleyLovelace)
     $ ListMap.toList
     $ sgInitialFunds g
 where
  castAddr (Addr _ pcr stref)
    = shelleyAddressInEra $ makeShelleyAddress networkId (fromShelleyPaymentCredential pcr) (fromShelleyStakeReference stref)
  castAddr _ = error "castAddr:  unhandled Shelley.Addr case"

genesisFundForKey :: forall era. IsShelleyBasedEra era
  => NetworkId
  -> ShelleyGenesis StandardShelley
  -> SigningKey PaymentKey
  -> (AddressInEra era, Lovelace)
genesisFundForKey networkId genesis key
  = fromMaybe (error "No genesis funds for signing key.")
    . head
    . filter (isTxOutForKey . fst)
    $ genesisFunds networkId genesis
 where
  isTxOutForKey addr = keyAddress networkId key == addr

genesisExpenditure ::
     IsShelleyBasedEra era
  => NetworkId
  -> SigningKey PaymentKey
  -> AddressInEra era
  -> Lovelace
  -> Lovelace
  -> SlotNo
  -> SigningKey PaymentKey
  -> (Tx era, Fund)
genesisExpenditure networkId inputKey addr coin fee ttl outputKey = (tx, Fund $ InAnyCardanoEra cardanoEra fund)
 where
  tx = mkGenesisTransaction (castKey inputKey) 0 ttl fee [ pseudoTxIn ] [ txout ]

  value = mkTxOutValueAdaOnly $ coin - fee
  txout = TxOut addr value TxOutDatumNone ReferenceScriptNone

  pseudoTxIn = genesisUTxOPseudoTxIn networkId
                 (verificationKeyHash $ getVerificationKey $ castKey inputKey)

  castKey :: SigningKey PaymentKey -> SigningKey GenesisUTxOKey
  castKey(PaymentSigningKey skey) = GenesisUTxOSigningKey skey

  fund = FundInEra {
    _fundTxIn = (TxIn (getTxId $ getTxBody tx) (TxIx 0))
  , _fundWitness = KeyWitness KeyWitnessForSpending
  , _fundVal  = value
  , _fundSigningKey = Just outputKey
  }
