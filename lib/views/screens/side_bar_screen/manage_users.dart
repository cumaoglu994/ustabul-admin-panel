import 'package:flutter/material.dart';

class ManageUsers extends StatelessWidget {
  static const String routeName = '\ManageUsers';
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
              'Kullanıcı Yönetimi',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36,
              ),
            ),
          ),
          Row(
            children: [
              _rowHeader('Logo', 2), // Logo
              _rowHeader('Adı', 3), // Name
              _rowHeader('Şehir', 2), // City
              _rowHeader('Durum', 2), // State
              _rowHeader('İşlem', 1), // Action
              _rowHeader('Daha Fazla', 2), // View More
            ],
          ),
        ],
      ),
    );
  }
}
