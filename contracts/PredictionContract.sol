
pragma solidity >=0.4.0; 

/// Day la branch Nhom3_Backend

contract DuBaoTuongLai
{
    uint public TongSoPhienDuBao;
    uint public TongSoLanDuBao;  // Tong so lan du bao cho tat ca cac phien
    uint public TongGiaTriDuBao; // Tong gia tri du bao cho tat ca cac phien
    
    address payable NguoiTao;

    enum enTrangThaiPhien { Moi, DangNhanPhieu, NgungNhanPhieu, KetThuc }
    struct PhienDuBao {
        uint    MaPhien;
        string  MoTa;
        uint32  TongSoPhieu;
        uint    TongGiaTri;
        uint    GiaTriConLai;
        
        uint    ThoiHanKetThucNopPhieu;
        uint    ThoiHanKetThuc;
        
        uint16  SoXacNhanKetQuaToiThieu;
        uint16  SoXacNhanKetQuaHienTai;
        uint16  KetQuaCuoiCung;
        
        string  TyLeLuaChon;
        uint16[] LuaChon;
        enTrangThaiPhien TrangThai;        
    }

    enum enTrangThaiPhieuDuBao { HieuLuc, HetHieuLuc }
    struct PhieuDuBao {
        uint MaPhienDuBao;
        uint KetQuaDuBao;
        uint GiaTriDuBao; // tinh bang XU = 1 ETH
        uint ThoiGian;
        enTrangThaiPhieuDuBao TrangThai; 
    }
    
    mapping(uint => PhienDuBao) private DanhSachPhien; 
    mapping(bytes6 => mapping(uint => PhieuDuBao)) private DanhSachPhieuDuBao; 

    struct TongHopKetQua {
        uint TongGiaTri;
        uint TongSoPhieu;
    }

    mapping(uint => mapping(uint => TongHopKetQua)) TongHopKetQuaPhien;   // MaPhien -> TongHop(MaLuaChon -> TongHopKetQua)

    enum enTrangThaiLuaChon {DangSuDung, HuyBo}
    struct LuaChon {
        // uint16 MaLuaChon;
        string MoTa;
        enTrangThaiLuaChon TrangThai;
    }

    mapping(uint => LuaChon) public DanhSachLuaChon; // MaLuaChon => Mo Ta lua chon & trang thai
    
    struct NguoiThamGia
    {
        string HoTen;
        string DienThoai;
        uint16[] DanhSachPhieu;
        bool   DaQuyetToanXong;
    }

    mapping(uint => mapping(address => NguoiThamGia)) DanhSachThamGia; // MaPhien -> Danh sach nguoi:Thoi Gian tham gia

    enum enTrangThaiHoatDong { DangHoatDong, TamDung, NgungHoatDong }
    enTrangThaiHoatDong public TrangThaiHoatDong;    

    uint16                  SoNguoiXacNhanKetQua;
    address[]               TaiKhoanXacNhanKetQua; 

    constructor() {
        TongSoPhienDuBao = 0;
        TongSoLanDuBao = 0;
        TongGiaTriDuBao = 0;
        TrangThaiHoatDong = enTrangThaiHoatDong.DangHoatDong;
        NguoiTao = msg.sender;
    }
    
    // Goi ham nay de tao phien du bao cho moi tran dau
    function TaoPhienDuBao(string memory strMoTaPhien,uint dtThoiHanKetThucNopPhieu, uint dtThoiHanKetThucPhien) public returns (uint MaPhienDuBao)    {
        // Tang tong so phien va cap ma cho phien du bao
        TongSoPhienDuBao += 1;
        bytes6 MaPhienDuBao = bytes6(keccak256(block.timestamp + TongSoPhienDuBao));
        
        // Tao doi tuong phien du bao
        
        // Cho vao mapping danh sach phien du bao
        
    }
    
    // Goi ham nay de dang ky danh sach cac doi bong
    function DangKyLuaChon(string strMoTaLuaChon) returns (uint16 MaLuaChon) {
        // Bo sung lua chon vao danh sach va tra ve ma lua chon moi
    }
    
    // Goi ham nay de gan cac doi tuong ung tu danh sach lua chon vao phien du bao gan voi mot tran dau
    function CapNhatLuaChonVaoPhienDuBao(uint MaPhienDuBao,uint16[] ciDanhSachLuaChon)
    {
        // Bo sung ma lua chon vao danh sach lua chon cua phien
    }
    
    // Dang ky tham gia du bao, moi nguoi duoc dang ky tham gia 1 lan duy nhat vao mot phien du bao 
    function DangKyThamGiaDuBao(bytes6 intMaPhienDuBao) public 
    {
        // Kiem tra xem tai khoan msg.sender co trong danh sach tham gia chua
        
        // Neu chua co tai khoan nay thi bo sung vao danh sach tham gia va AIR DROP token 
        // Chuyen 0.01 ETH de chay contract nay
        
        // Chuyen 150 NGIN ban dau de tao cac phieu du bao
        
    }
    
    // Goi ham nay de nop phieu du bao vao mot PHIEN DU BAO nao do 
    function NopPhieuDuBao(PhieuDuBao objPhieuDuBao) public 
    {
        // Kiem tra so du XU cua nguoi gui phieu msg.sender dam bao co du tien de tham gia, so tien tham gia >= 10
        
        // Kiem tra so UY NHIEM CHI >= so tien tham gia 
        
        // Lay thong tin trong objPhieuDuBao, kiem tra MA PHIEN va TRANG THAI cua phien du bao
        
        // Kiem tra thoi han NOP PHIEU cua phien du bao
        
        // Kiem tra KetQuaDuBao trong phieu co nam trong danh sach LuaChon hop le cua phien hay khong?
        
        // PASS QUA CAC DIEU KIEN => XU LY PHIEU
        
        // Cong tong so phieu cua phien du bao
            // Lay doi tuong phien du bao tu DanhSachPhien 
            // Cap nhat TongSoPhieu tang len 1 phieu
        
        // Cho phieu vao DanhSachPhieuDuBao 
             // Lay mapping danh sach phieu tuong ung voi phien du bao hien tai
             // Sinh MaPhieu = MaPhien << 24 + TongSoPhieu trong phien de lam KEY
             // PUSH phieu du bao vao mapping danh sach phieu thuoc mot PHIEN DU BAO
             
        // Cap nhat nguoi gui phieu vao DanhSachThamGia
            // Cap nhat BO SUNG ma phieu vao danh sach phieu cua nguoi tham gia 
        
        // Tong hop ket qua du bao
             // Lay doi tuong tong  hop theo MaPhien  => mapping
             // Lay doi tuong tong hop theo MaLuaChon => struct
             // Cap nhat TongGiaTri tang them so XU trong phieu
             // Cap nhat TongSoPhieu tang them 1
        
        // Tang tong so lan du bao cua toan bo SMART CONTRACT len 1  
        // Tang tong gia tri XU vao SMART CONTRACT len +=GiaTriDuBao nam trong phieu
        
        // Bao su kien NOP PHIEU THANH CONG
    }
    
    // Goi ham nay de dang ky tai khoan xac nhan ket qua THUC TE
    function DangKyXacNhanKetQua(address adNguoiXacNhan) public
    {
        // Kiem tra chi cho phep nguoi tao CONTRACT moi duoc phep goi ham nay
        // Kiem tra dam bao nguoi tham gia khong the XAC NHAN KET QUA 
        // Kiem tra nguoi xac nhan da co trong danh sach chua 
        // Tang SoNguoiXacNhanKetQua len 1
        // Cap nhat nguoi xac nhan vao danh sach TaiKhoanXacNhanKetQua  
    }
    
    // Tai khoan nam trong danh sach xac nhan ket qua se goi ham nay de XAC NHAN KET QUA
    function XacNhanKetQua(uint16 intMaLuaChonLaKetQuaCuoi) public
    {
        // Kiem tra tai khoan msg.sender nam trong danh sach nguoi xac nhan ket qua 
        // Kiem tra dam bao intMaLuaChonLaKetQuaCuoi nam trong danh sach lua chon hop le 
        // Tang so xac nhan ket qua HIEN TAI trong PHIEN DU BAO len 1 
        // Kiem tra neu SO XAC NHAN >= SoXacNhanKetQuaToiThieu -> cap nhat KetQuaCuoiCung cho phien du bao 
    }
    
    // Goi ham nay khi da co ket qua chinh thuc de linh thuong
    function KetThucPhienDuBaoCuaToi(bytes6 intMaPhienDuBao,address adTaiKhoanQuyetToan) public
    {
        // Neu adTaiKhoanQuyetToan==address(0) -> quyet toan cho msg.sender
        // Lay doi tuong PhienDuBao tu DanhSachPhien
        // Kiem tra thoi gian >= ThoiHanKetThuc 
        // Kiem tra SoXacNhanKetQuaHienTai >= SoXacNhanKetQuaToiThieu va KetQuaCuoiCung da cap nhat
        
        // Tinh tong GIA TRI CO THE CHIA (cong het TongHopKetQua cua cac LuaChon sai lai) 
        // Tong gia tri BEN THANG CUOC = Gia tri tuong ung voi KetQuaCuoiCung 
        
        // Lay tat ca cac PHIEU ma tai khoan gui den msg.sender da gui vao contract
        // Neu day la phieu DU DOAN DUNG   
                // Cong gia tri phieu vao phan GIA TRI DOAN DUNG
                // Cong gia tri phieu va TONG TIEN TRA LAI 
        
        // Tinh TY LE CHIA = GIA TRI DOAN DUNG / GIA TRI BEN THANG CUOC
        // TONG TIEN TRA THUONG = GIA TRI CO THE CHIA * TY LE CHIA 
        // Tinh GiaTriQuyetToan = TONG TIEN TRA THUONG + TONG TIEN TRA LAI
        // Neu  GiaTriQuyetToan >= GiaTriConLai trong PhienDuBao thi chuyen het gia tri con lai 
        // Chuyen khoan token tra thuong cho tai khoan REDEEM = GiaTriQuyetToan
             
        // Cap nhat trang thai da quyet toan Xong cho tai khoan nguoi tham gia
        // Cap nhat gia tri con lai tru bot gia tri da quyet toan 
        // Cap nhat trang thai cho PhienDuBao neu GiaTriConLai = 0 
    }
}