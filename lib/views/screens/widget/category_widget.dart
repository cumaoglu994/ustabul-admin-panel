import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double genislik = MediaQuery.of(context).size.width / 6;
    final Stream<QuerySnapshot> _categoriesStream =
        FirebaseFirestore.instance.collection('categories').snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _categoriesStream,
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
              final categoryData = snapshot.data!.docs[Index];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8),
                    child: SizedBox(
                      height: 100,
                      width: genislik,
                      child: Image.network(
                        categoryData['image'],
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
                  ),
                  Text(
                    categoryData['categoryName'],
                  ),
                ],
              );
            });
      },
    );
  }
}
