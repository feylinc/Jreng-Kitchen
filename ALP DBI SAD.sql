/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     10/14/2024 11:29:04 AM                       */
/*==============================================================*/
drop database if exists alp_jrengkitchen; 

create database if not exists alp_jrengkitchen;

use alp_jrengkitchen;

drop table if exists CUSTOMER;

drop table if exists DETAIL_PEMESANAN;

drop table if exists PEKERJA;

drop table if exists PEMESANAN;

drop table if exists PENJUALAN_ONLINE;

drop table if exists PRODUK;

/*==============================================================*/
/* Table: CUSTOMER                                              */
/*==============================================================*/
create table CUSTOMER
(
   ID_CUSTOMER          varchar(15) not null,
   NAMA_CUSTOMER        varchar(30) not null,
   NO_TELEPON_CUSTOMER  varchar(13) not null,
   ALAMAT_CUSTOMER      varchar(100),
   STATUS_DEL           varchar(1) not null,
   primary key (ID_CUSTOMER)
);

/*==============================================================*/
/* Table: DETAIL_PEMESANAN                                      */
/*==============================================================*/
create table DETAIL_PEMESANAN
(
   ID_DETAIL_PEMESANAN  varchar(25) not null,
   ID_PEMESANAN         varchar(21) not null,
   ID_PRODUK            varchar(3) not null,
   QTY                  int unsigned not null,
   HARGA_PCS            int not null,
   primary key (ID_DETAIL_PEMESANAN)
);

/*==============================================================*/
/* Table: PEKERJA                                               */
/*==============================================================*/
create table PEKERJA
(
   ID_PEKERJA           varchar(14) not null,
   NAMA_PEKERJA         varchar(30) not null,
   NO_TELEPON_PEKERJA   varchar(13) not null,
   STATUS_DEL           varchar(1) not null default 'F',
   primary key (ID_PEKERJA)
);

/*==============================================================*/
/* Table: PEMESANAN                                             */
/*==============================================================*/
create table PEMESANAN
(
   ID_PEMESANAN         varchar(21) not null,
   ID_CUSTOMER          varchar(15) not null,
   ID_PEKERJA           varchar(14) not null,
   TANGGAL_PO           date not null,
   TANGGAL_KIRIM        date not null,
   BIAYA_ONGKOS_KIRIM   int unsigned default NULL,
   BIAYA_PESANAN        int unsigned not null,
   ALAMAT_TRANSAKSI     varchar(100),
   METODE_PEMBAYARAN    varchar(8) not null,
   STATUS_LUNAS         bool not null,
   STATUS_DEL           varchar(1) not null default 'F',
   primary key (ID_PEMESANAN)
);

/*==============================================================*/
/* Table: PENJUALAN_ONLINE                                      */
/*==============================================================*/
create table PENJUALAN_ONLINE
(
   ID_PENJUALAN         varchar(8) not null,
   ID_PEKERJA           varchar(14) not null,
   TANGGAL_PENJUALAN    date not null,
   MERCHANT             varchar(8) not null,
   TOTAL_PENDAPATAN     int not null,
   TOTAL_PESANAN        int not null,
   PAJAK                int default NULL,
   BIAYA_ADMIN          int default NULL,
   POTONGAN             int default NULL,
   STATUS_DEL           varchar(1) not null default 'F',
   primary key (ID_PENJUALAN)
);

/*==============================================================*/
/* Table: PRODUK                                                */
/*==============================================================*/
create table PRODUK
(
   ID_PRODUK            varchar(3) not null,
   NAMA_PRODUK          varchar(30) not null,
   HARGA_PRODUK         int not null,
   STATUS_DEL           varchar(1) not null default 'F',
   primary key (ID_PRODUK)
);

alter table DETAIL_PEMESANAN add constraint FK_MEMPUNYAI foreign key (ID_PEMESANAN)
      references PEMESANAN (ID_PEMESANAN) on delete restrict on update restrict;

alter table DETAIL_PEMESANAN add constraint FK_MEMPUNYAI2 foreign key (ID_PRODUK)
      references PRODUK (ID_PRODUK) on delete restrict on update restrict;

alter table PEMESANAN add constraint FK_DIINPUT_OLEH foreign key (ID_PEKERJA)
      references PEKERJA (ID_PEKERJA) on delete restrict on update restrict;

alter table PEMESANAN add constraint FK_MEMBUAT foreign key (ID_CUSTOMER)
      references CUSTOMER (ID_CUSTOMER) on delete restrict on update restrict;

