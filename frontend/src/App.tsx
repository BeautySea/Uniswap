import React, { useState, useEffect } from "react";
import { ethers } from "ethers";
import Web3 from "web3";
import EtherWalletABI from "./EtherWalletABI.json"; // Import the ABI

// Define types for props and state
interface EtherWalletContract extends ethers.Contract {
  withdraw: (amount: ethers.BigNumber) => Promise<ethers.providers.TransactionResponse>;
  getBalance: () => Promise<ethers.BigNumber>;
}

const App: React.FC = () => {
  const [account, setAccount] = useState<string>("");
  const [contract, setContract] = useState<EtherWalletContract | null>(null);
  const [balance, setBalance] = useState<string>("0");
  const [amount, setAmount] = useState<string>("");

  const contractAddress: string = "0xaADfeFc7c0dD9aD788c0Ffd09b31df064E806d79"; // Contract address from Hardhat deployment

  useEffect(() => {
    loadWeb3();
    loadBlockchainData();
  }, []);

  // Load web3 instance and account information
  const loadWeb3 = async () => {
    if (window.ethereum) {
      window.web3 = new Web3(window.ethereum);
      await window.ethereum.request({ method: "eth_requestAccounts" });
    } else {
      window.alert("Please install MetaMask!");
    }
  };

  // Load contract and account data
  const loadBlockchainData = async () => {
    const web3 = window.web3;
    const accounts = await web3.eth.getAccounts();
    setAccount(accounts[0]);

    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner();

    // Load EtherWallet contract
    const walletContract = new ethers.Contract(
      contractAddress,
      EtherWalletABI,
      signer
    ) as EtherWalletContract;

    setContract(walletContract);
    loadBalance(walletContract);
  };

  // Load balance of the contract
  const loadBalance = async (walletContract: EtherWalletContract) => {
    try {
      const contractBalance = await walletContract.getBalance();
      setBalance(ethers.utils.formatEther(contractBalance.toString()));
    } catch (error) {
      console.error("Error loading balance:", error);
    }
  };

  // Function to handle Ether withdrawal
  const withdrawEther = async () => {
    if (!contract) {
      return;
    }

    try {
      const parsedAmount = ethers.utils.parseEther(amount);
      const txn = await contract.withdraw(parsedAmount);
      await txn.wait();
      alert("Withdraw successful!");
      loadBalance(contract); // Update balance after withdrawal
    } catch (error) {
      console.error("Error withdrawing Ether:", error);
    }
  };

  return (
    <div className="App">
      <h1>EtherWallet DApp</h1>
      <p>Your Account: {account}</p>
      <p>Contract Balance: {balance} ETH</p>

      <div>
        <input
          type="text"
          placeholder="Amount in ETH"
          value={amount}
          onChange={(e) => setAmount(e.target.value)}
        />
        <button onClick={withdrawEther}>Withdraw</button>
      </div>
    </div>
  );
};

export default App;
