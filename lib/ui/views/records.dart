import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecordsView extends StatefulWidget {
  const RecordsView({Key? key}) : super(key: key);

  @override
  _RecordsViewState createState() => _RecordsViewState();
}

class _RecordsViewState extends State<RecordsView> {
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
          Expanded(
            flex: 1,
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream:
                  FirebaseFirestore.instance.collection('records').snapshots(),
              builder: (context, querySnapshop) {
                if (querySnapshop.connectionState == ConnectionState.active) {
                  List<QueryDocumentSnapshot<Map<String, dynamic>>> items =
                      querySnapshop.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
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
                              items[index]['value'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(DateFormat('dd/MM/yyyy hh:mm aaa')
                                .format(DateTime.fromMillisecondsSinceEpoch(
                                    items[index]['createdAt']))),
                            leading: const Icon(Icons.search),
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
