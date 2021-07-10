var PredictionContract = artifacts.require("./PredictionContract.sol");

module.exports = deployer => {
    deployer.deploy(PredictionContract);
};