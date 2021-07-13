const getWeb3 = () =>
  new Promise(async (resolve, reject) => {
    // Wait for loading completion to avoid race conditions with web3 injection timing
    // window.addEventListener("load", async() => {
    // Modern dapp browsers....
    if (window.ethereum) {
      const web3 = new Web3(window.ethereum);
      try {
        // Request accounts access
        await window.ethereum.enable();

        //Accounts now exposed
        resolve(web3);
      } catch (error) {
        reject(error);
      }
    }
    // Legacy dapp browsers...
    else if (window.web3) {
      // Use Mist/Metamask's provider
      const web3 = window.web3;
      console.log("Injected web3 detected.");
      resolve(web3);
    }
    // Fallback to local host
    else {
      console.log("Khong ket noi duoc ETH");
    }
    // });
  });

var web3;
var contractAddr;
var contractInst;

$(function () {
  function setWeb3Provider(url) {
    // let web3;
    // web3 = await getWeb3();

    // Ket noi mang blockchain thong qua dia chi BLOCKCHAIN client
    // web3 = new Web3(new Web3.providers.HttpProvider(url));
    // web3 = new Web3(window.ethereum);
    //let web3;
    // web3 = new Web3(window.web3.currentProvider);
    // web3 = new Web3(window.web3);

    getWeb3()
      .then(function (w3) {
        web3 = w3;

        // console.log(web3.eth.blockNumber);
        // web3.eth.getBlockNumber(console.log);
        web3.eth.getCoinbase(function (err, address) {
          if (!err) {
            console.log(address);
            $("#addressAccount").val(address);
            $("#showAddressConfirm").val(address);
          } else {
            console.error("Unable to fetch accounts!");
          }
        });
        // Cap nhat danh sach tai khoan
        // populateAccounts(web3.eth.accounts);
        // web3.eth.getAccounts(function (err, accs) {
        // 	if (!err) {
        // 		console.log(accs[0]);
        // 		populateAccounts(accs);
        // 	} else {
        // 		console.error("Unable to fetch accounts!");
        // 	}
        // });
      })
      .catch(function (err) {
        console.error("Could not get web3");
      });
  }

  function _() {
    if (typeof web3 !== "undefined") {
      web3 = new Web3(web3.currentProvider);
    } else {
      // Ket noi mang blockchain thong qua Web3.provider
      web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:8545"));
    }
  }

  function setContractAddress(addr) {
    // Ket noi hop dong thong minh SMART CONTRACT theo giao dien tuong tac ABI

    var HDMBContract = web3.eth.contract(contractABI);

    contractInst = HDMBContract.at(addr);

    console.log(contractInst.address);
  }

  function watchContract() {
    // Hien thi cac gia tri thuoc tinh cua hop dong => TIEN HANG, TIEN VAN CHUYEN
    contractInst.GTHD_TienHang((err, result) => {
      $("#GoodsValue").text(result.toString(10));
      $("#ETHGoodsValue").text((result / 1000000).toString(10));
    });
    contractInst.GTHD_TienVanChuyen((err, result) => {
      $("#DeliveryFee").text(result.toString(10));
      $("#ETHDeliveryFee").text((result / 1000000).toString(10));
    });
    contractInst.NguoiBan((err, result) =>
      $("#Seller").text(result.toString(10))
    );
    contractInst.NguoiVanChuyen((err, result) =>
      $("#Transporter").text(result.toString(10))
    );
    contractInst.NguoiMua((err, result) =>
      $("#Buyer").text(result.toString(10))
    );

    contractInst.TrangThaiHopDong((err, result) => CapNhatTrangThaiHD(result));
    // $("#Insurance").text(contractInst.TrongTai().toString(10));

    //$("#ContractStatus").text(contractInst.TrangThaiHopDong().toString(10));

    // Kiem soat cac su kien xay ra tren hop dong
    $("#ContractEvents").empty();
    contractInst.allEvents(function (error, log) {
      if (!error) {
        console.log(log);
        eventText = log.event;

        $("#ContractEvents").append(
          $("<p>").attr("class", "event-line").text(eventText)
        );
      } else {
        console.log(error);
      }
    });
  }

  function populateAccounts(accs) {
    $(".account-select").each(function (index, select) {
      select = $(select);
      select.empty();
      $.each(accs, function (index, a) {
        select.append($("<option></option>").attr("value", a).text(a));
      });
    });
  }

  function updateContractStatus() {
    if (contractAddr) {
      // Lay so du tien ETH trong contract
      web3.eth.getBalance(contractAddr, function (err, balance) {
        $("#ContractBalance").text(balance.dividedBy(10 ** 12).toString(10));
        $("#ContractBalance2").text(balance.dividedBy(10 ** 18).toString(10));

        contractInst.TrangThaiHopDong((err, result) =>
          CapNhatTrangThaiHD(result)
        );

        contractInst.NguoiMua((err, result) =>
          $("#Buyer").text(result.toString(10))
        );
      });
    }
  }

  function CapNhatTrangThaiHD(intTrangThaiHopDong) {
    var astrTrangThai = [
      "Hợp đồng mới",
      "Người mua đã đặt tiền",
      "Hàng đang trên đường",
      "Hàng đã tới",
      "Hoàn thành",
      "Thất bại",
      "Chờ phân xử",
    ];
    $("#ContractStatus").text(astrTrangThai[intTrangThaiHopDong]);
  }

  function makeTxnObj(acc_select, value) {
    if (value) {
      // Doi tien ra don vi WEI
      // amount = parseInt($(value).val()) * 10**18; tinh theo don vi ether
      amount = parseInt($(value).val()) * 10 ** 12; // tinh theo don vi szabo
    } else {
      amount = 0;
    }
    return {
      from: $(acc_select).val(),
      value: amount,
    };
  }

  function sendStep1() {
    let DiaChiGiaoHang = $("#DeliveryAddressIn").val();
    console.log(DiaChiGiaoHang);

    // Tao giao dich gui den ham NguoiMuaDatTien trong SMART CONTRACT hop dong mua ban
    return contractInst.NguoiMuaDatTien.sendTransaction(
      DiaChiGiaoHang,
      makeTxnObj("#TxnAcc1", "#BuyAmount"),
      function (error) {
        if (error) {
          console.error(error);
          $("#Step1Error").show();
        } else {
          $("#Step1Error").hide();
        }
      }
    );
  }

  function sendStep2() {
    return contractInst.NguoiVanChuyenDatTien.sendTransaction(
      makeTxnObj("#TxnAcc2", "#CollateralAmount"),
      function (error) {
        if (error) {
          console.error(error);
          $("#Step2Error").show();
        } else {
          $("#Step2Error").hide();
        }
      }
    );
  }

  function sendStep3() {
    let param1 = $("#DeliveredToAddress").val();
    console.log(param1);
    return contractInst.XacNhanGiaoHangDenDich.sendTransaction(
      param1,
      makeTxnObj("#TxnAcc3"),
      function (error) {
        if (error) {
          console.error(error);
          $("#Step3Error").show();
        } else {
          $("#Step3Error").hide();
        }
      }
    );
  }

  function sendStep4() {
    console.log("Nguoi mua nhan loi");
    let param1 = $("#GoodsOK:checked").length > 0;
    let param2 = $("#BuyerFailed:checked").length > 0;
    console.log(param1, param2);
    return contractInst.XacNhanTinhTrangHangHoa.sendTransaction(
      param1,
      param2,
      makeTxnObj("#TxnAcc4"),
      function (error) {
        if (error) {
          console.error(error);
          $("#Step4Error").show();
        } else {
          $("#Step4Error").hide();
        }
      }
    );
  }

  function sendStep5() {
    console.log("Nguoi van chuyen nhan loi");
    let bTinhHuongChuyenTraHang = $("#GoodsReturnFailed:checked").length > 0;

    if (bTinhHuongChuyenTraHang == false) {
      return contractInst.XacNhanThatBaiDoVanChuyen.sendTransaction(
        makeTxnObj("#TxnAcc5"),
        function (error) {
          if (error) {
            console.error(error);
            $("#Step5Error").show();
          } else {
            $("#Step5Error").hide();
          }
        }
      );
    } else {
      return contractInst.VanChuyenDenTienChoNguoiBan.sendTransaction(
        makeTxnObj("#TxnAcc5"),
        function (error) {
          if (error) {
            console.error(error);
            $("#Step5Error").show();
          } else {
            $("#Step5Error").hide();
          }
        }
      );
    }
  }

  function sendStep6() {
    console.log("Nguoi ban hang nhan loi");
    let bTinhHuongChuyenHoanTra = $("#ReceivedBack:checked").length > 0;
    if (bTinhHuongChuyenHoanTra == false) {
      let param1 = $("#ReturnAll4Shipper:checked").length > 0;
      let param2 = $("#FineAmount").val();
      console.log("", param1, param2);
      return contractInst.XacNhanThatBaiDoNguoiBan.sendTransaction(
        param1,
        makeTxnObj("#TxnAcc6", "#FineAmount"),
        function (error) {
          if (error) {
            console.error(error);
            $("#Step6Error").show();
          } else {
            $("#Step6Error").hide();
          }
        }
      );
    } else {
      return contractInst.NguoiBanNhanHangTraLai.sendTransaction(
        makeTxnObj("#TxnAcc6"),
        function (error) {
          if (error) {
            console.error(error);
            $("#Step6Error").show();
          } else {
            $("#Step6Error").hide();
          }
        }
      );
    }
  }

  function sendStep7() {
    let param1 = $("#RootCause").val();
    console.log(param1);
    return contractInst.XacNhanThatBaiDoNguoiBan.sendTransaction(
      makeTxnObj("#TxnAcc7"),
      function (error) {
        if (error) {
          console.error(error);
          $("#Step7Error").show();
        } else {
          $("#Step7Error").hide();
        }
      }
    );
  }

  function sendClosingContract() {
    return contractInst.ThanhLyHopDong.sendTransaction(
      makeTxnObj("#TxnAcc7"),
      function (error) {
        if (error) {
          console.error(error);
          $("#Step0Error").show();
        } else {
          $("#Step0Error").hide();
        }
      }
    );
  }

  function sendUpdateContract() {
    let paramTienHang = $("#GTHD_TienHang").val();
    let paramTienVanChuyen = $("#GTHD_TienVanChuyen").val();
    let paramTaiKhoanNguoiBan = $("#GTHD_NguoiBan").val();
    return contractInst.XacLapHopDong.sendTransaction(
      paramTienHang,
      paramTienVanChuyen,
      paramTaiKhoanNguoiBan,
      makeTxnObj("#AccCreateContract"),
      function (error) {
        if (error) {
          console.error(error);
          $("#Step0Error").show();
        } else {
          $("#Step0Error").hide();
        }
      }
    );
  }

  $("#SetProvider").click(function () {
    setWeb3Provider($("#ProviderURL").val());
  });

  $("#SetContract").click(function () {
    contractAddr = $("#ContractAddress").val();
    if (contractAddr) {
      setContractAddress(contractAddr);
      watchContract();
    }
  });

  $("#Step1Button").click(function () {
    let _ = sendStep1();
    console.log(_);
  });

  $("#Step2Button").click(function () {
    let _ = sendStep2();
    console.log(_);
  });

  $("#Step3Button").click(function () {
    let _ = sendStep3();
    console.log(_);
  });

  $("#Step4Button").click(function () {
    let _ = sendStep4();
    console.log(_);
  });

  $("#Step5Button").click(function () {
    let _ = sendStep5();
    console.log(_);
  });

  $("#Step6Button").click(function () {
    let _ = sendStep6();
    console.log(_);
  });

  $("#Step7Button").click(function () {
    let _ = sendClosingContract();
    console.log(_);
  });

  $("#UpdateContractButton").click(function () {
    let _ = sendUpdateContract();
    console.log(_);
  });

  setInterval(updateContractStatus, 5000);
  // setWeb3Provider();

  $("body").on("click", "#testConnectAddress", function () {
    setWeb3Provider();
  });
});

