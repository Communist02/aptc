import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'chat.dart';
import 'classes.dart';
import 'global.dart';
import 'firebase.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({Key? key}) : super(key: key);

  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  int number = 0;
  final CloudStore _cloudStore = CloudStore();

  void chat(String id) async {
    final contact = await _cloudStore.getContact(id);
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(contact),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> requestView(Map request) {
      List<Widget> requests = [
        Container(
          margin: const EdgeInsets.all(10),
          child: Text(
            globalRequests[number].description,
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
          ),
        ),
      ];
      for (final name in request.keys) {
        requests.add(
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              name + ': ' + request[name],
              style: const TextStyle(fontSize: 24),
            ),
          ),
        );
      }
      return requests;
    }

    Widget requestsView() {
      return Row(
        children: [
          Flexible(
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 3,
              shape: const RoundedRectangleBorder(),
              child: SizedBox(
                width: 400,
                child: ListView.builder(
                  key: const PageStorageKey('Requests'),
                  itemCount: globalRequests.length,
                  itemBuilder: (context, int i) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          number = i;
                        });
                      },
                      child: RequestView(globalRequests[i], number == i),
                    );
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Card(
                      margin: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            const Icon(Icons.person_outlined),
                            Text(
                              globalRequests[number].nameClient,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        chat(globalRequests[number].idClient);
                      },
                      child: const Text('Написать'),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView(
                    children: requestView(globalRequests[number].value),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return FutureBuilder(
      future: _cloudStore.getRequests(),
      initialData: globalRequests,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Center(child: Text('Нет сети'));
          case ConnectionState.waiting:
          //return const Center(child: CircularProgressIndicator());
          case ConnectionState.active:
          //return const Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            if (snapshot.hasError) {
              return const Center(child: Text('Ошибка'));
            } else {
              globalRequests = snapshot.data;
              if (snapshot.data.length == 0) {
                return const Center(child: Text('Нет заявок'));
              } else {
                return requestsView();
              }
            }
        }
      },
    );
  }
}

class RequestView extends StatelessWidget {
  final Request request;
  final bool isActive;

  const RequestView(this.request, this.isActive, {Key? key}) : super(key: key);

  String dateTime(DateTime dateTime) {
    final DateTime timeNow = DateTime.now();
    final Duration difference = timeNow.difference(dateTime);
    if (difference.inDays < 1) {
      return DateFormat('HH:mm').format(dateTime);
    } else if (dateTime.year == timeNow.year) {
      return DateFormat('dd.MM').format(dateTime);
    } else {
      return DateFormat('dd.MM.yyyy').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isActive
          ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
          : null,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  request.nameClient,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  dateTime(request.dateTime),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.caption!.color,
                  ),
                ),
              ],
            ),
          ),
          Text(
            request.description,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
