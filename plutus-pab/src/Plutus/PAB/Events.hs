{-# LANGUAGE DeriveAnyClass     #-}
{-# LANGUAGE DeriveGeneric      #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE FlexibleContexts   #-}
{-# LANGUAGE LambdaCase         #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE TemplateHaskell    #-}
{-

Events that we store in the database.

-}
module Plutus.PAB.Events
    ( PABEvent(..)
    , _UpdateContractInstanceState
    , _SubmitTx
    , _ActivateContract
    , _StopContract
    ) where

import Control.Lens.TH (makePrisms)
import Data.Aeson (FromJSON, ToJSON, Value)
import GHC.Generics (Generic)
import Ledger.Tx (CardanoTx, getCardanoTxId)
import Plutus.Contract.Effects (PABReq, PABResp)
import Plutus.Contract.State (ContractResponse)
import Plutus.PAB.Webserver.Types (ContractActivationArgs)
import Prettyprinter (Pretty, pretty, (<+>))
import Wallet.Types (ContractInstanceId)

-- | A structure which ties together all possible event types into one parent.
data PABEvent t =
    UpdateContractInstanceState !(ContractActivationArgs t) !ContractInstanceId !(ContractResponse Value Value PABResp PABReq) -- ^ Update the state of a contract instance
    | SubmitTx !CardanoTx -- ^ Send a transaction to the node
    | ActivateContract !(ContractActivationArgs t) !ContractInstanceId
    | StopContract !ContractInstanceId
    deriving stock (Eq, Show, Generic)
    deriving anyclass (ToJSON, FromJSON)

makePrisms ''PABEvent

instance Pretty t => Pretty (PABEvent t) where
    pretty = \case
        UpdateContractInstanceState t i _ -> "Update state:" <+> pretty t <+> pretty i
        SubmitTx t                        -> "SubmitTx:" <+> pretty (getCardanoTxId t)
        ActivateContract _ i              -> "Start contract instance" <+> pretty i
        StopContract i                    -> "Stop contract instance" <+> pretty i
