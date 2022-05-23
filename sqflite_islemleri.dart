import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'database_helper.dart';
import 'ogrenci.dart';

class SqfliteIslemleri extends StatefulWidget {
  @override
  _SqfliteIslemleriState createState() => _SqfliteIslemleriState();
}

class _SqfliteIslemleriState extends State<SqfliteIslemleri> {
  late DatabaseHelper _databaseHelper;
  late List<Ogrenci> tumOgrencilerListesi;
  bool aktiflik = false;
  final formkey = GlobalKey<FormState>();
  bool otomatikKontrol = false;
  final TextEditingController _textControllerAd = new TextEditingController();
  final TextEditingController _textControllerSoyad =
  new TextEditingController();
  final TextEditingController _textControllerVize = new TextEditingController();
  final TextEditingController _textControllerFinal =
  new TextEditingController();

  var tiklanilanOgrenciIndeksi = 0;
  var tiklanilanOgrenciID = null;

  @override
  void initState() {
    super.initState();
    tumOgrencilerListesi = <Ogrenci>[];
    _databaseHelper = DatabaseHelper();
    _databaseHelper.tumOgrenciler().then((tumOgrencileriTutanMapListesi) {
      for (Map<String,dynamic> okunanOgrenciMap in tumOgrencileriTutanMapListesi) {
        tumOgrencilerListesi
            .add(Ogrenci.dbdenOkudugunMapiObyejeDonustur(okunanOgrenciMap));
      }
      setState(() {});
    }).catchError((hata) => print("hata : " + hata));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sqflite Kullanımı"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.info,
          size: 36,
          color: Colors.white,
        ),
        onPressed: () {
          hesapla(context);
        },
      ),
      body: Column(
          children: [
            Form(
              key: formkey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _textControllerAd,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () => _textControllerAd.clear(),
                          icon: Icon(Icons.clear),
                        ),
                        prefixIcon: Icon(Icons.account_circle),
                        hintText: "Adınızı Giriniz",
                        labelText: "Ad",
                        border: OutlineInputBorder(),
                      ),
                      validator: (girilenVeri) {
                        _isimKontrol(girilenVeri!);
                        if (girilenVeri.length < 3) {
                          return "İsim en az 3 karakter olmalıdır.";
                        } else
                          return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      controller: _textControllerSoyad,
                      decoration: InputDecoration(
                        hintText: "Soyadınızı Giriniz",
                        labelText: "Soyad",
                        border: OutlineInputBorder(),
                      ),
                      validator: (girilenVeri) {
                        _isimKontrol(girilenVeri!);
                        if (girilenVeri.length < 3) {
                          return "Soyad en az 3 karakter olmalıdır.";
                        } else
                          return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _textControllerVize,
                      decoration: InputDecoration(
                        hintText: "Vize Notu Giriniz",
                        labelText: "Vize",
                        border: OutlineInputBorder(),
                      ),
                      validator: (girilenVeri) {
                        //   _isimKontrol(girilenVeri);
                        if (!isNumeric(girilenVeri!)) {
                          return "Sayısal veri giriniz";
                        } else
                          return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _textControllerFinal,
                      decoration: InputDecoration(
                        hintText: "Final Notu Giriniz",
                        labelText: "Final",
                        border: OutlineInputBorder(),
                      ),
                      validator: (girilenVeri) {
                        //   _isimKontrol(girilenVeri);
                        if (!isNumeric(girilenVeri!)) {
                          return "Sayısal veri giriniz";
                        } else
                          return null;
                      },
                    ),
                  ),
                  SwitchListTile(
                      title: Text("Aktif"),
                      value: aktiflik,
                      onChanged: (aktifMi) {
                        setState(() {
                          aktiflik = aktifMi;
                        });
                      },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red, // background
                      onPrimary: Colors.white, // foreground
                    ),
                    child: Text('Kaydet'),
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        formkey.currentState!.save();
                        _ogrenciEkle(Ogrenci(
                            _textControllerAd.text,
                            _textControllerSoyad.text,
                            int.parse(_textControllerVize.text),
                            int.parse(_textControllerFinal.text),
                            aktiflik == true ? 1 : 0));
                      } else {
                        setState(() {
                          otomatikKontrol = true;
                        });
                      }
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green, // background
                      onPrimary: Colors.white, // foreground
                    ),
                    child: Text('Güncelle'),
                    onPressed: tiklanilanOgrenciID == null
                        ? null
                        : () {
                      if (formkey.currentState!.validate()) {
                        formkey.currentState!.save();
                        _ogrenciGuncelle(Ogrenci.withID(
                            tiklanilanOgrenciID,
                            _textControllerAd.text,
                            _textControllerSoyad.text,
                            int.parse(_textControllerVize.text),
                            int.parse(_textControllerFinal.text),
                            aktiflik == true ? 1 : 0));
                      } else {
                        setState(() {
                          otomatikKontrol = true;
                        });
                      }
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // background
                      onPrimary: Colors.white, // foreground
                    ),
                    child: Text('Tüm tabloyu sil'),
                    onPressed: () {
                      _tumTabloyuTemizle();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tumOgrencilerListesi.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: tumOgrencilerListesi[index].aktif == 1
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          _textControllerAd.text =
                              tumOgrencilerListesi[index].isim;
                          _textControllerSoyad.text =
                              tumOgrencilerListesi[index].soyad;
                          _textControllerVize.text =
                              (tumOgrencilerListesi[index].vNot).toString();
                          _textControllerFinal.text =
                              (tumOgrencilerListesi[index].fNot).toString();
                          aktiflik = tumOgrencilerListesi[index].aktif == 1
                              ? true
                              : false;
                          tiklanilanOgrenciIndeksi = index;
                          tiklanilanOgrenciID = tumOgrencilerListesi[index].id;
                        });
                      },
                      title: Text(tumOgrencilerListesi[index].toString()),
                      trailing: GestureDetector(
                        onTap: () {
                          _ogrenciSil(tumOgrencilerListesi[index].id, index);
                        },
                        child: Icon(Icons.delete),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
 
    );
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  void _ogrenciEkle(Ogrenci ogrenci) async {
    var eklenenYeniOgrenciID = await _databaseHelper.ogrenciEkle(ogrenci);
    ogrenci.id = eklenenYeniOgrenciID;
    if (eklenenYeniOgrenciID > 0) {
      setState(() {
        otomatikKontrol = false;
        tumOgrencilerListesi.add(ogrenci);
        _textControllerAd.clear();
        _textControllerSoyad.clear();
        _textControllerVize.clear();
        _textControllerFinal.clear();
      });
    }
  }

  _isimKontrol(String isim) {
    RegExp regex = RegExp("^[a-zA-Z]+\$");
    if (!regex.hasMatch(isim))
      return "İsim rakam içermemeli";
    else
      return null;
  }

  void _tumTabloyuTemizle() async {
    var silinenElemanSayisi = await _databaseHelper.tumOgrenciTablosunuSil();
    if (silinenElemanSayisi > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Text(silinenElemanSayisi.toString() + " kayıt silindi"),
        ),
      );
      setState(() {
        tumOgrencilerListesi.clear();
      });
    }
    tiklanilanOgrenciID = null;
  }

  void _ogrenciSil(
      int veritabanindanSilinecekID, int listedenSilinecekId) async {
    var sonuc = await _databaseHelper.ogrenciSil(veritabanindanSilinecekID);
    if (sonuc == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Text(" kayıt silindi"),
        ),
      );
      setState(() {
        tumOgrencilerListesi.removeAt(listedenSilinecekId);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Text("Kayıt silerken hata oluştu"),
        ),
      );
    }
    tiklanilanOgrenciID = null;
  }

  void _ogrenciGuncelle(Ogrenci ogrenci) async {
    var sonuc = await _databaseHelper.ogrenciGuncelle(ogrenci);
    if (sonuc == 1) {
      var snackBar = SnackBar(duration: Duration(seconds: 2),
          content: Text('Kayıt güncellendi'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        tumOgrencilerListesi[tiklanilanOgrenciIndeksi] = ogrenci;
        _textControllerAd.clear();
        _textControllerSoyad.clear();
        _textControllerVize.clear();
        _textControllerFinal.clear();
        tiklanilanOgrenciID = null;
      });
    }
  }

  hesapla(BuildContext ctx) async {
    var maxBasari = await _databaseHelper.MaxBasari();
    var minBasari = await _databaseHelper.MinBasari();
    var ortBasari = await _databaseHelper.OrtBasari();
    print(maxBasari);
    print(minBasari);
    print(ortBasari);
    showDialog(
      context: ctx,
      barrierDismissible: false, //alerte basınca kaybolur
      builder: (ctx) {
        return AlertDialog(
          title: Text("Başarı Not Bilgileri"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text("En Büyük Başarı notu : ${maxBasari.toStringAsFixed(1)}"),
                Text("En Küçük Başarı notu : ${minBasari.toStringAsFixed(1)}"),
                Text("Ortalama Başarı notu : ${ortBasari.toStringAsFixed(1)}"),
              ],
            ),
          ),
          actions: [
            ButtonBarTheme(
              data: ButtonBarThemeData(),
              child: ButtonBar(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.red, // foreground
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('tamam'),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
