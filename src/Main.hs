{-# LANGUAGE Arrows #-}

module Main where

import qualified Crypto.Schnorr             as Schnorr
import           Data.ByteString            (ByteString)
import qualified Data.ByteString            as BS
import qualified Data.ByteString.Base16     as B16
import qualified Data.ByteString.Char8      as B8
import           Data.Char                  (chr)
import           Data.Monoid
import           Data.Text                  (Text, unpack)
import           Debug.Trace
import           Options.Applicative.Arrows
import           Options.Applicative.Simple
import           System.Exit
import           System.IO.Unsafe           (unsafePerformIO)

data SignParams = SignParams
    { keypair :: String
    , message :: String
    }

data VerifyParams = VerifyParams
    { xonlyPubKey :: String
    , signature   :: String
    , message'    :: String
    }

signParams :: Parser SignParams
signParams =
  runA $ proc () ->
  do kp <- (asA . strOption) (long "keypair" <> short 'k') -< ()
     m <- (asA . strOption) (long "message" <> short 'm') -< ()
     returnA -< SignParams kp m

verifyParams :: Parser VerifyParams
verifyParams =
  runA $ proc () ->
  do p <- (asA . strOption) (long "xonlypubkey" <> short 'x') -< ()
     s <- (asA . strOption) (long "signature" <> short 's') -< ()
     m <- (asA . strOption) (long "message" <> short 'm') -< ()
     returnA -< VerifyParams p s m

main :: IO ()
main = do
  (opts, runCmd) <-
    simpleOptions
      "0.1.0"
      "Schnorr-CLI"
      "Generate keys, sign & verify schnorr messages"
      (pure ()) $ do
      addCommand
        "gen"
        "Generate a new keypair"
        (const generateKeyPair)
        (pure ())
      addCommand
        "pub"
        "Calculate the xonly pub key from given keypair"
        calculateXOnlyPubKey
        (strOption (long "keypair" <> short 'k'))
      addCommand "sign" "Sign with schnorr signature" signMessage signParams
      addCommand
        "verify"
        "Verify a schnorr signature"
        verifySignature
        verifyParams
  runCmd

generateKeyPair :: IO ()
generateKeyPair = do
  kp <- Schnorr.generateKeyPair
  putStrLn $ Schnorr.exportKeyPair kp

calculateXOnlyPubKey :: String -> IO ()
calculateXOnlyPubKey s = do
  case getKeyPair s of
    Right k ->
      putStrLn $ Schnorr.exportXOnlyPubKey $ Schnorr.deriveXOnlyPubKey k
    Left k -> do
      putStrLn "Invalid keypair"
      exitFailure

signMessage :: SignParams -> IO ()
signMessage p = do
  case (getKeyPair $ keypair p, getMsg $ message p) of
    (Right k, Right m) ->
      putStrLn $ Schnorr.exportSchnorrSig $ Schnorr.signMsgSchnorr k m
    (Left k, _) -> do
      putStrLn k
      exitFailure
    (_, Left m) -> do
      putStrLn m
      exitFailure

verifySignature :: VerifyParams -> IO ()
verifySignature p = do
  case ( getXOnlyPubKey $ xonlyPubKey p
       , getSignature $ signature p
       , getMsg $ message' p) of
    (Right p, Right s, Right m) ->
      putStrLn $
      if Schnorr.verifyMsgSchnorr p s m
        then "True"
        else "False"
    (Left p, _, _) -> do
      putStrLn p
      exitFailure
    (_, Left s, _) -> do
      putStrLn s
      exitFailure
    (_, _, Left m) -> do
      putStrLn m
      exitFailure

load :: String -> (ByteString -> Maybe a) -> String -> Either String a
load s f e =
  case Schnorr.decodeHex s of
    Just bs ->
      case f bs of
        Just b -> Right b
        _      -> Left e
    Nothing -> Left e

getKeyPair :: String -> Either String Schnorr.KeyPair
getKeyPair s = load s Schnorr.keypair "Invalid KeyPair"

getMsg :: String -> Either String Schnorr.Msg
getMsg s = load s Schnorr.msg "Invalid Message"

getXOnlyPubKey :: String -> Either String Schnorr.XOnlyPubKey
getXOnlyPubKey s = load s Schnorr.xOnlyPubKey "Invalid XOnlyPubKey"

getSignature :: String -> Either String Schnorr.SchnorrSig
getSignature s = load s Schnorr.schnorrSig "Invalid Schnorr Signature"

hexToBytes :: String -> Either Text ByteString
hexToBytes = B16.decodeBase16 . B8.pack
