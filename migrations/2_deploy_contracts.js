var DuBaoTuongLai = artifacts.require("DuBaoTuongLai");

var KhoTien = "0x44Cf06325362Ae430E1bbe471B159d743F012aEc";

module.exports = deployer => {
    deployer.deploy(DuBaoTuongLai, KhoTien);
};