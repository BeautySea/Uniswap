import { useState, useEffect } from "react";
import { ethers } from "ethers";
//import EtherWalletABI from "./EtherWalletABI.json"; // Import the ABI


const App = () => {
  const [provider, setProvider] = useState(null);
  const [signer, setSigner] = useState(null);
  const [walletContract, setWalletContract] = useState(null);
  const [balance, setBalance] =  useState("0");
  const [userAddress, setUserAddress] = useState("");
  const [withdrawAmount, setWithdrawAmount] = useState("");
 // EtherWallet Contract Address and ABI
  const contractAddress : string = "0xdBBac20aBd10aC5E393895a1ee159Fb039c0A58F"; 
  const EtherWalletABI:any = [
    {
      "inputs": [],
      "stateMutability": "nonpayable",
      "type": "constructor"
    },
    {
      "inputs": [],
      "name": "getBalance",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "_amount",
          "type": "uint256"
        }
      ],
      "name": "withdraw",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "stateMutability": "payable",
      "type": "receive"
    }
  ];
  useEffect(() => {
    const initializeEthers = async () => {
        if (window.ethereum) {
            const tempProvider = new ethers.BrowserProvider(window.ethereum);
            const tempSigner =await tempProvider.getSigner();
            const contract = new ethers.Contract(contractAddress, EtherWalletABI, tempSigner);

            setProvider(tempProvider);
            setSigner(tempSigner);
            setWalletContract(contract);
        } else {
            console.log("Please install MetaMask");
        }
    };
    initializeEthers();
  },[]);

  //Fetch the balance of the contract

  const getBalance = async () => {
    if (walletContract) {
        console.log("before send request")
        const balance = await walletContract.getBalance();
        console.log("after response",balance)
        setBalance(ethers.formatEther(balance));
    }
  } ;

  //Withdraw funds from the contract
  const withdrawFunds = async () => {
    if(walletContract && withdrawAmount) {
        try {
            const tx = await walletContract.withdraw(ethers.parseEther(withdrawAmount));
            await tx.wait();
            console.log("Withdrawal successful");
            getBalance();
        } catch(error) {
            console.error("Error during withdrawal:", error);
            console.error("Withdrawal failed");
        }
    }
  };

  //Request user account from MetaMask
  const connectWallet = async () => {
    if (provider) {
        const accounts = await provider.send("eth_requestAccounts",[]);
        setUserAddress(accounts[0]);
    }
  }

  return (
    <div className="App">
      <h1>EtherWallet DApp</h1>
      {!userAddress && (
        <button onClick={connectWallet}>Connect Wallet</button>
      )}
      {userAddress && <p>Connected Address: {userAddress}</p>}

      <div>
        <h2>Contract Balance: {balance} ETH</h2>
        <button onClick={getBalance}>Get Balance</button>
      </div>
      
      <div>
        <input type="text" placeholder="Amount to withdraw (ETH)" 
            value= {withdrawAmount}
            onChange={(e) => setWithdrawAmount(e.target.value)}/>
        <button onClick={withdrawFunds}>Withdraw</button>
      </div>
    </div>
  );
};

export default App;
