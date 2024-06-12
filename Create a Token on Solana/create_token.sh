#!/bin/bash

# Set up variables
WALLET_FILE=~/my-solana-wallet.json
TOKEN_NAME="My Token"
TOKEN_SYMBOL="MTK"
TOKEN_URI="https://example.com/my-token-metadata.json"
INITIAL_SUPPLY=1000

# Create a new wallet if it doesn't exist
if [ ! -f "$WALLET_FILE" ]; then
  solana-keygen new --outfile $WALLET_FILE
  solana config set --keypair $WALLET_FILE
fi

# Get the wallet address
WALLET_ADDRESS=$(solana-keygen pubkey $WALLET_FILE)

# Create a new token
TOKEN_ADDRESS=$(spl-token create-token | grep -oP '(?<=Creating token )\w+')

# Create an account to hold the token
ACCOUNT_ADDRESS=$(spl-token create-account $TOKEN_ADDRESS | grep -oP '(?<=Creating account )\w+')

# Mint tokens into the account
spl-token mint $TOKEN_ADDRESS $INITIAL_SUPPLY $ACCOUNT_ADDRESS

# Create metadata JSON file
cat <<EOF > metadata.json
{
  "name": "$TOKEN_NAME",
  "symbol": "$TOKEN_SYMBOL",
  "uri": "$TOKEN_URI",
  "seller_fee_basis_points": 500,
  "creators": [
    {
      "address": "$WALLET_ADDRESS",
      "verified": true,
      "share": 100
    }
  ]
}
EOF

# Upload metadata to a public server (this step requires you to manually upload the file)
echo "Upload the metadata.json file to a public server and provide the URL."

# Once uploaded, update the URI in the script and run the metaplex command
echo "Run the following command to set the metadata for your token:"
echo "metaplex-token-metadata create_metadata_accounts_v2 --name \"$TOKEN_NAME\" --symbol \"$TOKEN_SYMBOL\" --uri \"$TOKEN_URI\" --mint $TOKEN_ADDRESS --update-authority $WALLET_ADDRESS"
