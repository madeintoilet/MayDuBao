var DuBaoTuongLai = artifacts.require("DuBaoTuongLai");

var KhoTien = "0xE8b7242e1Ea907c82D23865eDAa1fE7d6904bD3d"; // Dia chi Token NGIN tren mang Rinkeby

module.exports = deployer => {
    deployer.deploy(DuBaoTuongLai, KhoTien);
};