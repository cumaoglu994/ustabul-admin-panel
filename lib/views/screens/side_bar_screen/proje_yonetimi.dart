import 'package:flutter/material.dart';

class hizmetDegerlendirme extends StatelessWidget {
  static const String routeName = '\hizmetDegerlendirme';
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
              'hizmet degerlendirme',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36,
              ),
            ),
          ),
          Row(
            children: [
              _rowHeader('Proje Adı', 2), // Projenin adı
              _rowHeader('Müşteri Adı', 3), // Proje sahibi müşteri
              _rowHeader('Başlama Tarihi', 2), // Projenin başlama tarihi
              _rowHeader('Durum', 2), // Proje durumu (tamamlandı/devam ediyor)
              _rowHeader('Bütçe', 1), // Proje bütçesi
              _rowHeader('İşlem', 1), // İşlem butonları (düzenle/sil)
            ],
          ),
        ],
      ),
    );
  }
}
