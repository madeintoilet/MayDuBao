// SPDX-License-Identifier: MIT

pragma solidity >=0.4.0 <0.8.0;
// pragma experimental ABIEncoderV2;

import "./IERC20.sol";

contract DuBaoTuongLai {

    IERC20 public KhoTien;

    uint public TongSoPhienDuBao;
    uint16 public TongSoLuaChon;
    uint public TongSoLanDuBao;  // Tong so lan du bao cho tat ca cac phien
    uint public TongGiaTriDuBao; // Tong gia tri du bao cho tat ca cac phien
    
    address NguoiTao;

    enum enTrangThaiPhien { Moi, DangNhanPhieu, NgungNhanPhieu, DaXacNhanKetQua, KetThuc }
    
    struct PhienDuBao {
        bytes6  MaPhien;
        string  MoTa;
        uint32  TongSoPhieu;
        uint    TongGiaTri;
        uint    GiaTriConLai;
        
        uint    ThoiHanKetThucNopPhieu;
        uint    ThoiHanKetThuc;
        
        uint16  SoXacNhanKetQuaToiThieu;
        uint16  SoXacNhanKetQuaHienTai;
        uint16  KetQuaXacNhanLanCuoi;
        uint16  KetQuaCuoiCung;
        
        string  TyLeLuaChon;
        uint16[] LuaChon;
        enTrangThaiPhien TrangThai;        
    }

    enum enTrangThaiPhieuDuBao { HieuLuc, HetHieuLuc }
    
    struct PhieuDuBao {
        bytes6 MaPhienDuBao;
        uint16 KetQuaDuBao;
        uint GiaTriDuBao; // tinh bang XU = 1 ETH
        uint ThoiGian;
        enTrangThaiPhieuDuBao TrangThai; 
    }
    
    mapping(bytes6 => PhienDuBao) private DanhSachPhien; 
    mapping(bytes6 => mapping(uint => PhieuDuBao)) private DanhSachPhieuDuBao; 

    struct TongHopKetQua {
        uint TongGiaTri; 
        uint TongSoPhieu;
    }

    mapping(bytes6 => mapping(uint => TongHopKetQua)) TongHopKetQuaPhien;   // MaPhien -> TongHop(MaLuaChon -> TongHopKetQua)

    enum enTrangThaiLuaChon {HieuLuc, HetHieuLuc}
    struct LuaChon {
        // uint16 MaLuaChon;
        string MoTa;
        enTrangThaiLuaChon TrangThai;
    }

    mapping(uint16 => LuaChon) public DanhSachLuaChon; // MaLuaChon => Mo Ta lua chon & trang thai
    
    struct NguoiThamGia {
        string HoTen;
        string DienThoai;
        uint16[] DanhSachPhieu;
        bool   DaQuyetToanXong;
    }

    mapping(bytes6 => mapping(address => NguoiThamGia)) DanhSachThamGia; // MaPhien -> Danh sach nguoi:Thoi Gian tham gia

    enum enTrangThaiHoatDong { DangHoatDong, TamDung, NgungHoatDong }
    enTrangThaiHoatDong public TrangThaiHoatDong;    

    uint16                  SoNguoiXacNhanKetQua;
    address[]               TaiKhoanXacNhanKetQua; 

    event evTaoPhienDuBaoRoi(bytes6 intMaPhien);
    event evDangKyLuaChonRoi(uint intMaLuaChon);
    event evCapNhatLuaChonRoi(uint intMaLuaChon);
    event evCapNhatLuaChonVaoPhienRoi();
    event evDaDangKyThamGiaThanhCong();
    event evCapNhatTrangThaiPhienRoi();
    event NopPhieuDuBaoThanhCongRoi(uint16 intMaPhieu);
    event DangKyNguoiXacNhanKetQuaThanhCong(address adNguoiXacNhan);
    event XacNhanKetQuaThanhCong(bytes6 MaPhien, uint ThoiGian);
    event DaChotKetQuaCuoiCung(uint ThoiGian);
    event DaQuyetToanXongRoi(address adNguoiThamGia, uint GiaTriQuyetToan);

    constructor(address adDiaChiKhoTien) {
        TongSoPhienDuBao = 0;
        TongSoLuaChon = 0;
        TongSoLanDuBao = 0;
        TongGiaTriDuBao = 0;
        TrangThaiHoatDong = enTrangThaiHoatDong.DangHoatDong;
        NguoiTao = msg.sender;
        KhoTien = IERC20(adDiaChiKhoTien);
    }

    modifier KiemTraNguoiTaoGoiHam(){
        require(msg.sender == NguoiTao,'Ban khong co quyen truy cap');
        _;
    }

    event DoiKhoTienThanhCong(address adDiaChiKhoTien, bool ThanhCong);

    function ChuyenKhoTien(address adDiaChiKhoTien) public returns (bool bThanhCong) {
        // Chi nguoi tao contract moi co quyen thuc hien thao tac nay
        require(msg.sender == NguoiTao, "Ban khong co quyen thay doi dia chi Kho tien");

        KhoTien = IERC20(adDiaChiKhoTien);
        bThanhCong = true;

        emit DoiKhoTienThanhCong(adDiaChiKhoTien, bThanhCong);

        return bThanhCong;
    }
    
    // Goi ham nay de tao phien du bao cho moi tran dau
    function TaoPhienDuBao(string memory strMoTaPhien,uint dtThoiHanKetThucNopPhieu, uint dtThoiHanKetThucPhien, uint16[] memory arrLuaChon) public KiemTraNguoiTaoGoiHam returns (bytes6 intMaPhienDuBao)  {
        //Kiem tra co phai nguoi tao hay khong? 
            //Su dung modifier

        //Kiem tra MoTaPhien co rong hay khong
        require(bytes(strMoTaPhien).length > 0, "Mo ta phien du bao khong duoc phep de trong");
            
        //Kiem tra xem ThoiHanKetThucNopPhieu > ThoiHanKetThuc 
        require(dtThoiHanKetThucPhien > dtThoiHanKetThucNopPhieu);
        
        // Tang tong so phien va cap ma cho phien du bao
        TongSoPhienDuBao += 1;
        intMaPhienDuBao = bytes6(keccak256(abi.encodePacked(block.timestamp + TongSoPhienDuBao)));
        
        // Cho vao mapping danh sach phien du bao
        DanhSachPhien[intMaPhienDuBao] = PhienDuBao({   MaPhien: intMaPhienDuBao,
                                                        MoTa: strMoTaPhien,
                                                        TongSoPhieu: 0,
                                                        TongGiaTri: 0,
                                                        GiaTriConLai: 0,
                                                        ThoiHanKetThucNopPhieu: dtThoiHanKetThucNopPhieu,
                                                        ThoiHanKetThuc: dtThoiHanKetThucPhien,
                                                        SoXacNhanKetQuaToiThieu: 2,
                                                        SoXacNhanKetQuaHienTai: 0,
                                                        KetQuaXacNhanLanCuoi: 0,
                                                        KetQuaCuoiCung: 0,
                                                        TyLeLuaChon: "",
                                                        LuaChon: arrLuaChon,
                                                        TrangThai: arrLuaChon.length > 1 ? enTrangThaiPhien.DangNhanPhieu : enTrangThaiPhien.Moi});
        
        emit evTaoPhienDuBaoRoi(intMaPhienDuBao);
        return intMaPhienDuBao;
    }

    // Gọi hàm này để load ra phiên dự báo
    function XemPhienDuBao(bytes6 intMaPhienDuBao) public view 
                                            returns (
                                                string memory strMoTaPhien, 
                                                uint dtThoiHanKetThucNopPhieu,
                                                uint dtThoiHanKetThucPhien,
                                                uint16 intKetQuaCuoiCung,
                                                string memory strTyLe,
                                                uint16[] memory arrLuaChon,
                                                enTrangThaiPhien intTrangThai
                                            ) {
        // Kiem tra ma phien du bao nhap vao co ton tai trong danh sach hay khong
        require(DanhSachPhien[intMaPhienDuBao].MaPhien == intMaPhienDuBao, "Phien du bao khong ton tai");

        PhienDuBao memory objPhienDuBao = DanhSachPhien[intMaPhienDuBao];

        return (
            objPhienDuBao.MoTa, 
            objPhienDuBao.ThoiHanKetThucNopPhieu,
            objPhienDuBao.ThoiHanKetThuc,
            objPhienDuBao.KetQuaCuoiCung,
            objPhienDuBao.TyLeLuaChon,
            objPhienDuBao.LuaChon,
            objPhienDuBao.TrangThai
        );
    }
    
    // Goi ham nay de dang ky danh sach cac doi bong
    function DangKyLuaChon(uint16 intMaLuaChonCapNhat,string memory strMoTaLuaChon, uint8 intTrangThaiLuaChonCapNhat) public KiemTraNguoiTaoGoiHam returns (uint16 intMaLuaChon) {
        //Kiem tra co phai nguoi tao hay khong? 
            //Su dung modifier

        //Kiem tra strMoTaLuaChon k duoc rong
        require(bytes(strMoTaLuaChon).length > 0,'Khong duoc bo trong mo ta');
        
        if(intMaLuaChonCapNhat == 0){
            //Tao Lua Chon moi
            TongSoLuaChon += 1;
            intMaLuaChon = TongSoLuaChon;
            
            //Them LuaChon vao DanhSachLuaChon
            DanhSachLuaChon[intMaLuaChon] = LuaChon({   MoTa: strMoTaLuaChon,
                                                        TrangThai: enTrangThaiLuaChon.HieuLuc});
                                                        
            emit evDangKyLuaChonRoi(intMaLuaChon);
        } else {
            //Cap nhat Lua chon cu~ da co san
            //Kiem tra xem MaLuaChonCapNhat co ton tai hay khong?
            require(bytes(DanhSachLuaChon[intMaLuaChonCapNhat].MoTa).length > 0);
            
            //Kiem tra trang thai co ton tai trong enTrangThaiLuaChon hay khong?
            require(intTrangThaiLuaChonCapNhat <= uint8(enTrangThaiLuaChon.HetHieuLuc));
            
            //Cap nhat thong tin LuaChon
            intMaLuaChon = intMaLuaChonCapNhat;
            DanhSachLuaChon[intMaLuaChon] = LuaChon({   MoTa: strMoTaLuaChon,
                                                        TrangThai: enTrangThaiLuaChon(intTrangThaiLuaChonCapNhat)});
                                                        
            emit evCapNhatLuaChonRoi(intMaLuaChon);
        }
        return intMaLuaChon;
    }
    
    // Goi ham nay de gan cac doi tuong ung tu danh sach lua chon vao phien du bao gan voi mot tran dau
    function CapNhatLuaChonVaoPhienDuBao(bytes6 intMaPhienDuBao,uint16[] memory ciDanhSachLuaChon) public KiemTraNguoiTaoGoiHam
    {
        //Kiem tra co phai nguoi tao hay khong? 
            //Su dung modifier
        
        //Kiem tra xem ma phien co hop le hay khong
        PhienDuBao storage objPhien = DanhSachPhien[intMaPhienDuBao];
        require(objPhien.MaPhien == intMaPhienDuBao,'Ma phien khong hop le');
        
        //Kiem tra trang thai phien du bao
        require(objPhien.TrangThai == enTrangThaiPhien.Moi);
        
        // Bo sung ma lua chon vao danh sach lua chon cua phien
        objPhien.LuaChon = ciDanhSachLuaChon;
        
        //emit thong bao
        emit evCapNhatLuaChonVaoPhienRoi();
    }
    
    // Dang ky tham gia du bao, moi nguoi duoc dang ky tham gia 1 lan duy nhat vao mot phien du bao 
    function DangKyThamGiaDuBao(bytes6 intMaPhienDuBao, string memory strHoTen, string memory strDienThoai) public 
    {
        //Kiem tra xem ma phien co hop le hay khong
        require(DanhSachPhien[intMaPhienDuBao].MaPhien == intMaPhienDuBao,'Ma phien khong hop le'); 
        
        // Kiem tra xem tai khoan msg.sender co trong danh sach tham gia chua
        NguoiThamGia memory objNguoiThamGia = DanhSachThamGia[intMaPhienDuBao][msg.sender];
        require(bytes(objNguoiThamGia.HoTen).length == 0); 
        
        // Neu chua co tai khoan nay thi bo sung vao danh sach tham gia va AIR DROP KhoTien 
        DanhSachThamGia[intMaPhienDuBao][msg.sender] = NguoiThamGia({ HoTen: strHoTen,
                                                                      DienThoai: strDienThoai,
                                                                      DanhSachPhieu: new uint16[](0),
                                                                      DaQuyetToanXong: false 
                                                                    });
        //Air drop KhoTien
        // Chuyen 0.01 ETH de chay contract nay
        
        // Chuyen 150 NGIN ban dau de tao cac phieu du bao
        emit evDaDangKyThamGiaThanhCong();
    }

    function CapNhatTrangThaiPhienDuBao(bytes6 intMaPhienDuBao, uint8 intTrangThaiPhien) public KiemTraNguoiTaoGoiHam {
        //Kiem tra co phai nguoi tao hay khong? 
            //Su dung modifier
            
        //Kiem tra trang thai co ton tai trong enTrangThaiPhien hay khong?
        require(intTrangThaiPhien <= uint8(enTrangThaiPhien.KetThuc));
        
        //Kiem tra xem ma phien co hop le hay khong
        PhienDuBao storage objPhien = DanhSachPhien[intMaPhienDuBao];
        require(objPhien.MaPhien == intMaPhienDuBao,'Ma phien khong hop le');
        
        //Thay doi trang thai cho phien du bao
        objPhien.TrangThai = enTrangThaiPhien(intTrangThaiPhien);
        
        emit evCapNhatTrangThaiPhienRoi();
    }
    
    // Gọi hàm này để nộp phiếu dự báo vào 1 phiên dự báo nào đó 
    function NopPhieuDuBao(bytes6 intMaPhienDuBao, uint16 intKetQuaDuBao, uint intGiaTriDuBao) public {
        
        // Tạo đối tượng phiếu dự báo
        
        PhieuDuBao memory objPhieuDuBao = PhieuDuBao({
             MaPhienDuBao: intMaPhienDuBao,
             KetQuaDuBao: intKetQuaDuBao,
             GiaTriDuBao: intGiaTriDuBao, // tinh bang XU = 1 ETH
             ThoiGian: block.timestamp,
             TrangThai: enTrangThaiPhieuDuBao.HieuLuc
        });
        // Kiểm tra số xu có đủ số tiền để tham gia không, số dư >=10
        require(objPhieuDuBao.GiaTriDuBao >= 10 && KhoTien.balanceOf(msg.sender) >= objPhieuDuBao.GiaTriDuBao * (1 ether));
        
        // Kiểm tra số ủy nhiệm chi >= số tham gia
        // uint GiaTriUyNhiem = KhoTien.allowance(msg.sender, address(this));
        // uint GiaTriUyNhiem = KhoTien.approve(address(this), intGiaTriDuBao * (1 ether));
        
        // require(GiaTriUyNhiem >= objPhieuDuBao.GiaTriDuBao);
        
        KhoTien.transferFrom(msg.sender, address(this), intGiaTriDuBao * (1 ether));

        require(objPhieuDuBao.MaPhienDuBao > 0 );
        // Kiểm tra mã phiên và trạng thái của phiên dự báo
        PhienDuBao storage objPhienDuBao = DanhSachPhien[objPhieuDuBao.MaPhienDuBao];

        // Kiểm tra xem phiên có tồn tại hay không
        require(objPhienDuBao.MaPhien == objPhieuDuBao.MaPhienDuBao);

        // Kiểm tra trạng thái phiên dự báo
        require(objPhienDuBao.TrangThai == enTrangThaiPhien.DangNhanPhieu || objPhienDuBao.TrangThai == enTrangThaiPhien.Moi);
        
        if(objPhienDuBao.TrangThai == enTrangThaiPhien.Moi) objPhienDuBao.TrangThai = enTrangThaiPhien.DangNhanPhieu;

        // Kiểm tra thời hạn nộp phiếu của phiên dự báo
        require(objPhieuDuBao.ThoiGian <= objPhienDuBao.ThoiHanKetThucNopPhieu);  

        // Kiểm tra sự lựa chọn trong phiếu dự báo có trong phiên hay không
        bool KiemTraLuaChon = false;
        for(uint i = 0; i<=objPhienDuBao.LuaChon.length;i++){
            if(objPhienDuBao.LuaChon[i] == objPhieuDuBao.KetQuaDuBao){
                KiemTraLuaChon = true;
                break;
            }
        }
        // Convert mảng lựa chọn thành bytes và kiểm tra có trong chuỗi đấy không

        // PASS QUA CAC DIEU KIEN => XU LY PHIEU
        if(KiemTraLuaChon == true){
        // Cong tong so phieu cua phien du bao
            // Lay doi tuong phien du bao tu DanhSachPhien 
            // Cap nhat TongSoPhieu tang len 1 phieu
            objPhienDuBao.TongSoPhieu += 1;
            objPhienDuBao.TongGiaTri += objPhieuDuBao.GiaTriDuBao;
        // Cho phieu vao DanhSachPhieuDuBao 
             // Lay mapping danh sach phieu tuong ung voi phien du bao hien tai
             // Sinh MaPhieu = MaPhien << 24 + TongSoPhieu trong phien de lam KEY
             // Sử dụng OR dịch trái mã phiên
            uint16 intMaPhieu = uint16(bytes2(objPhienDuBao.MaPhien<<12 + objPhienDuBao.TongSoPhieu));
             // PUSH phieu du bao vao mapping danh sach phieu thuoc mot PHIEN DU BAO
            DanhSachPhieuDuBao[bytes6(objPhienDuBao.MaPhien)][intMaPhieu] = objPhieuDuBao;

        // Cap nhat nguoi gui phieu vao DanhSachThamGia
            // Cap nhat BO SUNG ma phieu vao danh sach phieu cua nguoi tham gia 
            DanhSachThamGia[objPhienDuBao.MaPhien][msg.sender].DanhSachPhieu.push(intMaPhieu);
        
        //  mapping(bytes6 => mapping(uint => TongHopKetQua)) TongHopKetQuaPhien;   // MaPhien -> TongHop(MaLuaChon -> TongHopKetQua)
        // Tong hop ket qua du bao
             // Lay doi tuong tong  hop theo MaPhien  => mapping
             // Lay doi tuong tong hop theo MaLuaChon => struct
             // Cap nhat TongGiaTri tang them so XU trong phieu
             // Cap nhat TongSoPhieu tang them 1
            TongHopKetQuaPhien[objPhienDuBao.MaPhien][objPhieuDuBao.KetQuaDuBao].TongGiaTri+= objPhieuDuBao.GiaTriDuBao;
            TongHopKetQuaPhien[objPhienDuBao.MaPhien][objPhieuDuBao.KetQuaDuBao].TongSoPhieu+= 1;
  
        
        // Tang tong so lan du bao cua toan bo SMART CONTRACT len 1  

            TongSoLanDuBao+=1;
        // Tang tong gia tri XU vao SMART CONTRACT len +=GiaTriDuBao nam trong phieu

            TongGiaTriDuBao+=objPhieuDuBao.GiaTriDuBao;
        // Bao su kien NOP PHIEU THANH CONG

        // Code thêm cập nhật tỷ lệ

            emit NopPhieuDuBaoThanhCongRoi(intMaPhieu);
        }
    }
    
    // Goi ham nay de dang ky tai khoan xac nhan ket qua THUC TE
    function DangKyXacNhanKetQua(bytes6 intMaPhienDuBao, address adNguoiXacNhan) public {
        // Kiem tra chi cho phep nguoi tao CONTRACT moi duoc phep goi ham nay
        require(msg.sender == NguoiTao, "Chi co Admin moi duoc phep thuc hien thao tac nay");

        // Kiem tra dam bao nguoi tham gia khong the XAC NHAN KET QUA 
        // mapping(uint => mapping(address => NguoiThamGia)) DanhSachThamGia; // MaPhien -> Danh sach nguoi:Thoi Gian tham gia
        NguoiThamGia memory _nguoithamgia = DanhSachThamGia[intMaPhienDuBao][adNguoiXacNhan];
        require((bytes(_nguoithamgia.HoTen).length == 0 && bytes(_nguoithamgia.DienThoai).length == 0), "Nguoi tham gia khong co quyen xac nhan ket qua du bao");
        
        // Kiem tra nguoi xac nhan da co trong danh sach chua 
        for(uint i = 0; i < TaiKhoanXacNhanKetQua.length; i++) {
            if(TaiKhoanXacNhanKetQua[i] == adNguoiXacNhan) {
                revert("Nguoi xac nhan ket qua da co trong danh sach");
            }
        }
        
        // Tang SoNguoiXacNhanKetQua len 1
        SoNguoiXacNhanKetQua += 1;
        
        // Cap nhat nguoi xac nhan vao danh sach TaiKhoanXacNhanKetQua  
        //TaiKhoanXacNhanKetQua[SoNguoiXacNhanKetQua - 1] = adNguoiXacNhan;
        TaiKhoanXacNhanKetQua.push(adNguoiXacNhan);

        // Phat event thong bao dang ky xac nhan ket qua thanh cong
        emit DangKyNguoiXacNhanKetQuaThanhCong(adNguoiXacNhan);
    }
    
    // Tai khoan nam trong danh sach xac nhan ket qua se goi ham nay de XAC NHAN KET QUA
    function XacNhanKetQua(bytes6 intMaPhienDuBao, uint16 intMaLuaChonLaKetQuaCuoi) public
    {
        // Kiem tra tai khoan msg.sender nam trong danh sach nguoi xac nhan ket qua 
        bool bTonTaiNguoiXacNhan = false;
        for(uint i = 0; i < TaiKhoanXacNhanKetQua.length; i++) {
            if(TaiKhoanXacNhanKetQua[i] == msg.sender) {
                bTonTaiNguoiXacNhan = true;
                break;
            }
        }
        require(bTonTaiNguoiXacNhan, "Tai khoan nay khong hop le de xac nhan ket qua du bao");

        // Kiem tra dam bao intMaLuaChonLaKetQuaCuoi nam trong danh sach lua chon hop le 
        require(bytes(DanhSachLuaChon[intMaLuaChonLaKetQuaCuoi].MoTa).length > 0, "Lua chon nay khong nam trong danh sach lua chon hop le");

        PhienDuBao storage objPhienDuBao = DanhSachPhien[intMaPhienDuBao];
        
        require(objPhienDuBao.MaPhien > 0, "Phien du bao khong hop le");

        bool bTonTaiLuaChonTrongDanhSachCuaPhien = false;
        for(uint i = 0; i < objPhienDuBao.LuaChon.length; i++) {
            if(objPhienDuBao.LuaChon[i] == intMaLuaChonLaKetQuaCuoi) {
                bTonTaiLuaChonTrongDanhSachCuaPhien = true;
                break;
            }
        }
        
        require(bTonTaiLuaChonTrongDanhSachCuaPhien == true);
        
        //Kiem tra SoXacNhanKetQuaHienTai cua Phien du bao, neu chua co ai xac nhan thi tang len 1
        if(objPhienDuBao.SoXacNhanKetQuaHienTai == 0) {
            objPhienDuBao.SoXacNhanKetQuaHienTai += 1;
            
            // Gan intMaLuaChonLaKetQuaCuoi vao truong KetQuaXacNhanLanCuoi cua Phien
            objPhienDuBao.KetQuaXacNhanLanCuoi = intMaLuaChonLaKetQuaCuoi;
        }
        else {
            // Nếu SoXacNhanKetQuaHienTai của Phiên lớn hơn 0, tức là đã có người xác nhận kết quả
            // Kiểm tra KetQuaXacNhanLanCuoi có khớp với intMaLuaChonKetQuaCuoi hay không
            if(objPhienDuBao.KetQuaXacNhanLanCuoi == intMaLuaChonLaKetQuaCuoi) {
                // Cập nhật SoXacNhanKetQuaHienTai của Phiên tăng lên 1
                objPhienDuBao.SoXacNhanKetQuaHienTai += 1;
            } 
            else {
                // Nếu KetQuaXacNhanLanCuoi của Phiên khác với intMaLuaChonLaKetQuaCuoi 
                // thì phải reset SoXacNhanKetQuaHienTai của Phiên về 1
                objPhienDuBao.SoXacNhanKetQuaHienTai = 1;
                
                // Gán lại KetQuaXacNhanLanCuoi của Phiên với intMaLuaChonLaKetQuaCuoi
                objPhienDuBao.KetQuaXacNhanLanCuoi = intMaLuaChonLaKetQuaCuoi;
            }
        }
        
        // Phát event Xác nhận kết quả thành công
        emit XacNhanKetQuaThanhCong(objPhienDuBao.MaPhien, block.timestamp);
        
        // Kiem tra neu SO XAC NHAN >= SoXacNhanKetQuaToiThieu -> cap nhat KetQuaCuoiCung cho phien du bao 
        if(objPhienDuBao.SoXacNhanKetQuaHienTai >= objPhienDuBao.SoXacNhanKetQuaToiThieu) {
            objPhienDuBao.KetQuaCuoiCung = intMaLuaChonLaKetQuaCuoi;
            
            // Cập nhật trạng thái của Phiên thành Đã xác nhận kết quả
            objPhienDuBao.TrangThai = enTrangThaiPhien.DaXacNhanKetQua;
            
            // Phát event Đã chốt kết quả cuối cùng
            emit DaChotKetQuaCuoiCung(block.timestamp);
        }
    }
    
    // Goi ham nay khi da co ket qua chinh thuc de linh thuong
    function KetThucPhienDuBaoCuaToi(bytes6 intMaPhienDuBao,address adTaiKhoanQuyetToan) public
    {
        // Neu adTaiKhoanQuyetToan==address(0) -> quyet toan cho msg.sender
        // require( adTaiKhoanQuyetToan == address(0)); // case 1: trường hợp người chia tiền, chia cho tắt cả phiếu thắng dự báo
        if(adTaiKhoanQuyetToan == address(0)) {
            adTaiKhoanQuyetToan = msg.sender;
        }
        
        // Lay doi tuong PhienDuBao tu DanhSachPhien
        PhienDuBao storage objPhienDuBao = DanhSachPhien[intMaPhienDuBao];
        
        // Kiem tra thoi gian > ThoiHanKetThuc 
        require(block.timestamp > objPhienDuBao.ThoiHanKetThuc);
        
        // Kiem tra SoXacNhanKetQuaHienTai >= SoXacNhanKetQuaToiThieu va KetQuaCuoiCung da cap nhat
        require(objPhienDuBao.TrangThai == enTrangThaiPhien.DaXacNhanKetQua);
        
        // Tinh tong GIA TRI CO THE CHIA (cong het TongHopKetQua cua cac LuaChon sai lai)
        // Tong gia tri BEN THANG CUOC = Gia tri tuong ung voi KetQuaCuoiCung
  
        uint TongGiaTriThang;
        uint GiaTriCoTheChia; // TongGiaTriThua
        
        for (uint8 i=0;i < objPhienDuBao.LuaChon.length; i++) {  // mảng LuaChon truy vấn tuyến tính được
            TongHopKetQua storage objTongHopKetQua = TongHopKetQuaPhien[intMaPhienDuBao][objPhienDuBao.LuaChon[i]];
            
            if(objPhienDuBao.KetQuaCuoiCung == objPhienDuBao.LuaChon[i]) {
                TongGiaTriThang += objTongHopKetQua.TongGiaTri;
            } else {
                GiaTriCoTheChia += objTongHopKetQua.TongGiaTri;
            }
        }
         
        // Lay tat ca cac PHIEU ma tai khoan gui den msg.sender da gui vao contract
        NguoiThamGia storage objNguoiThamGia = DanhSachThamGia[intMaPhienDuBao][msg.sender];

        uint GiaTriDoanDung; // số tiền đoán đúng
        // uint TongTienTraLai; // số tiền đoán đúng
        
        for(uint8 i=0; i < objNguoiThamGia.DanhSachPhieu.length; i++) {
            PhieuDuBao storage objPhieuDuBao = DanhSachPhieuDuBao[intMaPhienDuBao][i];
            
            if(objPhieuDuBao.GiaTriDuBao != 0) { // Nếu phieuDuBao Tồn tại thì
                // Neu day la phieu DU DOAN DUNG 
                if(objPhieuDuBao.KetQuaDuBao == objPhienDuBao.KetQuaCuoiCung) {
                    // Cong gia tri phieu vao phan GIA TRI DOAN DUNG
                    GiaTriDoanDung += objPhieuDuBao.GiaTriDuBao;
                    // Cong gia tri phieu va TONG TIEN TRA LAI = GiaTriDoanDung
                }
            }
        }
          
        
        // TONG TIEN TRA THUONG = GIA TRI CO THE CHIA * TY LE CHIA 
        uint TongTienTraThuong = MulDiv(GiaTriCoTheChia,GiaTriDoanDung,TongGiaTriThang);
        
        // Tinh GiaTriQuyetToan = TONG TIEN TRA THUONG + TONG TIEN TRA LAI
        uint GiaTriQuyetToan = GiaTriDoanDung + TongTienTraThuong ; // TongTienTraLai = GiaTriDoanDung
        
        // Neu  GiaTriQuyetToan >= GiaTriConLai trong PhienDuBao thi chuyen het gia tri con lai 
        if(GiaTriQuyetToan >= objPhienDuBao.GiaTriConLai) {
            KhoTien.transfer(msg.sender, objPhienDuBao.GiaTriConLai * (1 ether));
            
            // Cap nhat trang thai da quyet toan Xong cho tai khoan nguoi tham gia
            objNguoiThamGia.DaQuyetToanXong = true;
            
            // Cap nhat gia tri con lai tru bot gia tri da quyet toan 
            objPhienDuBao.GiaTriConLai = 0;
            
            // Cap nhat trang thai cho PhienDuBao neu GiaTriConLai = 0 
            objPhienDuBao.TrangThai = enTrangThaiPhien.KetThuc;
        } else {
            // Chuyen khoan token tra thuong cho tai khoan REDEEM = GiaTriQuyetToan
            KhoTien.transfer(msg.sender, GiaTriQuyetToan * (1 ether));
            
            // Cap nhat trang thai cho GiaTriConLai
            objPhienDuBao.GiaTriConLai -= GiaTriQuyetToan;
        }
        emit DaQuyetToanXongRoi(msg.sender,GiaTriQuyetToan);
    }
    
    function Mul (uint x, uint y) private pure returns (uint l, uint h)
    {
      uint mm = mulmod (x, y, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
      l = x * y;
      h = mm - l;
      if (mm < l) h -= 1;
    }

    function MulDiv (uint x, uint y, uint z) private pure returns (uint) {
        (uint l, uint h) = Mul(x, y);
        require (h < z);
        uint mm = mulmod (x, y, z);
          if (mm > l) h -= 1;
          l -= mm;
        uint pow2 = z & -z;
          z /= pow2;
          l /= pow2;
          l += h * ((-pow2) / pow2 + 1);
        uint r = 1;
          r *= 2 - z * r;
          r *= 2 - z * r;
          r *= 2 - z * r;
          r *= 2 - z * r;
          r *= 2 - z * r;
          r *= 2 - z * r;
          r *= 2 - z * r;
          r *= 2 - z * r;
        return l * r;
    }
}