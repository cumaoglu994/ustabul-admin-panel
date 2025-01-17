import 'package:flutter/material.dart';

class RezervasyonTalepler extends StatelessWidget {
  static const String routeName = '\RezervasyonTalepler';
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
              'Rezervasyon ve Talepler',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36,
              ),
            ),
          ),
          Row(
            children: [
              _rowHeader('Talep Eden', 2), // Talepte bulunan kişi/kurum
              _rowHeader('Hizmet', 3), // Talep edilen hizmet
              _rowHeader('Rezervasyon Tarihi', 2), // Rezervasyon tarihi
              _rowHeader(
                  'Durum', 2), // Rezervasyon durumu (onaylandı/beklemede)
              _rowHeader('Fiyat', 1), // Hizmet ücreti
              _rowHeader('İşlem', 1), // İşlem butonları (düzenle/sil)
            ],
          ),
        ],
      ),
    );
  }
}
