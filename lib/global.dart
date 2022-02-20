import 'classes.dart';

Map<String, String> appSettings = {'theme': 'system'};

List<Ship> globalShips = [
  Ship('Танкер Велес', 'Снабжение судов топливом'),
  Ship('Танкер Катран', 'Снабжение судов топливом'),
  Ship('Танкер Партизанск',
      'Перевозка нефтепродуктов в основном в арктических районах в навигационный период'),
];

List<Client> globalClients = [];

List<Request> globalRequests = [
  Request(
    'Перевозка контейнера',
    {},
    '0',
    'Мазур Денис Олегович',
    DateTime.now(),
  ),
  Request(
    'Перевозка контейнера',
    {},
    '0',
    'Путин Владимир Владимирович',
    DateTime.now(),
  ),
];