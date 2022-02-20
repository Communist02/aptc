import 'package:firedart/firedart.dart';
import 'dart:convert';
import 'classes.dart';

class CloudStore {
  Firestore firestore = Firestore('aptc-base');

  Future<List<Request>> getRequests() async {
    final requestsBase = firestore.collection('requests');
    final result = await requestsBase.get();
    List<Request> requests = [];
    for (var request in result) {
      requests.add(
        Request(
          request['description'],
          jsonDecode(request['value']),
          request['idAccount'].toString(),
          request['nickname'],
          request['dateTime'],
        ),
      );
    }
    requests.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return requests;
  }
}
