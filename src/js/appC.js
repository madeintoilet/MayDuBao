App = {
  web3Provider: null,
  contracts: {},
  init: async function() {
    return await App.initWeb3();
  },

  initWeb3: async function() {
    if(typeof web3 !== 'underfined'){
      App.web3Provider = web3.currentProvider;
      web3 = new Web3(web3.currentProvider);
    }else{
      App.web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:7545"));
    }
    return App.initContract();
  },

  initContract: function() {

    $.getJSON("PredictionContract.json",function(predictionContract){
      App.contracts.PredictionContract = TruffleContract(predictionContract);
      App.contracts.PredictionContract.setProvider(App.web3Provider);
      App.render(); 
    })  
   
  },

  render: function(){
    web3.eth.getCoinbase(function(error, account){
      if(error == null){
        App.account = account;
        console.log(account);
      }
    })
  },
  TimMaPhien: function(){
    if(LayMaPhienDuBao == null ||  LayMaPhienDuBao.trim().length == 0){
      $('#errorMaPhien').css("display","block");
    }
  },
  LayDanhSachLuaChon: function(){
      App.contracts.PredictionContract.deployed().then(instance =>{
      var predictionInstance = instance;
      return predictionInstance.TongSoLuaChon().then(TongLuaChon=>{
        console.log(TongLuaChon);

        var DanhSachLuaChon = $("#txtDuBaoKetQua");
        DanhSachLuaChon.empty();
        for(let i = 1; i <= TongLuaChon.toNumber();i++ ){
        predictionInstance.DanhSachLuaChon(i).then(dslc =>{
          ketQuaTemplate ="<option value = "+i+">"+dslc[0]+"</option>";
          DanhSachLuaChon.append(ketQuaTemplate)
        })
        }
      })
    })
  },
  TaoPhieu: function (){
    var LayMaPhienDuBao = $('#txtMaPhien').val();
		var LayGiaTriKetQua = $('#txtDuBaoKetQua').val();
		var LayGiaTriDuBao = $('#txtGiaTriDuBao').val();
    if(LayMaPhienDuBao == null ||  LayMaPhienDuBao.trim().length == 0){
      $('#errorMaPhien').css("display","block");
    }else if ( LayGiaTriKetQua == null){
      $('#errorKetQua').css("display","block");
    }else if(LayGiaTriDuBao == null || LayGiaTriDuBao<10){
      $('#errorGiaTriDuBao').css("display","block");
    }else{
      $('#errorMaPhien').css("display","none");
      $('#errorKetQua').css("display","none");
      $('#errorGiaTriDuBao').css("display","none");
    App.contracts.PredictionContract.deployed().then(instance =>{
      var predictionInstance = instance;
      return predictionInstance.NopPhieuDuBao(LayMaPhienDuBao,LayGiaTriKetQua,LayGiaTriDuBao,{from: App.account}).then(a=>{
        console.log(a);
      })
    })}
  }

};
$('#btnTaoPhieu').on('click',function(){
  App.TaoPhieu();
})
$('#btnTimMaPhien').on('click',function(){
  App.LayDanhSachLuaChon();
})
$(function() {
  $(window).load(function() {
    App.init();
  });
});
