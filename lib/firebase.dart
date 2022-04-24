import 'package:firedart/firestore/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'classes.dart';
import 'global.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<bool> signEmailPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (_) {}
    if (_auth.currentUser == null) return false;
    account.id = _auth.currentUser?.uid;
    account.email = _auth.currentUser?.email;
    //final CollectionReference accounts = firestore.collection('accounts');
    //final acc = await accounts.doc(account.id).get();
    //account.nickname = acc['nickname'];
    return true;
  }

  Future<bool> registerEmailPassword(
      String email, String password, String nickname) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (_) {}
    if (_auth.currentUser == null) return false;
    account.id = _auth.currentUser?.uid;
    account.email = _auth.currentUser?.email;

    //final CollectionReference accounts = firestore.collection('accounts');
    //accounts.doc(account.id).set({'nickname': nickname});
    account.nickname = nickname;
    return true;
  }

  Future<bool> resetPassword(String email) async {
    _auth.sendPasswordResetEmail(email: email);
    return true;
  }

  void sign() async {
    if (_auth.currentUser != null) {
      account.id = _auth.currentUser!.uid;
      account.email = _auth.currentUser!.email;
      //final CollectionReference accounts = firestore.collection('accounts');
      //final acc = await accounts.doc(account.id).get();
      //account.nickname = acc['nickname'];
    }
  }

  Future signOut() async {
    await _auth.signOut();
  }

  bool checkSign() {
    return _auth.currentUser != null;
  }

  String? getId() {
    return _auth.currentUser?.uid;
  }
}

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

  Future<Contacts> getContacts() async {
    final chatsBase = firestore.collection('messages');
    final accountsBase = firestore.collection('accounts');
    final firstMessagesResult = await chatsBase
        .where('idSender', isEqualTo: account.id.toString())
        .get();
    final secondMessagesResult = await chatsBase
        .where('idRecipient', isEqualTo: account.id.toString())
        .get();
    Contacts contacts = Contacts([]);
    for (final message in firstMessagesResult) {
      final messageTMP = Message(
        message['idSender'],
        message['idRecipient'],
        message['value'],
        message['dateTime'],
      );
      if (!contacts.addMessage(messageTMP, true)) {
        final acc = await accountsBase.document(messageTMP.idRecipient).get();
        contacts.addContact(messageTMP, messageTMP.idRecipient, acc['nickname']);
      }
    }
    for (final message in secondMessagesResult) {
      final messageTMP = Message(
        message['idSender'],
        message['idRecipient'],
        message['value'],
        message['dateTime'],
      );
      if (!contacts.addMessage(messageTMP, false)) {
        final acc = await accountsBase.document(messageTMP.idSender).get();
        contacts.addContact(
            messageTMP, messageTMP.idSender, acc['nickname']);
      }
    }
    contacts.sortMessages();
    return contacts;
  }

  Future<Contact> getContact(String idContact) async {
    final chatsBase = firestore.collection('messages');
    final accountsBase = firestore.collection('accounts');
    final acc = await accountsBase.document(idContact).get();
    Contact contact = Contact(idContact, acc['nickname'], []);
    final firstMessagesResult = await chatsBase
        .where('idSender', isEqualTo: account.id.toString())
        .where('idRecipient', isEqualTo: idContact)
        .get();
    final secondMessagesResult = await chatsBase
        .where('idSender', isEqualTo: idContact)
        .where('idRecipient', isEqualTo: account.id.toString())
        .get();
    for (final message in firstMessagesResult) {
      final messageTMP = Message(
        message['idSender'],
        message['idRecipient'],
        message['value'],
        message['dateTime'],
      );
      contact.chat.add(messageTMP);
    }
    for (final message in secondMessagesResult) {
      final messageTMP = Message(
        message['idSender'],
        message['idRecipient'],
        message['value'],
        message['dateTime'],
      );
      contact.chat.add(messageTMP);
    }
    contact.sortMessages();
    return contact;
  }

  Future<bool> addMessage(Message message) async {
    final messagesBase = firestore.collection('messages');
    messagesBase.add({
      'idSender': message.idSender,
      'idRecipient': message.idRecipient,
      'value': message.value,
      'dateTime': message.dateTime,
    });
    return true;
  }
}
