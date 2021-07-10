const HDWalletProvider = require("truffle-hdwallet-provider");
const fs = require("fs");

module.exports = {
    // See <http://truffleframework.com/docs/advanced/configuration>
    // to customize your Truffle configuration!
    networks: {
        development: {
            host: "127.0.0.1", // Localhost (default: none)
            port: 7545, // Standard Ethereum port (default: none)
            network_id: "5777", // Any network (default: none)
            from: "0x6976e231a2B80052A4d33875eFD386B980a486fC"
        }
    },
    compilers: {
        solc: {
            version: ">=0.4.0 <0.8.0"
        }
    }
};
