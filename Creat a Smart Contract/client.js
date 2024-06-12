const anchor = require('@project-serum/anchor');
const { SystemProgram } = anchor.web3;

async function main() {
    const provider = anchor.AnchorProvider.local();
    anchor.setProvider(provider);

    const idl = JSON.parse(
        require('fs').readFileSync('./target/idl/solana_token_transfer.json', 'utf8')
    );

    const programId = new anchor.web3.PublicKey('Fg6PaFpoGXkYsidMpWTK6W2BeZ7FEfcYkgP1rLCh4WhQ');
    const program = new anchor.Program(idl, programId);

    const myAccount = anchor.web3.Keypair.generate();

    // Initialize the account
    await program.rpc.initialize({
        accounts: {
            myAccount: myAccount.publicKey,
            user: provider.wallet.publicKey,
            systemProgram: SystemProgram.programId,
        },
        signers: [myAccount],
    });

    console.log('Account initialized:', myAccount.publicKey.toString());

    // Transfer tokens
    const receiverAccount = anchor.web3.Keypair.generate();
    await program.rpc.transfer(new anchor.BN(10), {
        accounts: {
            sender: myAccount.publicKey,
            receiver: receiverAccount.publicKey,
            owner: provider.wallet.publicKey,
        },
        signers: [provider.wallet.payer],
    });

    console.log('Tokens transferred');
}

main().catch(err => {
    console.error(err);
});