import 'dart:core';

class Ogrenci {
  late int _id;
  late String _isim;
  late String _soyad;
  late int _vNot;
  late int _fNot;
  late int _aktif;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get isim => _isim;

  set isim(String value) {
    _isim = value;
  }

  int get aktif => _aktif;

  set aktif(int value) {
    _aktif = value;
  }

  int get fNot => _fNot;

  set fNot(int value) {
    _fNot = value;
  }

  int get vNot => _vNot;

  set vNot(int value) {
    _vNot = value;
  }

  String get soyad => _soyad;

  set soyad(String value) {
    _soyad = value;
  }

  Ogrenci(this._isim, this._soyad, this._vNot, this._fNot, this._aktif);

  Ogrenci.withID(
      this._id, this._isim, this._soyad, this._vNot, this._fNot, this._aktif);

  @override
  String toString() {
    return '$_id, Ad: $_isim, soyad: $_soyad, Vize: $_vNot, Final: $_fNot, Başarı: ${(_vNot*0.4+_fNot*0.6).toStringAsFixed(1)}';
  }
  Map<String, dynamic> dbyeYazmanIcinMapeDonustur(){
    var map=Map<String, dynamic>();
    map['isim']=_isim;
    map['soyad']=_soyad;
    map['vize']=_vNot;
    map['final']=_fNot;
    map['aktif']=_aktif;
    return map;
  }
  Map<String, dynamic> dbyeYazmanIcinMapeDonusturID(){
    var map=Map<String, dynamic>();
    map['id']=_id;
    map['isim']=_isim;
    map['soyad']=_soyad;
    map['vize']=_vNot;
    map['final']=_fNot;
    map['aktif']=_aktif;
    return map;
  }
  Ogrenci.dbdenOkudugunMapiObyejeDonustur(Map<String, dynamic> map){
    this._id=map['id'];
    this._isim=map['isim'];
    this._soyad=map['soyad'];
    this._vNot=map['vize'];
    this._fNot=map['final'];
    this._aktif=map['aktif'];
  }
}









