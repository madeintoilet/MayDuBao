    // input id maPhienDuBao
    // p     id moTa
    // p     id thoiHanKetThucNopPhieu
    // p     id thoiHanKetThuc
    // p     id trangThaiPhien
Form = {
    validateMaPhienDuBao : function(maPhienDuBao) {
        // alert('ttt');
        return true;
    },

    convertUnixTime : function(UNIX_timestamp) {
        var a = new Date(UNIX_timestamp * 1000);
        var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
        var year = a.getFullYear();
        var month = months[a.getMonth()];
        var date = a.getDate();
        var hour = a.getHours();
        var min = a.getMinutes();
        var sec = a.getSeconds();
        var time = date + ' ' + month + ' ' + year + ' ' + hour + ':' + min + ':' + sec ;
        return time;
      }
};

$(function() {
    $(window).load(function() {
      Form.init();
    });
});