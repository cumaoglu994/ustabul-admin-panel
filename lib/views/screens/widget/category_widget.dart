import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    double genislik = MediaQuery.of(context).size.width / 6;

    // Ana kategorileri dinle
    final Stream<QuerySnapshot> _mainCategoriesStream =
        _firestore.collection('mainCategories').snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _mainCategoriesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Bir hata oluştu: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.cyan,
            ),
          );
        }

        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'Henüz kategori eklenmemiş',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, mainIndex) {
            final mainCategoryDoc = snapshot.data!.docs[mainIndex];
            final mainCategoryId = mainCategoryDoc.id;
            final mainCategoryName = mainCategoryDoc['name'] ?? '';

            return Container(
              margin: EdgeInsets.only(bottom: 24),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ana kategori başlığı
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      mainCategoryName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 8),
                  // Alt kategorileri göster
                  StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('categories')
                        .where('mainCategoryId', isEqualTo: mainCategoryId)
                        .snapshots(),
                    builder: (context, subSnapshot) {
                      if (subSnapshot.hasError) {
                        return Text('Alt kategori yüklenirken hata oluştu');
                      }

                      if (subSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (subSnapshot.data == null ||
                          subSnapshot.data!.docs.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Bu ana kategoriye ait alt kategori bulunmuyor',
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        );
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: subSnapshot.data!.docs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemBuilder: (context, subIndex) {
                          final subCategoryData =
                              subSnapshot.data!.docs[subIndex];
                          final imageUrl = subCategoryData['image'];
                          return Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 8.0, left: 8),
                                child: SizedBox(
                                  height: 100,
                                  width: genislik,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: imageUrl != null && imageUrl.toString().isNotEmpty
                                        ? Image.network(
                                            imageUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                color: Colors.grey[300],
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                  color: Colors.grey[600],
                                                  size: 40,
                                                ),
                                              );
                                            },
                                            loadingBuilder:
                                                (context, child, loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            },
                                          )
                                        : Container(
                                            color: Colors.grey[300],
                                            child: Icon(
                                              Icons.category,
                                              color: Colors.grey[600],
                                              size: 40,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                subCategoryData['categoryName'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
