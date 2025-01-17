import 'package:flutter/material.dart';

class HizmetSYonetimi extends StatelessWidget {
  static const String routeName = '\HizmetYönetimi';
  Widget _rowHeader(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          color: const Color.fromARGB(255, 108, 108, 108),
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Hizmet  Yönetimi',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36,
              ),
            ),
          ),
          Row(
            children: [
              _rowHeader('Ad Soyad', 2), // Hizmet sağlayıcının adı
              _rowHeader('Kategori', 3), // Hizmet sağladığı kategori
              _rowHeader('Şehir', 2), // Bulunduğu şehir
              _rowHeader('Durum', 2), // Hizmet durumu (aktif/pasif)
              _rowHeader('Puan', 1), // Değerlendirme puanı
              _rowHeader('İşlem', 1), // İşlem butonları (düzenle/sil)
            ],
          ),
        ],
      ),
    );
  }
}
