var Remittance = artifacts.require("./Remittance.sol");
const Web3 = require("web3");
var web3;

if (typeof web3 !== 'undefined') {
  web3 = new Web3(web3.currentProvider);
} else {
  web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}

module.exports = function(deployer, network, accounts) {
  var remittanceInstance;
  deployer.deploy(Remittance, {from: accounts[0]})
          .then(() => {
            console.log("Deployed Remittance contract\nowner ==> (", accounts[0], ")");

            return Remittance.deployed();
          })
          .then(function(_instance) {
            remittanceInstance = _instance;

            console.log("Calculating solution to upload...");

            return _instance.calculateHash.call(accounts[1], "carolPass", "bobPass");
          })
          .then(function(_solution) {
            console.log("Calculated solution succesfully!");

            console.log("Uploading solution for account:", accounts[1]);

            remittanceInstance.uploadSolution(_solution, 20, {from: accounts[0], value: 10000000})

            console.log("Uploaded solution successfully!");
          });
};
