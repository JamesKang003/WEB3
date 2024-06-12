use anchor_lang::prelude::*;

declare_id!("Fg6PaFpoGXkYsidMpWTK6W2BeZ7FEfcYkgP1rLCh4WhQ");

#[program]
pub mod solana_token_transfer {
    use super::*;

    pub fn initialize(ctx: Context<Initialize>) -> ProgramResult {
        let my_account = &mut ctx.accounts.my_account;
        my_account.owner = *ctx.accounts.user.key;
        my_account.balance = 0;
        Ok(())
    }

    pub fn transfer(ctx: Context<Transfer>, amount: u64) -> ProgramResult {
        let sender = &mut ctx.accounts.sender;
        let receiver = &mut ctx.accounts.receiver;

        if sender.balance < amount {
            return Err(ErrorCode::InsufficientFunds.into());
        }

        sender.balance -= amount;
        receiver.balance += amount;
        Ok(())
    }
}

#[derive(Accounts)]
pub struct Initialize<'info> {
    #[account(init, payer = user, space = 8 + 40)]
    pub my_account: Account<'info, MyAccount>,
    #[account(mut)]
    pub user: Signer<'info>,
    pub system_program: Program<'info, System>,
}

#[derive(Accounts)]
pub struct Transfer<'info> {
    #[account(mut, has_one = owner)]
    pub sender: Account<'info, MyAccount>,
    #[account(mut)]
    pub receiver: Account<'info, MyAccount>,
    pub owner: Signer<'info>,
}

#[account]
pub struct MyAccount {
    pub owner: Pubkey,
    pub balance: u64,
}

#[error]
pub enum ErrorCode {
    #[msg("Insufficient funds.")]
    InsufficientFunds,
}