// ******************
let listAddressConfirm = [
  "0x6976e231a2B80052A4d33875eFD386B980a486fC",
  "0xaB480650D670C20c244466249297c7EaeCa781fC",
  "0xB2245d7550566468e16100030886dDCbE2bb871C",
];

$("body").on("click", "#registerAccountCf", function () {
  let getAddress = $("#addressAccount").val();
  let count = 0;
  $(".list-group-item").each(function () {
    if ($(this).text().toLowerCase() === getAddress) {
      count++;
    }
  });
  if (count === 0) {
    let temp = `<li class="list-group-item">${getAddress}</li>`;
    $(".list-group").append(temp);
  } else {
    alert("Địa chỉ ví đã được đăng ký!");
  }
});

$("#flexCheckDefault").change(function () {
  if (this.checked) {
    $("#btnConfirm").prop("disabled", false);
  } else {
    $("#btnConfirm").prop("disabled", true);
  }
});

$("body").on("click", "#btnConfirm", function () {
  let addressCf = $("#showAddressConfirm").val();
  let count = 0;
  console.log($("#resultConfirm").val());
  if ($("#resultConfirm").val() == 0) {
    alert("Bạn chưa chọn kết quả cuối cùng!");
  } else if (!addressCf) {
    alert("Bạn chưa kết nối ví");
  } else {
    listAddressConfirm.forEach((item) => {
      console.log(item);
      if (item.toLowerCase() === addressCf) {
        count++;
      }
    });
    if (count !== 0) {
      alert("Bạn đã xác nhận kết quả thành công!");
    } else {
      alert("Địa chỉ ví này không được đăng ký xác nhận kết quả!");
    }
  }
});
