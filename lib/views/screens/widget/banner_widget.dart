import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double genislik = MediaQuery.of(context).size.width / 6;

    final Stream<QuerySnapshot> _bannersStream =
        FirebaseFirestore.instance.collection('Banners').snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _bannersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.cyan,
            ),
          );
        }

        return GridView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.size,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6, mainAxisSpacing: 8, crossAxisSpacing: 8),
            itemBuilder: (context, Index) {
              final _bannersData = snapshot.data!.docs[Index];
              return Column(
                children: [
                  SizedBox(
                    height: 150,
                    width: genislik, // Ekran genişliğinin 1/6'sı
                    child: Image.network(
                      _bannersData['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons
                            .error); // Görüntü yüklenemezse hata ikonu göster
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child:
                              CircularProgressIndicator(), // Görüntü yüklenirken gösterilecek indikatör
                        );
                      },
                    ),
                  ),
                ],
              );
            });
      },
    );
  }
}
