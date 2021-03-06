import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'classes.dart';
import 'global.dart';
import 'chat.dart';
import 'firebase.dart';

bool _isUpdate = false;

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: textController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            icon: const Icon(Icons.search_outlined, color: Colors.white),
            hintText: 'Поиск',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white.withAlpha(200)),
          ),
          onChanged: (value) => setState(() {}),
        ),
        actions: textController.value.text != ''
            ? [
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      textController.clear();
                    });
                  },
                )
              ]
            : null,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isUpdate = true;
          });
        },
        child: const Icon(Icons.update_outlined),
      ),
      body: contactsView(textController.value.text),
    );
  }
}

class ContactView extends StatelessWidget {
  final Contact contact;

  const ContactView(this.contact, {Key? key}) : super(key: key);

  String dateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    final DateTime timeNow = DateTime.now();
    final Duration difference = timeNow.difference(dateTime);
    if (difference.inMinutes < 1) {
      return '${difference.inSeconds} сек. назад';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} мин. назад';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} ч. назад';
    } else if (difference.inDays < 2) {
      return 'Вчера';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} д. назад';
    } else {
      return DateFormat('dd.MM.yyyy').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    Message? lastMessage = contact.lastMessage();

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(contact),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: const Icon(
                Icons.person_outline,
                size: 56,
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            contact.nickname,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          dateTime(lastMessage.dateTime),
                          style: TextStyle(
                            color: Theme.of(context).textTheme.caption!.color,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      lastMessage.value,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.caption!.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

FutureBuilder contactsView(String search) {
  final CloudStore cloudStore = CloudStore();

  return FutureBuilder(
    future: cloudStore.getContacts(),
    initialData: globalContacts,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      Widget build() {
        if (snapshot.hasError) {
          return const Center(child: Text('Ошибка'));
        } else {
          globalContacts = snapshot.data;
          return ListView.builder(
            key: const PageStorageKey('MyOrders'),
            itemCount: snapshot.data.contacts.length,
            itemBuilder: (context, int i) {
              if (search == '' ||
                  snapshot.data.contacts[i].nickname
                      .toLowerCase()
                      .contains(search.toLowerCase())) {
                return ContactView(snapshot.data.contacts[i]);
              } else {
                return Container();
              }
            },
          );
        }
      }

      switch (snapshot.connectionState) {
        case ConnectionState.none:
          return const Center(child: Text('Нет сети'));
        case ConnectionState.waiting:
          if (_isUpdate || globalContacts.contacts.isEmpty) {
            _isUpdate = false;
            return const Center(child: CircularProgressIndicator());
          } else {
            return build();
          }
        case ConnectionState.active:
          return const Center(child: CircularProgressIndicator());
        case ConnectionState.done:
          return build();
      }
    },
  );
}
