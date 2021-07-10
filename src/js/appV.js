App = {
  web3Provider: null,
  contracts: {},

  init: async function() {
    return await App.initWeb3();
  },

  initWeb3: async function() { // Khởi tạo đối tượng web3

    // Kiểm tra có đối tượng web3 nào được sử dụng không??? 
    // Modern dapp browsers... | hiện đại, tức là dApp hiện đại hoặc phiên bản Metamask mới nhất
    if (window.ethereum) {
      App.web3Provider = window.ethereum;
      try {
        // Request account access
        await window.eth_requestAccounts;
      } catch (error) {
        // User denied account access...
        console.error("User denied account access")
      }
    }
    // Legacy dapp browsers... | các dApp cũ hơn hoặc phiên bản Metamask cũ hơn
    else if (window.web3) {
      App.web3Provider = window.web3.currentProvider;
    }
    // If no injected web3 instance is detected, fall back to Ganache | 
    // nếu không có phiên bản web3 nào được chèn nào, sẽ tạo ra đối tượng web3 dựa trên máy cục bộ
    else {
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
    }
    web3 = new Web3(App.web3Provider);
    return App.initContract();
  },

  initContract: function() { // khởi tạo hợp đồng thông minh của mình để web3 biết tìm nó ở đâu và nó hoạt động như thế nào

    $.getJSON('DuBaoTuongLai.json', function(data) { // Adoption.json là file ABI được compile
      // Get the necessary contract artifact file and instantiate it with @truffle/contract
      var DuBaoTuongLaiArtifact = data;
      App.contracts.DuBaoTuongLai = TruffleContract(DuBaoTuongLaiArtifact);
    
      // Set the provider for our contract
      App.contracts.DuBaoTuongLai.setProvider(App.web3Provider);

      // Use our contract to retrieve and mark the adopted pets
      // return App.markEventSuccess(); // chức năng cập nhật giao diện người dùng bất kỳ lúc nào chúng tôi thực hiện thay đổi đối với dữ liệu của hợp đồng thông minh.
      App.render();
    });
    // return App.bindEvents();
  },

  render: function() {
    // console.log(App);
    web3.eth.getCoinbase(function(error, account) {
        if (error === null) {
            App.account = account;
            // console.log(account);
        }
    });
  },

  layThongTinPhien: function() {

    let maPhienDuBao = $('#maPhienDuBao').val();
        
    if(Form.validateMaPhienDuBao(maPhienDuBao) == false) {
      alert('Nhập sai Mã Phiên Dự Báo');
      return;
    }   
// test giao diện
        // $('#maPhienDuBao').val(maPhienDuBao);
        // $('#moTa').text("result.MoTa Đây là mô tả, Đây là mô tả, Đây là mô tả");
        // $('#thoiHanKetThucNopPhieu').text(Form.convertUnixTime(1626040800));
        // $('#thoiHanKetThuc').text(Form.convertUnixTime(1626029999));
        // $('#ketQuaCuoiCung').text('Italia');
        // $('#tyLe').text('Anh 1 : 4 Italia');
        // $('#trangThaiPhien').text("Hoàn thành");
// Gọi SC
    App.contracts.DuBaoTuongLai.deployed().then((instance) => {
        return instance.XemPhienDuBao.call(maPhienDuBao, { from: App.account });
    }).then((data) => {
        console.log(data)
        console.log("Thanh Cong " + result);
        // input id maPhienDuBao
        $('#maPhienDuBao').val(maPhienDuBao);
        // p     id moTa
        $('#moTa').text(result.MoTa);
        // p     id thoiHanKetThucNopPhieu
        $('#thoiHanKetThucNopPhieu').text(Form.convertUnixTime(result.ThoiHanKetThucNopPhieu));
        // p     id thoiHanKetThuc
        $('#thoiHanKetThuc').text(Form.convertUnixTime(result.ThoiHanKetThuc));
        //  uint16  KetQuaCuoiCung;
         $('#ketQuaCuoiCung').text(result.KetQuaCuoiCung);
        //  string  TyLeLuaChon;
         $('#tyLe').text(result.TyLeLuaChon);
        // p     id trangThaiPhien
        $('#trangThaiPhien').text(result.TrangThai);
    }).catch((error) => {
        console.log(error);
    });
  },

  quyetToanPhanThuong: function() {
    
    let maPhienDuBao = $('#maPhienDuBao').val();
        
    if(Form.validateMaPhienDuBao(maPhienDuBao) == false) {
      alert('Nhập sai Mã Phiên Dự Báo');
      return;
    }
// test
      // $('#maPhienDuBao').val(maPhienDuBao);
      // $('#moTa').text("result.MoTa Đây là mô tả, Đây là mô tả, Đây là mô tả");
      // $('#thoiHanKetThuc').text(Form.convertUnixTime(1626029999));
      // $('#ketQuaCuoiCung').text('Italia');
      // $('#trangThaiPhien').text("Hoàn thành");
      // $('#giaTriThuong').val(350);

// Gọi SC
    App.contracts.DuBaoTuongLai.deployed().then((instance) => {
        return instance.KetThucPhienDuBaoCuaToi(maPhienDuBao,0, { from: App.account });
    }).then((result) => {
        console.log("Thanh Cong. Tính thưởng :" + result);
            // input id maPhienDuBao
            $('#maPhienDuBao').val(maPhienDuBao);
            // p     id moTa
            $('#moTa').text(result.MoTa);
            // p     id thoiHanKetThuc
            $('#thoiHanKetThuc').text(Form.convertUnixTime(result.ThoiHanKetThuc));
            //  uint16  KetQuaCuoiCung;
             $('#ketQuaCuoiCung').text(result.KetQuaCuoiCung);
            // p     id trangThaiPhien
            $('#trangThaiPhien').text(result.TrangThai);
            // id giaTriThuong
             $('#giaTriThuong').val(result.GiaTriThuong);
    }).catch((error) => {
        console.log(error);
    });
  },

  // tinhThuong: function() {

  // },

  bindEvents: function() {
    $(document).on('click', '.btn-adopt', App.handleEvent);
    // $(document).on('click', '.btn-adopt', ()=>{
    //   App.handleAdopt();
    // });
    // $('.btn-adopt').click(function(){
    //   alert("The paragraph was clicked.");
    // })
  },

  markEventSuccess: function() { // chức năng cập nhật giao diện người dùng bất kỳ lúc nào chúng tôi thực hiện thay đổi đối với dữ liệu của hợp đồng thông minh.
    var DuBaoTuongLaiInstance;

    App.contracts.DuBaoTuongLai.deployed().then(function(instance) {
      DuBaoTuongLaiInstance = instance;
      // return DuBaoTuongLaiInstance.[getAdopters].call();
      // Sử dụng call () cho phép chúng tôi đọc dữ liệu từ blockchain mà không cần phải gửi một giao dịch đầy đủ, 
      // có nghĩa là chúng tôi sẽ không phải chi bất kỳ ether nào.
    }).then(function() {
      
    }).catch(function(err) {
      console.log(err.message);
    })
  },

  handleEvent: function(event) { // bắt sự kiện khi gửi Tx (phía trên là call() không mất gas, eth)
    event.preventDefault();

    var petId = parseInt($(event.target).data('id'));
    
    var adoptionInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log("Lỗi getAccounts" + error);
      }
    
      var account = accounts[0];
    
      App.contracts.Adoption.deployed().then(function(instance) {
        adoptionInstance = instance;
    
        // Execute adopt as a transaction by sending account
        return adoptionInstance.adopt(petId, {from: account});
      }).then(function(result) {
        return App.markEventSuccess();
      }).catch(function(err) {
        console.log("Lỗi gửi hàm " + err.message);
      });
    });
  }

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
