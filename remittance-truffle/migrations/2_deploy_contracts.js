var Remittance = artifacts.require("./Remittance.sol");
const Web3 = require("web3");
var web3;

if (typeof web3 !== 'undefined') {
  web3 = new Web3(web3.currentProvider);
} else {
  web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}

module.exports = function(deployer, network, accounts) {
  deployer.deploy(Remittance, accounts[1], web3.sha3("carolpass" + "bobpass"), {from: accounts[0], value: 10000000})
          .then(() => {
            console.log("Deployed Remittance contract\nowner ==> (", accounts[0], ")\n"
                                                    + "hash ==> " + web3.sha3("carolpass" + "bobpass"))
          });
};
