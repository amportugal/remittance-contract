var Remittance = artifacts.require("./Remittance.sol");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(Remittance, "carolpass", "bobpass", {from: accounts[0], value: 10000000})
          .then(() => {
            console.log("Deployed Remittance contract, owner ==> (", accounts[0], "),")
          });
};
