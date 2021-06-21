import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String searchValue = '';
  bool isVisibleLocation = false;
  LocationData? loc;
  Location location = Location();

  void onPressedSearch() async {
    setState(() {});
    await FirebaseFirestore.instance.collection('records').doc().set({
      'value': searchValue,
      'createdAt': DateTime.now().millisecondsSinceEpoch
    });
  }

  void onPressFloating() async {
    bool _serviceEnabled;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    loc = await location.getLocation();
    isVisibleLocation = true;
    setState(() {});
  }

  Stream<List<DocumentSnapshot<Map<String, dynamic>>>> showNearbyCompanies() {
    final geo = Geoflutterfire();
    GeoFirePoint center =
        geo.point(latitude: loc!.latitude!, longitude: loc!.longitude!);
    var collectionReference =
        FirebaseFirestore.instance.collection('restaurantes');
    double radius = 5;
    String field = 'ubicacion';
    return geo
        .collection(collectionRef: collectionReference)
        .within(center: center, radius: radius, field: field);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.location_on),
        onPressed: onPressFloating,
      ),
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
          isVisibleLocation
              ? Expanded(
                  flex: 1,
                  child: StreamBuilder<
                      List<DocumentSnapshot<Map<String, dynamic>>>>(
                    stream: showNearbyCompanies(),
                    builder: (context, querySnapshop) {
                      if (querySnapshop.connectionState ==
                          ConnectionState.active) {
                        List<Map<String, dynamic>> filteredItems = [];
                        if (querySnapshop.data!.isNotEmpty) {
                          filteredItems = querySnapshop.data!
                              .map((e) => e.data()!)
                              .toList();
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
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
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
                                      loadingBuilder:
                                          (context, child, progress) {
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
                )
              : Expanded(
                  flex: 1,
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('restaurantes')
                        .snapshots(),
                    builder: (context, querySnapshop) {
                      if (querySnapshop.connectionState ==
                          ConnectionState.active) {
                        List<QueryDocumentSnapshot<Map<String, dynamic>>>
                            items = querySnapshop.data!.docs;

                        List<QueryDocumentSnapshot<Map<String, dynamic>>>
                            filteredItems = [];
                        if (searchValue.isNotEmpty && searchValue.length > 2) {
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
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
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
                                      loadingBuilder:
                                          (context, child, progress) {
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
