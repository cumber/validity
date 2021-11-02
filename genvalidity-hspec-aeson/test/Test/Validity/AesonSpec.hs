{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications #-}

module Test.Validity.AesonSpec where

import Data.Aeson
import Data.GenValidity
import Data.GenValidity.Aeson ()
import Data.GenValidity.Text ()
import Data.Text (Text)
import GHC.Generics
import Test.Hspec
import Test.Validity.Aeson

spec :: Spec
spec = do
  jsonSpecOnGen (genListOf $ pure 'a') "sequence of 'a's" (const [])
  -- jsonSpec @Double DOES NOT HOLD
  jsonSpec @Rational
  jsonSpec @Int
  jsonSpecOnArbitrary @Int
  jsonSpec @ForShow
  jsonSpec @Value

-- shrinkValidSpec @Value

newtype ForShow
  = ForShow Text
  deriving (Show, Eq, Generic)

instance Validity ForShow

instance GenValid ForShow where
  genValid = genValidStructurally
  shrinkValid = shrinkValidStructurally

instance FromJSON ForShow

instance ToJSON ForShow

-- >>> decode (Data.Aeson.encode (ForShow "\248")) :: Maybe ForShow
-- Just (ForShow "\248")
