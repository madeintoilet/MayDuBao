// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0 <0.9.0;

contract DuBaoTuongLai {
    uint16  public TongSoLuaChon;
    uint    public TongSoPhienDuBao;
    uint    public TongSoLanDuBao;     // Tong so lan du bao cho tat ca cac phien
    uint    public TongGiaTriDuBao;    // Tong gia tri du bao cho tat ca cac phien

    enum enTrangThaiPhien {
        Moi, 
        DangNhanPhieu,
        NgungNhanPhieu,
        KetThuc
    }

    struct PhienDuBao {
        bytes6      MaPhien;
        string      MoTa;
        uint32      TongSoPhieu;
        uint        ThoiHanKetThucNopPhieu;
        uint        ThoiHanKetThuc;
        string      TyLeLuaChon;
        uint16      KetQuaCuoiCung;
        uint16[]    LuaChon;
        enTrangThaiPhien TrangThai;
    }

    enum enTrangThaiPhieuDuBao {
        HieuLuc,
        HetHieuLuc
    }

    struct PhieuDuBao {
        uint MaPhienDuBao;
        uint KetQuaDuBao;
        uint GiaTriDuBao; // tinh bang XU = 1 ETH
        uint ThoiGian;
        enTrangThaiPhieuDuBao TrangThai;
    }

    mapping(uint => PhienDuBao) private DanhSachPhien;
    mapping(uint => PhieuDuBao) private DanhSachPhieuDuBao;

    struct TongHopKetQua {
        uint TongGiaTri;
        uint TongSoPhieu;
    }

    mapping(uint => mapping(uint => TongHopKetQua)) TongHopKetQuaPhien; // MaPhien -> TongHop(MaLuaChon -> TongHopKetQua)

    enum enTrangThaiLuaChon {
        DangSuDung,
        HuyBo
    }

    struct LuaChon {
        uint16  MaLuaChon;
        string  MoTa;
        enTrangThaiLuaChon TrangThai;
    }

    mapping(uint => LuaChon) public DanhSachLuaChon; // MaLuaChon => Mo Ta lua chon & Trang thai

    mapping(uint => mapping(address => uint)) DanhSachThamGia;  // MaPhien -> Danh Sach Nguoi: Thoi Gian Tham Gia

    enum enTrangThaiHoatDong {
        DangHoatDong,
        TamDung,
        NgungHoatDong
    }

    enTrangThaiHoatDong public TrangThaiHoatDong;

    address[] TaiKhoanXacNhanKetQua;

    event TaoPhienDuBaoThanhCong(bytes6 MaPhienDuBao);

    constructor() {
        TongSoLuaChon = 0;
        TongSoPhienDuBao = 0;
        TongSoLanDuBao = 0;
        TongGiaTriDuBao = 0;
        TrangThaiHoatDong = enTrangThaiHoatDong.DangHoatDong;
    }


    // Tao phien du bao moi cho tran dau
    function TaoPhienDuBao(
            string memory strMoTaPhien, 
            uint dtThoiHanKetThucNopPhieu, 
            uint dtThoiHanKetThucPhien
        ) public returns (bytes6 MaPhieuDuBao) {

        // Tang tong so phien va cap ma cho phien du bao
        TongSoPhienDuBao += 1;
        bytes6 MaPhienDuBao = bytes6(keccak256(abi.encodePacked(block.timestamp + TongSoPhienDuBao)));

        // Tao doi tuong phien du bao
        // Cho vao mapping danh sach phien du bao DanhSachPhien
        uint16[] memory _luaChon;
        DanhSachPhien[TongSoPhienDuBao] =   PhienDuBao({
                                                MaPhien: MaPhienDuBao, 
                                                MoTa: strMoTaPhien,
                                                TongSoPhieu: 0,
                                                ThoiHanKetThucNopPhieu: dtThoiHanKetThucNopPhieu,
                                                ThoiHanKetThuc: dtThoiHanKetThucPhien,
                                                TyLeLuaChon: "", 
                                                KetQuaCuoiCung: 0,
                                                LuaChon: _luaChon,
                                                TrangThai: enTrangThaiPhien.Moi
                                            });

        emit TaoPhienDuBaoThanhCong(MaPhienDuBao);

        return MaPhienDuBao;
    }


    // Dang ky danh sach cac doi bong
    function DangKyLuaChon(string memory strMoTaLuaChon) public returns (uint16 intMaLuaChon) {
        // Bo sung lua chon vao danh sach va tra ve ma lua chon moi
        require(bytes(strMoTaLuaChon).length == 0, "Mo ta lua chon khong duoc de trong");

        uint16 intMaLuaChon = TongSoLuaChon++;

    }


    // Gan cac doi tuong ung tu danh sach lua chon vao phien du bao gan voi mot tran dau
    function CapNhatLuaChonChoPhienDuBao(bytes6 MaPhienDuBao, uint16[] memory ciDanhSachLuaChon) public {
        // Bo sung ma lua chon vao danh sach lua chon cua phien
    }

    function NopPhieuDuBao(PhieuDuBao memory objPhieuDuBao) public {

        // Kiem tra so du XU cua nguoi gui phieu msg.sender dam bao co du tien XU de tham gia

        // Lay thong tin trong objPhieuDuBao, Kiem tra MA PHIEN va TRANG THAI cua phien du bao dam bao hop le

        // Kiem tra thoi han NOP PHIEU cua phien du bao

        // Kiem tra KetQuaDuBao trong phieu co nam trong danh sach LuaChon hop le cua phien hay ko?

        // PASS QUA CAC DIEU KIEN => XU LY PHIEU

        // Cong tong so phieu cua phien du DuBao
            // Lay doi tuong du bao tu DanhSachPhien
            // Cap nhat TongSoPhieu tang len 1

        // Cap nhat nguoi gui phieu vao DanhSachThamGia

        // Cho phieu vao DanhSachPhieuDuBao (nho sinh MaPhieu = TongSoPhien << 16bit + TongSoPhieu trong phien de lam KEY)

        // Tong hop ket qua du bao
            // Lay doi tuong tong hop theo MaPHien => mapping
            // Lay doi tuong thong hop theo MaLuaChon => struct
            // Cap nhat TongGiaTri tang them so XU trong phieu
            // Cap nhat TongSoPhieu tang them 1

        // Tang tong so lan du bao cua toan bo SMART CONTRACT len 1

        // Tang tong gia tri XU vao SMART CONTRACT len += GiaTriDuBao nam trong phieu

        // Bao su kien NOP PHIEU THANH CONG

    }

    function toUint256(bytes memory _bytes, uint256 _start) internal pure returns (uint256) {
        require(_bytes.length >= _start + 32, "toUint256_outOfBounds");
        uint256 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x20), _start))
        }

        return tempUint;
    }
}