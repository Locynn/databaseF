import 'dart:io';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'ogrenci.dart';

class DatabaseHelper {
  // static DatabaseHelper _databaseHelper;
  late Database _database;
  String _ogrenciTablo = "ogrenci";
  String _columnID = "id";
  String _columnIsim = "isim";
  String _columnSoyad = "soyad";
  String _columnVize = "vize";
  String _columnFinal = "final";
  String _columnAktif = "aktif";

  Future<Database> get db async {
    if (_database != null) return _database;
    _database = await _getDatabase();
    return _database;
  }

  _getDatabase() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + "ogrenci.db";
    var theDb = await openDatabase(path, version: 1, onCreate: _createDB);
    return theDb;
  }

  _createDB(Database db, int version) async {
    print("tablo oluşturulacak");
    await db.execute(
        "CREATE TABLE $_ogrenciTablo ($_columnID INTEGER PRIMARY KEY AUTOINCREMENT, "
        "$_columnIsim TEXT, $_columnSoyad TEXT, $_columnVize INTEGER, $_columnFinal INTEGER, $_columnAktif ınteger )");
  }

  Future<int> ogrenciEkle(Ogrenci ogrenci) async {
    var db = await _getDatabase();
    var sonuc = await db.insert(
        _ogrenciTablo, ogrenci.dbyeYazmanIcinMapeDonustur(),
        nullColumnHack: "$_columnID");
    print("ogrenci db ye eklendi" + sonuc.toString());
    return sonuc;
  }

  Future<List<Map<String, dynamic>>> tumOgrenciler() async {
    var db = await _getDatabase();
    var sonuc = await db.query(_ogrenciTablo, orderBy: '$_columnID ASC');
    return sonuc;
  }

  Future<int> ogrenciGuncelle(Ogrenci ogrenci) async {
    var db = await _getDatabase();
    var sonuc = await db.update(
        _ogrenciTablo, ogrenci.dbyeYazmanIcinMapeDonusturID(),
        where: '$_columnID = ?', whereArgs: [ogrenci.id]);
    return sonuc;
  }

  Future<int> ogrenciSil(int id) async {
    var db = await _getDatabase();
    //sonuca silinen satır sayısı aktarılmakta
    var sonuc = await db
        .delete(_ogrenciTablo, where: '$_columnID = ? ', whereArgs: [id]);
    return sonuc;
  }

  Future<int> tumOgrenciTablosunuSil() async {
    var db = await _getDatabase();
    //sonuca silinen satır sayısı aktarılmakta
    var sonuc = await db.delete(_ogrenciTablo);
    return sonuc;
  }

  Future MaxBasari() async {
    var db = await _getDatabase();
    var result =
        await db.rawQuery("SELECT MAX($_columnVize *.4 + $_columnFinal *.6 )"
            " as maximum FROM $_ogrenciTablo");
    var max = result[0]['maximum'];
    return max;
  }

  Future MinBasari() async {
    var db = await _getDatabase();
    var result =
        await db.rawQuery("SELECT MIN($_columnVize *.4 + $_columnFinal *.6 ) "
            "as minimum FROM $_ogrenciTablo");
    var min = result[0]['minimum'];
    return min;
  }

  Future OrtBasari() async {
    var db = await _getDatabase();
    var result =
        await db.rawQuery("SELECT AVG($_columnVize *.4 + $_columnFinal *.6 ) "
            "as ortalama FROM $_ogrenciTablo");
    var ort = result[0]['ortalama'];
    return ort;
  }
}
