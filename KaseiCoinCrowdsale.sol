pragma solidity ^0.5.0;

import "./KaseiCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";


// Have the KaseiCoinCrowdsale contract inherit the following OpenZeppelin:
// * Crowdsale
// * MintedCrowdsale
contract KaseiCoinCrowdsale is Crowdsale, MintedCrowdsale { // THE CONTRACT SIGNATURE UPDATED WITH INHERITANCE
    
    // Provide parameters for all of the features of your crowdsale, such as the `rate`, `wallet` for fundraising, and `token`.
    constructor(
        uint rate, //rate in TKNbits
        address payable wallet, // where the funds that the token raises should be deposited
        KaseiCoin token // the KaseiCoin that the KaseiCoinCrowdsale will use
    ) public Crowdsale(rate, wallet, token) {
        // constructor can stay empty
    }
   
}


contract KaseiCoinCrowdsaleDeployer {
    // variables to store the addresses of the KaseiCoin and KaseiCoinCrowdsale contracts, which this contract will deploy
    // Create an `address public` variable called `kasei_token_address`, which will store KaseiCoin’s address once that contract has been deployed.
    address public kasei_token_address;
    
    // Create an `address public` variable called `kasei_crowdsale_address`, which will store KaseiCoinCrowdsale's address once that contract has been deployed.
    address public kasei_crowdsale_address;

    // Add the constructor.
    constructor(
        string memory name,
        string memory symbol,
        address payable wallet // this address will receive all of the ether raised by the crowdsale contract
    ) public {
        // Create a new instance of the KaseiCoin contract.
        KaseiCoin token = new KaseiCoin(name, symbol, 0); //token variable where KaseiCoin is stored

        
        // Assign the token contract’s address to the `kasei_token_address` variable.
        kasei_token_address = address(token);

        // Create a new instance of the `KaseiCoinCrowdsale` contract; where rate=1, wallet that will get paid all of the ether raised by the crowdsale contract, token variable where KaseiCoin is stored
        KaseiCoinCrowdsale kaseiCoin_crowdsale = new KaseiCoinCrowdsale(1, wallet, token);
            
        // Aassign the `KaseiCoinCrowdsale` contract’s address to the `kasei_crowdsale_address` variable.
        kasei_crowdsale_address = address(kaseiCoin_crowdsale);

        // Set the `KaseiCoinCrowdsale` contract as a minter
        token.addMinter(kasei_crowdsale_address);
        
        // Have the `KaseiCoinCrowdsaleDeployer` renounce its minter role.
        token.renounceMinter();
    }
}

/* 
1. Deploy the crowdsale to a local blockchain with Remix, MetaMask, and Ganache.

Steps to deploy and utilize the KaseiCoin contract
2. To deploy the KaseiCoinCrowdsaleDeployer contract
    - Select the KaseiCoinCrowdsaleDeployer contract from the contract dropdown menu and fill in the Deploy Section as shown below; 
        Name: KaseiCoin
        Symbol: KAI 
        Wallet: Any Address, eg: 0xf627E0Ef9ce129E7793080f9Ca3299a48ca934dC or 0xA690DbBAfBD2e8d7ba4e5c1a0e6b7fD32A5209A0
    (wallet that will get paid all of the ether raised by the crowdsale contract)
Click Transact and then Confirm the transaction on the Metamask Wallet pop-up 
The Deployer Contract creates and launches Crowdsale and KaseiCoin contracts 

3. To link the Crowdsale Contract, click the Crowdsale contract in the deployment pane and copy the address
    - Select the Crowdsale contract from the contract dropdown menu and paste the address in the 'At Address' Text Bar; 
    - Click 'At Address' and scroll down to see the contract functions

4. To link the KaseiCoin Contract, click the KaseiCoin contract in the deployment pane and copy the address
    - Select the KaseiCoin contract from the contract dropdown menu and paste the address in the 'At Address' Text Bar; 
    - Click 'At Address' and scroll down to see the contract functions

5. Test the functionality of the crowdsale by using test accounts to buy new tokens and then checking the balances associated with those accounts.
    - 0xf627E0Ef9ce129E7793080f9Ca3299a48ca934dC : 15
    - 0xA690DbBAfBD2e8d7ba4e5c1a0e6b7fD32A5209A0 : 10

6. After purchasing tokens with one or more test accounts, view the total supply of minted tokens and the amount of wei 
that has been raised in the crowdsale contract.
    - Total Supply of minted Tokens and the amount of wei raised in crowdsale contract should be 25





*/