alter table PENJUALAN_ONLINE add constraint FK_INPUT foreign key (ID_PEKERJA)
      references PEKERJA (ID_PEKERJA) on delete restrict on update restrict;


-- Daftar Menu
insert into PRODUK (ID_PRODUK, NAMA_PRODUK, HARGA_PRODUK, STATUS_DEL) values
('M01', 'Mentai Chicken Rice', '16000', 'F'),
('S01', 'Spicy Bulgogi Chicken Rice', '16000', 'F'),
('B01', 'Black Pepper Chicken Rice', '16000', 'F'),
('B02', 'Butter Salt Chicken Rice', '16000', 'F'),
('H01', 'Honey Soy Chicken Rice', '16000', 'F'),
('S02', 'Salted Egg Chicken Rice', '17500', 'F'),
('S03', 'Sambal Matah Chicken Rice', '16000', 'F'),
('M02', 'Mentai Beef Telur', '17500', 'F'),
('S04', 'Spicy Bulgogi Beef Telur', '17500', 'F'),
('B03', 'Black Pepper Beef Telur', '17500', 'F'),
('E01', 'Extra Salad', '2000', 'F'),
('E02', 'Extra Egg', '4000', 'F'),
('E03', 'Es Coklat Choco Jreng', '6000', 'F'),
('M03', 'Mineral Water', '3000', 'F'),
('T01', 'Teh Pucuk', '4000', 'F');

-- Data Pekerja
insert into PEKERJA (ID_PEKERJA, NAMA_PEKERJA, NO_TELEPON_PEKERJA, STATUS_DEL) values
('P0812301223344',	'Rina', '0812301223344', 'F'),
('P0876553212455',	'Toni', '0876553212455', 'F');


-- VIEW
-- View Daftar Pemesanan
create or replace view vDaftarPemesanan as
SELECT PS.ID_PEMESANAN AS 'ID Pemesanan', C.NAMA_CUSTOMER AS 'Nama Customer', P.NAMA_PEKERJA AS 'Nama Staff', PS.TANGGAL_PO AS 'Tanggal PO', PS.TANGGAL_KIRIM AS 'Tanggal Kirim', PS.BIAYA_PESANAN AS 'Total' 
FROM PEMESANAN PS 
JOIN CUSTOMER C ON PS.ID_CUSTOMER = C.ID_CUSTOMER 
JOIN PEKERJA P ON PS.ID_PEKERJA = P.ID_PEKERJA;

-- View Penjualan dari Aplikasi Eksternal Bulan Ini
create or replace view vPenjualanBulanIni as
SELECT 
	P.NAMA_PEKERJA as 'Nama Staff', 
    PO.MERCHANT as 'Merchant', 
    PO.TOTAL_PENDAPATAN as 'Total Pendapatan', 
    PO.TOTAL_PESANAN as 'Total Pesanan', 
    PO.PAJAK as 'Pajak', 
    PO.BIAYA_ADMIN as 'Biaya Admin', 
    PO.POTONGAN as 'Total Potongan'
FROM PENJUALAN_ONLINE PO
JOIN PEKERJA P
ON PO.ID_PEKERJA = P.ID_PEKERJA
WHERE RIGHT(PO.ID_PENJUALAN, 6) = date_format(curdate(), '%Y%m') AND PO.STATUS_DEL = 'F';

-- View Daftar Produk Available
create or replace view vDaftarProdukAvail as
SELECT ID_PRODUK AS 'ID Produk', NAMA_PRODUK AS 'Nama Produk', HARGA_PRODUK AS 'Harga Produk' FROM PRODUK WHERE STATUS_DEL = 'F';

-- View Jumlah Transaksi Pemesanan dari WhatsApp Bulan Ini
create or replace view vTotalPesananWA as
SELECT COUNT(ID_PEMESANAN) FROM PEMESANAN WHERE LEFT(TANGGAL_KIRIM, 7) = date_format(current_date(), '%Y-%m');


-- PROCEDURE
-- Procedure Top 5 Menu Terlaris Berdasarkan Bulan dan Tahun yang Dicari
DROP PROCEDURE pBestSeller;
delimiter $$
CREATE PROCEDURE pBestSeller(IN tahun VARCHAR(4), IN bulanStr INT)
BEGIN
	SELECT P.NAMA_PRODUK, SUM(DP.QTY)
	FROM PRODUK P
	JOIN DETAIL_PEMESANAN DP ON P.ID_PRODUK = DP.ID_PRODUK
	JOIN PEMESANAN PE ON DP.ID_PEMESANAN = PE.ID_PEMESANAN
	WHERE LEFT(TANGGAL_KIRIM, 7) = CONCAT(tahun, '-', bulanStr)	
    GROUP BY P.ID_PRODUK 
	ORDER BY SUM(DP.QTY) DESC 
	LIMIT 5;
