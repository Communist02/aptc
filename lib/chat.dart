import 'package:flutter/material.dart';
import 'classes.dart';
import 'package:intl/intl.dart';
import 'global.dart';
import 'firebase.dart';

class ChatPage extends StatefulWidget {
  final Contact contact;

  const ChatPage(this.contact, {Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState(contact);
}

class _ChatPageState extends State<ChatPage> {
  final Contact contact;
  bool isChanged = false;
  FocusNode focusNode = FocusNode();
  TextEditingController textController = TextEditingController();
  final CloudStore _cloudStore = CloudStore();

  _ChatPageState(this.contact);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: InkWell(
          onTap: () {},
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                height: 32,
                width: 32,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: const Icon(
                    Icons.person_outline,
                    size: 32,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  contact.nickname,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              const PopupMenuItem(child: Text('Поиск')),
              const PopupMenuItem(child: Text('Очистить чат')),
            ];
          }),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(bottom: 30),
        child: ChatView(contact.chat),
      ),
      bottomSheet: Container(
        color: Theme.of(context).cardColor,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: textController,
                focusNode: focusNode,
                minLines: 1,
                maxLines: 20,
                decoration: const InputDecoration(
                    hintText: 'Сообщение', border: InputBorder.none),
                onChanged: (value) {
                  setState(() {
                    value.isEmpty ? isChanged = false : isChanged = true;
                  });
                },
              ),
            ),
            isChanged
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        final Message message = Message(
                          account.id!,
                          contact.id,
                          textController.value.text,
                          DateTime.now(),
                        );
                        _cloudStore.addMessage(message);
                        contact.chat.add(message);
                        textController.clear();
                        isChanged = false;
                        focusNode.unfocus();
                      });
                    },
                    icon: const Icon(Icons.send),
                  )
                : const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class MessageView extends StatelessWidget {
  final Message message;

  const MessageView(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isYou = message.idSender == account.id;
    return InkWell(
      onLongPress: () {},
      child: Row(
        mainAxisAlignment:
            isYou ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Card(
              color: isYou ? Colors.deepPurpleAccent : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(13),
                  topRight: const Radius.circular(13),
                  bottomLeft: isYou ? const Radius.circular(13) : Radius.zero,
                  bottomRight: isYou ? Radius.zero : const Radius.circular(13),
                ),
              ),
              margin: EdgeInsets.only(
                top: 6,
                bottom: 6,
                left: (isYou ? 100 : 6),
                right: (isYou ? 6 : 100),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      message.value,
                      style: TextStyle(
                        color: isYou ? Colors.white : null,
                      ),
                    ),
                    Text(
                      DateFormat('HH:mm').format(message.dateTime),
                      style: TextStyle(
                        fontSize: 12,
                        color: isYou
                            ? Colors.white
                            : Theme.of(context).textTheme.caption!.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatView extends StatelessWidget {
  final List<Message> chat;

  const ChatView(this.chat, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget dateCard(DateTime date) {
      String text = '';
      DateTime dateNow = DateTime.now();
      if (date.day == dateNow.day &&
          date.month == dateNow.month &&
          date.year == dateNow.year) {
        text = 'Сегодня';
      } else if (date.day + 1 == dateNow.day &&
          date.month == dateNow.month &&
          date.year == dateNow.year) {
        text = 'Вчера';
      } else if (date.year == dateNow.year) {
        text = DateFormat('dd.MM').format(date);
      } else {
        text = DateFormat('dd.MM.yyyy').format(date);
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.caption!.color),
                ),
              ),
            ),
          ),
        ],
      );
    }

    List<Widget> messagesList() {
      List<Widget> list = [];
      if (chat.isNotEmpty) {
        DateTime dateTMP = chat[0].dateTime;
        list.add(dateCard(dateTMP));

        for (final Message message in chat) {
          if (dateTMP.day != message.dateTime.day ||
              dateTMP.month != message.dateTime.month ||
              dateTMP.year != message.dateTime.year) {
            list.add(dateCard(message.dateTime));
            dateTMP = message.dateTime;
          }
          list.add(MessageView(message));
        }
      }
      return list.reversed.toList();
    }

    return Scrollbar(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 50),
        reverse: true,
        children: messagesList(),
      ),
    );
  }
}
