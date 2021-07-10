App = {
  web3Provider: null,
  contracts: {},

  init: async function () {
    return await App.initWeb3();
  },

  initWeb3: async function () {
    if (typeof web3 !== "underfined") {
      App.web3Provider = web3.currentProvider;
      web3 = new Web3(web3.currentProvider);
    } else {
      App.web3 = new Web3(
        new Web3.providers.HttpProvider("http://localhost:7545")
      );
    }
    return App.initContract();
  },

  initContract: function () {
    $.getJSON(
      "../build/contracts/PredictionContract.json",
      function (predictionContract) {
        App.contracts.PredictionContract = TruffleContract(predictionContract);
        console.log(App.contracts.PredictionContract);
        App.contracts.PredictionContract.setProvider(App.web3Provider);
        return App.render();
      }
    );
  },
  render: function () {
    web3.eth.getCoinbase(function (error, account) {
      if (error == null) {
        App.account = account;
        console.log(account);
        $("#addressAccount").val(account);
        $("#showAddressConfirm").val(account);
        // App.taoPhienDuBao();
        // App.dangKyXacNhan();
      }
    });
  },

  taoPhienDuBao: function() {
    App.contracts.PredictionContract.deployed().then((instance) => {
        return instance.TaoPhienDuBao.call('AnhvsY', 1626029999, 1626040800, [], { from: App.account });
    }).then((result) => {
        console.log(result);
        console.log(result.logs[0].args.intMaPhien);
    }).catch((error) => {
        console.log(error);
    });
  },

  dangKyXacNhan: function() {
    App.contracts.PredictionContract.deployed().then((instance) => {
        return instance.DangKyXacNhanKetQua('0xe1731c8c2d50', '0x6be7cefdfc775d887e18f5760131700596756c5d', { from: App.account });
    }).then((result) => {
        console.log(result);
    }).catch((error) => {
        console.log(error);
    });
  },

  xacNhanKetQua: function() {
    App.contracts.predictionContract.deployed().then((instance) => {
        return instance.XacNhanKetQua('0xe1731c8c2d50', 1, { from: App.account });
    }).then((result) => {
        console.log(result);
    }).catch((error) => {
        console.log(error);
    });
  }
};
$(function () {
  $(window).load(function () {
    App.init();
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

    console.log('Đăng ký thành công');
    App.dangKyXacNhan();
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
  if ($("#resultConfirm").val() == 0) {
    alert("Bạn chưa chọn kết quả cuối cùng!");
  } else if (!addressCf) {
    alert("Bạn chưa kết nối ví");
  } else {
    listAddressConfirm.forEach((item) => {
      if (item.toLowerCase() === addressCf) {
		  count++
      }
    });
	if(count!==0){
		console.log("Bạn đã xác nhận kết quả thành công!");

    App.xacNhanKetQua();
	}else{
		alert("Địa chỉ ví này không được đăng ký xác nhận kết quả!");
	}
  }
});


