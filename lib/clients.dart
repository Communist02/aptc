import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'global.dart';
import 'dart:convert';

bool isEdit = false;
List<Map<String, String>> clients =
    globalClients.map((e) => Map<String, String>.from(e)).toList();
List<bool> selected =
    List<bool>.generate(globalClients.length, (int index) => false);

class ClientsPage extends StatefulWidget {
  const ClientsPage({Key? key}) : super(key: key);

  @override
  _ClientsPageState createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  void saveBase() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('clientsBase', jsonEncode(globalClients));
  }

  @override
  Widget build(BuildContext context) {
    List<DataCell> cells(Map<String, String> client) {
      final row = [
        client['companyName'],
        client['contactPerson'],
        client['contactInformation'],
        client['address'],
        client['country'],
        client['manager'],
        client['numberOrders'],
      ];
      setState(() {});
      List<DataCell> cells = [];
      for (int i = 0; i < row.length; i++) {
        cells.add(
          DataCell(
            isEdit
                ? TextField(
                    controller: TextEditingController(text: row[i] ?? ''),
                    style: const TextStyle(fontSize: 14),
                    onChanged: (value) {
                      switch (i) {
                        case 0:
                          client['companyName'] = value;
                          break;
                        case 1:
                          client['contactPerson'] = value;
                          break;
                        case 2:
                          client['contactInformation'] = value;
                          break;
                        case 3:
                          client['address'] = value;
                          break;
                        case 4:
                          client['country'] = value;
                          break;
                        case 5:
                          client['manager'] = value;
                          break;
                        case 6:
                          client['numberOrders'] = value;
                          break;
                      }
                    },
                  )
                : Text(row[i] ?? ''),
          ),
        );
      }
      return cells;
    }

    DataTable table = DataTable(
      border: TableBorder.all(color: Colors.grey.withOpacity(0.3)),
      columns: const [
        DataColumn(label: Text('????????????????\n????????????????')),
        DataColumn(label: Text('????????????????????\n????????')),
        DataColumn(label: Text('????????????????????\n????????????????????')),
        DataColumn(label: Text('??????????')),
        DataColumn(label: Text('????????????')),
        DataColumn(label: Text('????????????????')),
        DataColumn(label: Text('??????-????\n??????????????')),
      ],
      rows: List<DataRow>.generate(clients.length, (index) {
        return DataRow(
          selected: selected[index],
          onSelectChanged: (bool? value) {
            setState(() {
              selected[index] = value!;
            });
          },
          color: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return Theme.of(context).colorScheme.primary.withOpacity(0.08);
              }
              if (index.isEven) {
                return Colors.grey.withOpacity(0.1);
              }
              return null; // Use default value for other states and odd rows.
            },
          ),
          cells: cells(clients[index]),
        );
      }),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    clients.add({});
                    selected.add(false);
                  });
                },
                child: const Text('?????????? ????????????'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    globalClients = clients
                        .map((e) => Map<String, String>.from(e))
                        .toList();
                    saveBase();
                    isEdit = false;
                  });
                },
                child: const Text('??????????????????'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    clients = globalClients
                        .map((e) => Map<String, String>.from(e))
                        .toList();
                    selected = List<bool>.generate(
                        globalClients.length, (int index) => false);
                    isEdit = false;
                  });
                },
                child: const Text('??????????'),
              ),
            ),
            Switch(
              value: isEdit,
              onChanged: (bool value) => setState(() {
                isEdit = value;
              }),
            ),
            const Text('????????????????????????????'),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: isEdit
                    ? () {
                        setState(() {
                          for (int i = clients.length - 1; i >= 0; i--) {
                            if (selected[i]) {
                              clients.removeAt(i);
                            }
                          }
                          selected = List<bool>.generate(
                              clients.length, (int index) => false);
                        });
                      }
                    : null,
                child: const Text('?????????????? ??????????????????'),
              ),
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            key: const PageStorageKey('Clients'),
            child: table,
          ),
        ),
      ],
    );
  }
}
