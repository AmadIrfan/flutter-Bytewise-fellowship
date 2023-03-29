import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/theme_changer.dart';
import 'model/product.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController prController = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ProductItem pr = Provider.of<ProductItem>(context);
    ThemeChanger themeChanger = Provider.of<ThemeChanger>(context);
    List<Product> item = pr.item;
    return Scaffold(
      appBar: AppBar(
        title: const Text("CRUD using Provider"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                    content: SizedBox(
                  height: 300,
                  child: Column(
                    children: [
                      RadioListTile<ThemeMode>(
                        title: const Text('Light Mode'),
                        value: ThemeMode.light,
                        groupValue: themeChanger.themeMode,
                        onChanged: themeChanger.setThemeMode,
                      ),
                      RadioListTile<ThemeMode>(
                        title: const Text('Dark Mode'),
                        value: ThemeMode.dark,
                        groupValue: themeChanger.themeMode,
                        onChanged: themeChanger.setThemeMode,
                      ),
                      RadioListTile<ThemeMode>(
                        title: const Text('System Mode'),
                        value: ThemeMode.system,
                        groupValue: themeChanger.themeMode,
                        onChanged: themeChanger.setThemeMode,
                      ),
                    ],
                  ),
                )),
              );
            },
            icon: const Icon(Icons.light),
          )
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: item.isEmpty
            ? const Center(
                child: Text('List is empty'),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: item.length,
                      itemBuilder: (context, index) => Dismissible(
                        key: ValueKey(item[index].id!),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (direction) {
                          pr.deleteItem(
                            item[index].id!,
                          );
                        },
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              child:
                                  Text(item[index].price!.toStringAsFixed(2)),
                            ),
                            title: Text(
                              item[index].name!,
                            ),
                            subtitle: Text(item[index].description!),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.all(0),
                    child: Container(
                      width: double.infinity,
                      height: 75,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'total Price ${pr.totalPrice}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addItems,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void addItems() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          left: 3,
          top: 3,
          right: 3,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    label: Text('Name'),
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'field id empty';
                    }
                    return null;
                  },
                ),
                TextFormField(
                    controller: desController,
                    decoration: const InputDecoration(
                      label: Text('Description'),
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'field id empty';
                      }
                      return null;
                    }),
                TextFormField(
                    controller: prController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      label: Text('Price'),
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'field id empty';
                      }
                      return null;
                    }),
                ElevatedButton(
                  onPressed: saveItems,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveItems() {
    bool isValid = _form.currentState!.validate();
    if (isValid) {
      _form.currentState!.save();
      ProductItem pI = Provider.of<ProductItem>(context, listen: false);
      int id = pI.listLength;
      Product pro = Product(
        id,
        nameController.text,
        desController.text,
        double.parse(
          prController.text,
        ),
      );
      pI.addItemInList(pro);
      Navigator.pop(context, true);
    }
  }
}
