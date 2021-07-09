// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0; 

interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract DuBaoTuongLai {

    // Tổng số phiếu dự báo
    uint    public  TongSoPhienDuBao;
    // Tổng số lần dự báo
    uint    public  TongSoLanDuBao;
    // Tổng giá trị dự báo cho tất cả các phiên
    uint    public  TongGiaTriDuBao;
    // Người tạo ra phiên dự báo
    address NguoiTao;
    // Số người xác nhận kết quả khi 1 phiên kết thúc
    uint16          SoNguoiXacNhanKetQua;
    // Các tài khoản tham gia xác nhận kết quả
    address[]       TaiKhoanXacNhanKetQua;

    IERC20 public KhoTien;
    address constant public DiaChiNGIN = 0xFcF3269B7b908D1766c65176c4ff7bD6b1D7553E;

    // Trạng thái hoạt động của contract
    enum enTrangThaiHoatDong { DangHoatDong, TamDung, NgungHoatDong }
    enTrangThaiHoatDong public TrangThaiHoatDong;  

    // Lựa chọn đại diện cho đội
    enum enTrangThaiLuaChon {DangSuDung, HuyBo}
    struct LuaChon {
        string MoTa;
        enTrangThaiLuaChon TrangThai;
    }

    // Phiên lựa chọn đại diện cho trận đấu
    enum enTrangThaiPhien { Moi, DangNhanPhieu, NgungNhanPhieu, DaXacNhan,KetThuc }
    struct PhienDuBao {
        bytes6    MaPhien;
        string  MoTa;
        uint32  TongSoPhieu;
        uint    TongGiaTri;
        uint    GiaTriConLai;
        
        uint    ThoiHanKetThucNopPhieu;
        uint    ThoiHanKetThuc;
        
        uint16  SoXacNhanKetQuaToiThieu;
        uint16  SoXacNhanKetQuaHienTai;
        uint16  KetQuaXacNhanCuoiCung;
        uint16  KetQuaCuoiCung;
        
        string  TyLeLuaChon;
        uint16[] LuaChon;
        enTrangThaiPhien TrangThai;        
    }

    // Phiếu dự báo đại diện cho vé
    enum enTrangThaiPhieuDuBao { HieuLuc, HetHieuLuc }
    struct PhieuDuBao {
        bytes6 MaPhienDuBao;
        uint KetQuaDuBao;
        uint GiaTriDuBao; // tinh bang XU = 1 ETH
        uint ThoiGian;
        enTrangThaiPhieuDuBao TrangThai; 
    }
    
    // Tổng hợp kết quả theo phiên và theo lựa chọn
    struct TongHopKetQua {
        uint TongGiaTri;
        uint TongSoPhieu;
    }

    // Người tham gia
    struct NguoiThamGia {
        string HoTen;
        string DienThoai;
        uint32[] DanhSachPhieu;
        bool   DaQuyetToanXong;
    }

    // Danh sách phiên dự báo
    mapping(bytes6 => PhienDuBao) private DanhSachPhien;
    // Danh sách phiếu dự báo 
    mapping(bytes6 => mapping(uint24 => PhieuDuBao)) private DanhSachPhieuDuBao; 
    // Danh sách tổng hợp kết quả theo phiên và theo lựa chọn
    mapping(bytes6 => mapping(uint => TongHopKetQua)) TongHopKetQuaPhien;   // MaPhien -> TongHop(MaLuaChon -> TongHopKetQua)
    //Danh sách các lựa chọn
    mapping(uint => LuaChon) public DanhSachLuaChon; // MaLuaChon => Mo Ta lua chon & trang thai
    // Danh sách người tham gia được map theo địac chỉ
    mapping(bytes6 => mapping(address => NguoiThamGia)) DanhSachThamGia; // MaPhien -> DiaChiNguoiThamGia: NguoiThamGia 

    constructor() {
        TongSoPhienDuBao = 0;
        TongSoLanDuBao = 0;
        TongGiaTriDuBao = 0;
        TrangThaiHoatDong = enTrangThaiHoatDong.DangHoatDong;
        NguoiTao = msg.sender;
        KhoTien = IERC20(DiaChiNGIN);
    }
    
    // Gọi hàm này để tạo một phiên dự báo trận đấu
    function TaoPhienDuBao(string memory strMoTaPhien,
                           uint dtThoiHanKetThucNopPhieu, 
                           uint dtThoiHanKetThucPhien)
                           public returns (bytes6 intMaPhienDuBao)    {
        
        // Tăng tổng số phiên dự báo
        TongSoPhienDuBao += 1;

        // Tạo mã phiên dự báo
        // intMaPhienDuBao = bytes6(keccak256(block.timestamp + TongSoPhienDuBao));
        
        // Tạo đối tượng phiên dự báo
        
        // Cho vào danh sách mapping phiên dự báo
        
    }
    
    // Gọi hàm này để đăng ký các đội bóng
    function DangKyLuaChon(string memory strMoTaLuaChon) public returns (uint16 MaLuaChon){
        
        // Bổ sung lựa chọn vào danh sách lựa chọn
    }
    
    // Gọi hàm này để cập nhật các lựa chọn vào phiên dự báo
    function CapNhatLuaChonVaoPhienDuBao(uint MaPhienDuBao,uint16[] memory ciDanhSachLuaChon) public{
        // Bổ sung mảng lựa chọn vào danh sách lựa chọn trong phiên dự báo
    }
    
    // Đăng ký tham gia dự báo, mỗi người được đăng ký tham gia một lần trong 1 phiên
    function DangKyThamGiaDuBao(bytes6 intMaPhienDuBao) public{
        // Kiểm tra xem msg.sender đã có trong danh sách người tham gia chưa
        
        // Nếu chưa có thì cho vào danh sách tham gia

        // Chuyển cho 0.01 ETH để có thể chạy contract
        
        // Chuyển 150 NGIN để tham ra tạo phiếu ban đầu
        
    }

    event NopPhieuDuBaoThanhCongRoi(uint16 intMaPhieu);
    
    // Gọi hàm này để nộp phiếu dự báo vào 1 phiên dự báo nào đó 
    function NopPhieuDuBao(bytes6 intMaPhienDuBao, uint intKetQuaDuBao, uint intGiaTriDuBao) public {
        
        // Tạo đối tượng phiếu dự báo
        
        PhieuDuBao memory objPhieuDuBao = PhieuDuBao({
             MaPhienDuBao: intMaPhienDuBao,
             KetQuaDuBao: intKetQuaDuBao,
             GiaTriDuBao: intGiaTriDuBao, // tinh bang XU = 1 ETH
             ThoiGian: block.timestamp,
             TrangThai: enTrangThaiPhieuDuBao.HieuLuc
        });
        // Kiểm tra số xu có đủ số tiền để tham gia không, số dư >=10
        require(objPhieuDuBao.GiaTriDuBao >=10 * (1 ether) && msg.sender.balance >= objPhieuDuBao.GiaTriDuBao);
        
        // Kiểm tra số ủy nhiệm chi >= số tham gia
        uint GiaTriUyNhiem = KhoTien.allowance(msg.sender, address(this));
        require(GiaTriUyNhiem >= objPhieuDuBao.GiaTriDuBao);

        require(objPhieuDuBao.MaPhienDuBao > 0 );
        // Kiểm tra mã phiên và trạng thái của phiên dự báo
        PhienDuBao memory objPhienDuBao = DanhSachPhien[objPhieuDuBao.MaPhienDuBao];

        // Kiểm tra xem phiên có tồn tại hay không
        require(objPhienDuBao.MaPhien == objPhieuDuBao.MaPhienDuBao);

        // Kiểm tra trạng thái phiên dự báo
        require(objPhienDuBao.TrangThai == enTrangThaiPhien.DangNhanPhieu);

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