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
    'Перевести контейнер 2, 3, 6 метров',
    '0',
    'Мазур Денис Олегович',
    DateTime.now(),
  ),
];