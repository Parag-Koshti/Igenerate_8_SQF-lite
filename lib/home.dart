import 'package:flutter/material.dart';
import 'databasehelper.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  get itemId => null;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

bool updateflag = false;

class _MyHomePageState extends State<MyHomePage> {
  int? idstore;
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  List<Map<String, dynamic>> dataList = [];
  void _saveData() async {
    final name = _nameController.text;
    final contact = _contactController.text;
    int insertId = await DatabaseHelper.insertItem(name, contact);
    List<Map<String, dynamic>> updateData = await DatabaseHelper.getData();
    setState(() {
      dataList = updateData;
      FocusScope.of(context).requestFocus(FocusNode());
    });
    _nameController.text = '';
    _contactController.text = '';
  }

  void _fatchItem() async {
    List<Map<String, dynamic>> itemList = await DatabaseHelper.getData();
    setState(() {
      dataList = itemList;
    });
  }

  // void fetchData() async {
  //   Map<String, dynamic>? data =
  //       await DatabaseHelper.getSingleData(itemId);
  //   if (data != null) {
  //     _nameController.text = data['name'].toString();
  //     _contactController.text = data['contact'].toString();
  //   }
  // }

  void _delete(int ConId) async {
    int id = await DatabaseHelper.deleteData(ConId);
    List<Map<String, dynamic>> updateData = await DatabaseHelper.getData();
    setState(() {
      dataList = updateData;
    });
  }

  Future<void> _updateData({int? id}) async {
    Map<String, dynamic> data = {
      'name': _nameController.text,
      'contact': _contactController.text,
    };
    await DatabaseHelper.updateData(id!, data);
    //Navigator.pop(context, true);
  }

  @override
  void initState() {
    //fetchData();
    _fatchItem();
    //updateData = await DatabaseHelper.getData();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('IGContact',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    maxLength: 20,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        hintText: 'Name',
                        label: const Text("Name "),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                  TextFormField(
                    controller: _contactController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: InputDecoration(
                        hintText: 'Contact',
                        label: const Text("Contact No"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(updateflag == false
                              ? 'Saved Successfully'
                              : 'Updated successfully'),
                          action: SnackBarAction(
                            label: " ",
                            onPressed: () {
                              _nameController.text = '';
                              _contactController.text = '';
                            },
                          ),
                        ));
                        updateflag == false
                            ? _saveData()
                            : _updateData(id: idstore).then((result) {
                                _fatchItem();
                                _nameController.clear();
                                _contactController.clear();
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                //fetchData();
                              });
                      },
                      child: Text(updateflag == false ? 'Save' : 'Update'))
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black)),
                    child: ListTile(
                      title: Text(
                        dataList[index]['name'],
                        style: const TextStyle(fontSize: 20),
                      ),
                      subtitle: Text(dataList[index]['contact']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              _nameController.text = dataList[index]['name'];
                              _contactController.text =
                                  dataList[index]['contact'];
                              setState(() {
                                updateflag = true;
                              });
                              idstore = dataList[index]['id'];
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Alert !"),
                                      content: const Text(
                                          "Do you want to delete this contact ?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              _delete(dataList[index]['id']);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('yes')),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('no'))
                                      ],
                                    );
                                  });
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