END $$
delimiter ;

-- Procedure Detail Pemesanan
DROP PROCEDURE pDetailPemesanan;
delimiter $$
CREATE PROCEDURE pDetailPemesanan(IN parIdPemesanan VARCHAR(21))
BEGIN
SELECT P.NAMA_PRODUK AS 'Nama Produk', DP.QTY AS 'Qty', DP.HARGA_PCS AS 'Harga per Produk', SUM(DP.HARGA_PCS * DP.QTY) AS 'Harga Produk'
FROM DETAIL_PEMESANAN DP
JOIN PRODUK P ON DP.ID_PRODUK = P.ID_PRODUK
WHERE ID_PEMESANAN = parIdPemesanan 
GROUP BY 1, 2, 3;
END $$
delimiter ;
call pDetailPemesanan('241122FE085107028168');


-- FUNCTION
-- Function ID Pemesanan
 drop function fBuatIDPesanan;
 delimiter //
 create function fBuatIDPesanan(parYear varchar(2), parMonth varchar(2), parDay varchar(2), parIDCust varchar(15))
 returns varchar (21)
 reads sql data
    begin
	declare idPesanan varchar(21);
    
    set idPesanan = concat(parYear, parMonth, parDay, parIDCust);
	return idPesanan;
    end //
delimiter ;

-- Function Hitung Hasil Pendapatan
drop function fHitungTotalPenjualan;
delimiter //
create function fHitungTotalPenjualan(parTahun varchar(4), parBulan varchar(2))
 returns int 
    reads sql data
    begin
    declare hasilKeuntungan int;
    declare keuntunganGojek int;
    declare keuntunganGrab int;
    declare keuntunganShopee int;
    declare keuntunganWA int;
    
    set keuntunganGojek = 0;
    set keuntunganGrab = 0;
    set keuntunganShopee = 0;
    set keuntunganWA = 0;
    
    select total_pendapatan into keuntunganGojek from PENJUALAN_ONLINE where id_penjualan = concat('GO', parTahun, parBulan);
    select total_pendapatan into keuntunganGrab from PENJUALAN_ONLINE where id_penjualan = concat('GR', parTahun, parBulan);
    select total_pendapatan into keuntunganShopee from PENJUALAN_ONLINE where id_penjualan = concat('SH', parTahun, parBulan);
	select sum(biaya_pesanan) - sum(biaya_ongkos_kirim) into keuntunganWA from PEMESANAN where left(tanggal_kirim, 7) = concat(parTahun, '-', parBulan);
    
    set hasilKeuntungan = keuntunganGojek + keuntunganGrab + keuntunganShopee + keuntunganWA;
    return hasilKeuntungan;
    end //
delimiter ;

-- TRIGGER
-- Trigger Auto Generate ID Produk
drop trigger tInsProduk;
delimiter $$
create trigger tInsProduk
before insert
on PRODUK for each row
begin
 declare nextID varchar(3);
    
 select ifnull(right(max(id_produk), 2) + 1, '01') into nextID 
    from produk 
    where left(nama_produk, 1) = upper(left(new.nama_produk, 1));
    
    set new.id_produk = concat(upper(left(new.nama_produk, 1)), lpad(nextID, 2, '0'));
end $$
delimiter ;

-- Trigger Set ID Pemesanan yang Kosong Sebelum Insert
drop trigger tInsPesanan;
delimiter //
create trigger tInsPesanan
before insert
on PEMESANAN for each row
begin
	declare idPesanan varchar(21);

    set idPesanan = fBuatIDPesanan(date_format(new.tanggal_po, '%y'), date_format(new.tanggal_po, '%m'), date_format(new.tanggal_po, '%d'), new.id_customer);
	set new.id_pemesanan = idPesanan;
    set new.status_del = 'F';
end //
delimiter ;

-- Trigger ID Detail Pemesanan Sebelum Insert
drop trigger tInsDetail;
delimiter //
create trigger tInsDetail
before insert
on DETAIL_PEMESANAN for each row
begin
	declare idDetail varchar(25);
    
	set idDetail = concat(new.id_pemesanan, '-', new.id_produk);
    set new.id_detail_pemesanan = idDetail;
end //
delimiter ;