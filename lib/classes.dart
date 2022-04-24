class Ship {
  String name;
  String description;

  Ship(this.name, this.description);
}

class Client {
  String companyName = '';
  String contactPerson = '';
  String contactInformation = '';
  String address = '';
  String country = '';
  String manager = '';
  String numberOrders = '';

  Client();

  Client.fromMap(map) {
    companyName = map['companyName'];
    contactPerson = map['contactPerson'];
    contactInformation = map['contactInformation'];
    address = map['address'];
    country = map['country'];
    manager = map['manager'];
    numberOrders = map['numberOrders'];
  }

  Client.set(
    this.companyName,
    this.contactPerson,
    this.contactInformation,
    this.address,
    this.country,
    this.manager,
    this.numberOrders,
  );

  factory Client.clone(Client source) {
    return Client.set(
      source.companyName,
      source.contactPerson,
      source.contactInformation,
      source.address,
      source.country,
      source.manager,
      source.numberOrders,
    );
  }

  Map<String, String> toMap() {
    return {
      'companyName': companyName,
      'contactPerson': contactPerson,
      'contactInformation': contactInformation,
      'address': address,
      'country': country,
      'manager': manager,
      'numberOrders': numberOrders,
    };
  }
}

class Request {
  String id;
  String description;
  Map value;
  String idClient;
  String nameClient;
  DateTime dateTime = DateTime.now();

  Request(this.description, this.value, this.idClient, this.nameClient, this.dateTime, {this.id = ''});
}

class Message {
  String idSender;
  String idRecipient;
  String value;
  DateTime dateTime;

  Message(this.idSender, this.idRecipient, this.value, this.dateTime);
}

class Contact {
  String id;
  String nickname;
  List<Message> chat;

  Contact(this.id, this.nickname, this.chat);

  Message? lastMessage() {
    if (chat.isNotEmpty) {
      return chat[chat.length - 1];
    } else {
      return null;
    }
  }

  addMessage(String idSender, String value) {
    chat.add(Message(idSender, nickname, value, DateTime.now()));
  }

  void sortMessages() {
     chat.sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }
}

class Contacts {
  List<Contact> contacts;

  Contacts(this.contacts);

  bool addMessage(Message message, bool isYou) {
    for (Contact contact in contacts) {
      if (isYou && message.idRecipient == contact.id) {
        contact.chat.add(message);
        return true;
      }
      else if (message.idSender == contact.id) {
        contact.chat.add(message);
        return true;
      }
    }
    return false;
  }

  void addContact(Message message, String id, String name) {
    contacts.add(Contact(id, name, [message]));
  }

  void sortMessages() {
    for (int i = 0; i < contacts.length; i++) {
      contacts[i].chat.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    }
  }
}

class Account {
  String? id;
  String? email;
  String nickname = '';
  String avatar = '';

  void clear() {
    id = null;
    email = null;
    nickname = '';
    avatar = '';
  }
}

class SearchHistory {
  List<String> history = [];

  SearchHistory(this.history);

  void clear() {
    history.clear();
  }

  void add(String value) {
    if (value.isEmpty) return;
    for (int i = 0; i < history.length; i++) {
      if (history[i] == value) {
        history.removeAt(i);
        history.insert(0, value);
        return;
      }
    }
    history.insert(0, value);
    if (history.length > 10) {
      history.removeAt(history.length - 1);
    }
  }

  void delete(String value) {
    for (int i = 0; i < history.length; i++) {
      if (history[i] == value) {
        history.removeAt(i);
      }
    }
  }
}

