import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ustabul_web_admin/views/screens/widget/category_widget.dart';

class CategoriesScreen extends StatefulWidget {
  static const String routeName = '\CategoriesScreen';

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _mainCategoryFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _subCategoryFormKey = GlobalKey<FormState>();

  dynamic _image;
  String? fileName;
  String? mainCategoryName;
  String? subCategoryName;
  String? selectedMainCategoryId;

  _pickImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);
    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    }
  }

  _upLoadCategoryBannerToStorage(dynamic image) async {
    Reference ref = _storage.ref().child('categoryImages').child(fileName!);
    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // Ana kategori ekleme
  uploadMainCategory() async {
    EasyLoading.show();
    if (_mainCategoryFormKey.currentState!.validate()) {
      await _firestore.collection('mainCategories').add({
        'name': mainCategoryName,
        'createdAt': FieldValue.serverTimestamp(),
      }).whenComplete(() {
        EasyLoading.dismiss();
        EasyLoading.showSuccess('Ana kategori eklendi!');
        setState(() {
          mainCategoryName = null;
          _mainCategoryFormKey.currentState!.reset();
        });
      });
    } else {
      EasyLoading.dismiss();
    }
  }

  // Alt kategori ekleme
  uploadSubCategory() async {
    EasyLoading.show();
    if (_subCategoryFormKey.currentState!.validate()) {
      if (_image == null) {
        EasyLoading.dismiss();
        EasyLoading.showError('Lütfen bir fotoğraf seçin!');
        return;
      }
      if (selectedMainCategoryId == null) {
        EasyLoading.dismiss();
        EasyLoading.showError('Lütfen bir ana kategori seçin!');
        return;
      }
      String imageUrl = await _upLoadCategoryBannerToStorage(_image);
      await _firestore.collection('categories').doc(fileName).set({
        'image': imageUrl,
        'categoryName': subCategoryName,
        'mainCategoryId': selectedMainCategoryId,
        'createdAt': FieldValue.serverTimestamp(),
      }).whenComplete(() {
        EasyLoading.dismiss();
        EasyLoading.showSuccess('Alt kategori eklendi!');
        setState(() {
          _image = null;
          fileName = null;
          subCategoryName = null;
          selectedMainCategoryId = null;
          _subCategoryFormKey.currentState!.reset();
        });
      });
    } else {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Başlık
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Kategori Yönetimi',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36,
              ),
            ),
          ),
          Divider(
            color: Colors.blueGrey,
          ),

          // Ana Kategori Ekleme Bölümü
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Form(
              key: _mainCategoryFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ana Kategori Ekle',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          onChanged: (value) {
                            mainCategoryName = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ana kategori adı boş olamaz';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Ana Kategori Adı',
                            hintText: 'Örn: Nakliyete ve Depolama',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        onPressed: uploadMainCategory,
                        child: Text(
                          'Ana Kategori Kaydet',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 24),

          // Alt Kategori Ekleme Bölümü
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Form(
              key: _subCategoryFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alt Kategori Ekle',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      // Ana Kategori Seçimi
                      StreamBuilder<QuerySnapshot>(
                        stream:
                            _firestore.collection('mainCategories').snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return SizedBox(
                              width: 250,
                              child: CircularProgressIndicator(),
                            );
                          }
                          List<DropdownMenuItem<String>> items = [];
                          for (var doc in snapshot.data!.docs) {
                            items.add(
                              DropdownMenuItem(
                                value: doc.id,
                                child: Text(doc['name'] ?? ''),
                              ),
                            );
                          }
                          return Container(
                            width: 250,
                            child: DropdownButtonFormField<String>(
                              value: selectedMainCategoryId,
                              decoration: InputDecoration(
                                labelText: 'Ana Kategori Seç',
                                border: OutlineInputBorder(),
                              ),
                              items: items,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ana kategori seçiniz';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  selectedMainCategoryId = value;
                                });
                              },
                            ),
                          );
                        },
                      ),

                      // Alt Kategori Adı
                      SizedBox(
                        width: 250,
                        child: TextFormField(
                          onChanged: (value) {
                            subCategoryName = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Alt kategori adı boş olamaz';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Alt Kategori Adı',
                            hintText: 'Örn: Nakliye',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),

                      // Fotoğraf Yükleme
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 140,
                            width: 140,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: _image != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image.memory(
                                      _image,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Center(
                                    child: Icon(
                                      Icons.image,
                                      size: 50,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _pickImage,
                            child: Text('Fotoğraf Yükle'),
                          ),
                        ],
                      ),

                      // Kaydet Butonu
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                          ),
                          onPressed: uploadSubCategory,
                          child: Text(
                            'Alt Kategori Kaydet',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(
              height: 10,
              color: Colors.blueAccent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                'Kategoriler',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          CategoryWidget(),
        ],
      ),
    );
  }
}
