# Solana SPL Token Creation

This project contains scripts to create a new SPL token on the Solana blockchain, create an account to hold the token, mint the tokens, and add metadata using the Token Extensions program.

## Prerequisites

- Solana CLI
- Rust
- Node.js and npm
- Solana wallet

## Steps

1. **Install the Solana Tool Suite:**

    ```sh
    sh -c "$(curl -sSfL https://release.solana.com/stable/install)"
    export PATH="/home/your-user/.local/share/solana/install/active_release/bin:$PATH"
    solana --version
    ```

2. **Run the `create_token.sh` Script:**

    ```sh
    chmod +x create_token.sh
    ./create_token.sh
    ```

3. **Upload the `metadata.json` File:**

    Upload the generated `metadata.json` file to a public server and update the URL in the script.

4. **Set the Metadata:**

    After uploading the `metadata.json` file, run the following command to set the metadata for your token:

    ```sh
    metaplex-token-metadata create_metadata_accounts_v2 --name "My Token" --symbol "MTK" --uri "https://example.com/my-token-metadata.json" --mint <TOKEN_ADDRESS> --update-authority <YOUR_WALLET_ADDRESS>
    ```

## Notes

- Ensure you have sufficient SOL in your wallet to cover transaction fees.
- Replace placeholder values with your actual data.
