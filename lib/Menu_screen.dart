import 'dart:io';
import 'dart:math';
// import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
// import 'dart:io';

import 'package:file_selector/file_selector.dart';
// import 'package:rms/Hive/category.dart';
import 'Hive/category.dart';

import "Hive/menu.dart";

import 'package:file_selector_macos/file_selector_macos.dart';
import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:rms/Hive/menu.dart';
import 'package:rms/boxes.dart';
// import 'package:http/http.dart' as http;

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  // TextEditingController imgController = TextEditingController();

  TextEditingController upnameController = TextEditingController();
  TextEditingController uppriceController = TextEditingController();
  TextEditingController upcategoryController = TextEditingController();
  // TextEditingController upimgController = TextEditingController();

  TextEditingController catNameController = TextEditingController();
  // TextEditingController catImgController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCategory();
    // boxMenus = await Hive.openBox<Menu>('menuBox');

    // fetchData();

    // Refresh menu items every 1 second
    // Timer.periodic(Duration(seconds: 1), (Timer timer) {
    //   fetchData();
    // });
  }

  @override
  void dispose() {
    super.dispose();
    // boxMenus.close();
  }

  void _getCategory() {
    String? name;
    for (int i = 0; i < boxCategorys.length; i++) {
      MenuCategory? item = boxCategorys.getAt(i);
      name = item!.name;
      list.add(name!);
      print(name);
    }
  }

  List<String> list = <String>[];
  List<String> sizeList = ['S', 'N', 'L'];

  String? selectedCat;
  String? selectedSize = 'N';

  Future<void> _showMyDialog(Function() updateMenuState) async {
    // Function updateMenu()
    String? imagePath;
    String? baseName;

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add new Menu item'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(hintText: 'Name'),
                    ),
                    TextField(
                      controller: priceController,
                      decoration: InputDecoration(hintText: 'Price'),
                    ),
                    DropdownButton(
                      hint: Text('Category'),
                      isExpanded: true,
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: selectedCat,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCat = newValue;
                          print(selectedCat);
                        });
                      },
                    ),
                    DropdownButton<String>(
                      hint: Text('Size'),
                      value: selectedSize,
                      onChanged: (newValue) {
                        setState(() {
                          selectedSize = newValue!;
                        });
                      },
                      items: sizeList.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                    ),
                    GestureDetector(
                      onTap: () async {
                        imagePath = await pickAndSaveImage();
                        baseName = path.basename(imagePath!);
                        setState(() {
                          // Update imagePath and baseName
                        });
                      },
                      child: Row(
                        children: [
                          Icon(Icons.image_rounded,
                              color: baseName != null
                                  ? Colors.greenAccent
                                  : Colors.redAccent),
                          SizedBox(width: 10),
                          Text(imagePath != null ? baseName! : 'Browse Image'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Save'),
                  onPressed: () {
                    setState(() {
                      boxMenus.put(
                        'key_${nameController.text}',
                        Menu(
                          name: nameController.text,
                          price: double.parse(priceController.text),
                          category: selectedCat,
                          size: selectedSize,
                          img: imagePath,
                        ),
                      );
                    });

                    nameController.clear();
                    priceController.clear();
                    categoryController.clear();
                    // imgController.clear();

                    Navigator.of(context).pop();

                    updateMenuState();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> updateMenu(int index, Function() updateMenuState) async {
    String? imagePath;
    String? baseName;
    String? size;

    String upCat = '';
    toUpdateMenu = boxMenus.getAt(index);
    print(toUpdateMenu?.name);

    upnameController.text = toUpdateMenu?.name ?? '';
    uppriceController.text = toUpdateMenu?.price.toString() ?? '';
    // upimgController.text = toUpdateMenu?.img ?? '';
    imagePath = toUpdateMenu?.img ?? '';
    size = toUpdateMenu!.size ?? '';

    baseName = path.basename(imagePath);

    // upcategoryController.
    upCat = toUpdateMenu?.category ?? '';

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Update Menu item'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      controller: upnameController,
                      decoration: InputDecoration(hintText: 'Name'),
                    ),
                    TextField(
                      controller: uppriceController,
                      decoration: InputDecoration(hintText: 'Price'),
                    ),
                    DropdownButton(
                      hint: Text('Category'),
                      isExpanded: true,
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: upCat,
                      onChanged: (String? newValue) {
                        setState(() {
                          upCat = newValue!;
                          print("selectedCat$selectedCat");
                          print('upcat$upCat');
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        imagePath = await pickAndSaveImage();
                        baseName = path.basename(imagePath!);
                        setState(() {
                          // Update imagePath and baseName
                        });
                      },
                      child: Row(
                        children: [
                          Icon(Icons.image_rounded,
                              color: baseName != null
                                  ? Colors.greenAccent
                                  : Colors.redAccent),
                          SizedBox(width: 10),
                          Text(imagePath != null ? baseName! : 'Browse Image'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Update'),
                  onPressed: () {
                    setState(() {
                      boxMenus.putAt(
                        index,
                        Menu(
                          name: upnameController.text,
                          price: double.parse(uppriceController.text),
                          size: size,
                          category: upCat,
                          img: imagePath,
                        ),
                      );
                    });

                    upnameController.clear();
                    uppriceController.clear();
                    upcategoryController.clear();
                    // upimgController.clear();

                    Navigator.of(context).pop();
                    updateMenuState();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showCatDialog() async {
    String? imagePath;
    String? baseName;
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add new Category'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      controller: catNameController,
                      decoration: InputDecoration(hintText: 'Name'),
                    ),
                    // TextField(
                    //   onTap: () async {
                    //     imagePath = await pickAndSaveImage();
                    //     final baseName = path.basename(imagePath!);
                    //     setState(() {
                    //       imagePath = imagePath;
                    //     });
                    //   },
                    //   controller: catImgController,
                    //   decoration: InputDecoration(
                    //     hintText: 'Browse Image',
                    //     prefixIcon: Icon(Icons.image_rounded),
                    //   ),
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        imagePath = await pickAndSaveImage();
                        baseName = path.basename(imagePath!);
                        setState(() {
                          // imagePath = imagePath;
                        });
                      },
                      child: Row(
                        children: [
                          Icon(Icons.image_rounded,
                              color: baseName != null
                                  ? Colors.greenAccent
                                  : Colors.redAccent),
                          SizedBox(
                            width: 10,
                          ),
                          Text(imagePath != null ? baseName! : 'Browse Image'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Save'),
                  onPressed: () {
                    setState(() {
                      boxCategorys.put(
                          'key_${catNameController.text}',
                          MenuCategory(
                              name: catNameController.text, img: imagePath));
                    });

                    print('Category added');

                    catNameController.clear();
                    // catImgController.clear();

                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Future<String?> browseImage() async {
  //   const typeGroup =
  //       XTypeGroup(label: 'Images', extensions: ['jpg', 'jpeg', 'png']);
  //   final file = await openFile(acceptedTypeGroups: [typeGroup]);

  //   if (file == null) {
  //     return null;
  //   }

  //   return file.path;
  // }

  // Future<String> browseImage() async {
  //   final typeGroup =
  //       XTypeGroup(label: 'images', extensions: ['jpg', 'jpeg', 'png']);
  //   final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);

  //   if (file != null) {
  //     return file.path;
  //     // String imageName = path.basename(imagePath);
  //     // Use the imagePath as needed
  //     // print('Selected image: $imageName');
  //   } else {
  //     return '';
  //     // User canceled the file selection
  //     print('No image selected');
  //   }
  // }

  // import 'dart:io';

  Menu? toUpdateMenu;

  Future<String?> pickAndSaveImage() async {
    final typeGroup = XTypeGroup(label: 'images', extensions: ['jpg', 'png']);
    final file = await openFile(acceptedTypeGroups: [typeGroup]);

    if (file != null) {
      final fileName = file.name;
      final appDir = await path_provider.getApplicationDocumentsDirectory();
      final savedImagePath = '${appDir.path}/$fileName';

      final imageFile = File(savedImagePath);
      await imageFile.writeAsBytes(await file.readAsBytes());

      return imageFile.path;
    }

    return null;
  }

  void updateMenuState() {
    setState(() {});
    // return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Items'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Center(
              child: GestureDetector(
                  onTap: () {
                    _showCatDialog();
                  },
                  child: Text('Add Category')),
            ),
          )
        ],
      ),
      body: boxMenus == null
          ? Center(
              child:
                  CircularProgressIndicator()) // Show a loading indicator while fetching data
          : Padding(
              padding: const EdgeInsets.only(top: 50),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6, // Adjust the number of columns as needed
                  crossAxisSpacing: 15.0, // Set the spacing between columns
                  mainAxisSpacing: 15.0, // Set the spacing between rows
                ),
                itemCount: boxMenus.length,
                itemBuilder: (context, index) {
                  // ignore: non_constant_identifier_names
                  Menu? menu = boxMenus.getAt(index);

                  return GestureDetector(
                    onDoubleTap: () {
                      setState(() {
                        boxMenus.deleteAt(index);
                        // boxMenus.deleteAt(index);
                      });
                    },
                    onLongPress: () {
                      print(index);
                      // print(toUpdateMenu?.name);
                      updateMenu(index, updateMenuState);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          Expanded(
                              child: Image.file(
                            File(menu!.img!),
                            fit: BoxFit.cover,
                          )),
                          ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                            ),
                            hoverColor: Color.fromARGB(255, 35, 35, 35),
                            tileColor: Colors.white30,
                            title: Text(
                              menu!.name ?? 'No Title',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "Price :${menu.price}",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.normal),
                            ),
                            trailing: Column(
                              children: [
                                Text(
                                  menu.category!,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w100),
                                ),
                                Text("Size :${menu.size}"),
                              ],
                            ),
                            onTap: () {
                              print(menu.img);
                              // Handle onTap event
                              print('Tapped item at index $index');
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showMyDialog(updateMenuState);
        },
        backgroundColor: Color.fromARGB(255, 0, 115, 255),
        child: Icon(Icons.add),
      ),
    );
  }
}
