import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String searchValue = '';

  void onPressedSearch() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    cursorColor: Colors.black,
                    style: const TextStyle(color: Colors.black),
                    onChanged: (String value) {
                      searchValue = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Encuentra restaurantes por ciudad',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.blueGrey,
                    size: 30.0,
                  ),
                  onPressed: onPressedSearch,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('restaurantes')
                  .snapshots(),
              builder: (context, querySnapshop) {
                if (querySnapshop.connectionState == ConnectionState.active) {
                  List<QueryDocumentSnapshot<Map<String, dynamic>>> items =
                      querySnapshop.data!.docs;

                  List<QueryDocumentSnapshot<Map<String, dynamic>>>
                      filteredItems = [];
                  if (searchValue.isNotEmpty && searchValue.length > 3) {
                    filteredItems = items.where((element) {
                      return (element['ciudad'] as String)
                          .toLowerCase()
                          .contains(searchValue.toLowerCase());
                    }).toList();
                  } else {
                    filteredItems = List.from(items);
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) => Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.all(15),
                      elevation: 10,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            contentPadding:
                                const EdgeInsets.fromLTRB(15, 10, 25, 0),
                            title: Text(
                              filteredItems[index]['nombre'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                                '${filteredItems[index]['direccion']}, ${filteredItems[index]['ciudad']}'),
                            leading: const Icon(Icons.restaurant),
                            trailing: ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Image.network(
                                filteredItems[index]['imagen'],
                                height: 50.0,
                                width: 50.0,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  return progress == null
                                      ? child
                                      : const CircularProgressIndicator();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
