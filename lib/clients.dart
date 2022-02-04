import 'package:flutter/material.dart';
import 'classes.dart';
import 'global.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({Key? key}) : super(key: key);

  @override
  _ClientsPageState createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  bool isEdit = false;
  List<Client> clients = globalClients.map((e) => Client.clone(e)).toList();
  List<bool> selected =
      List<bool>.generate(globalClients.length, (int index) => false);

  @override
  Widget build(BuildContext context) {
    List<DataCell> cells(Client client) {
      final row = [
        client.companyName,
        client.contactPerson,
        client.contactInformation,
        client.address,
        client.country,
        client.manager,
        client.numberOrders,
      ];
      List<DataCell> cell = [];
      for (int i = 0; i < row.length; i++) {
        cell.add(DataCell(isEdit
            ? TextFormField(
                initialValue: row[i],
                onChanged: (value) {
                  switch (i) {
                    case 0:
                      client.companyName = value;
                      break;
                    case 1:
                      client.contactPerson = value;
                      break;
                    case 2:
                      client.contactInformation = value;
                      break;
                    case 3:
                      client.address = value;
                      break;
                    case 4:
                      client.country = value;
                      break;
                    case 5:
                      client.manager = value;
                      break;
                    case 6:
                      client.numberOrders = value;
                      break;
                  }
                },
              )
            : Text(row[i])));
      }
      return cell;
    }

    DataTable table = DataTable(
      border: TableBorder.all(color: Colors.grey.withOpacity(0.3)),
      columns: const [
        DataColumn(label: Text('Название компании')),
        DataColumn(label: Text('Контактное лицо')),
        DataColumn(label: Text('Контактная информация')),
        DataColumn(label: Text('Адрес')),
        DataColumn(label: Text('Страна')),
        DataColumn(label: Text('Менеджер')),
        DataColumn(label: Text('Кол-во заказов')),
      ],
      rows: List<DataRow>.generate(
        clients.length,
        (index) => DataRow(
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
          }),
          cells: cells(clients[index]),
        ),
      ),
    );

    return ListView(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    clients.add(Client());
                    selected.add(false);
                  });
                },
                child: const Text('Новый клиент'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    globalClients =
                        clients.map((e) => Client.clone(e)).toList();
                    isEdit = false;
                  });
                },
                child: const Text('Сохранить'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    clients =
                        globalClients.map((e) => Client.clone(e)).toList();
                    selected = List<bool>.generate(
                        globalClients.length, (int index) => false);
                    isEdit = false;
                  });
                },
                child: const Text('Сброс'),
              ),
            ),
            Switch(
              value: isEdit,
              onChanged: (bool value) => setState(() {
                isEdit = value;
              }),
            ),
            const Text('Редактирование'),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: isEdit ? () {
                  setState(() {
                    for (int i = clients.length - 1; i >= 0; i--) {
                      if (selected[i]) {
                        clients.removeAt(i);
                      }
                    }
                    selected = List<bool>.generate(
                        clients.length, (int index) => false);
                  });
                } : null,
                child: const Text('Удалить выбранное'),
              ),
            ),
          ],
        ),
        table,
      ],
    );
  }
}
