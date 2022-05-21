import 'classes.dart';

Account account = Account();
Map<String, String> appSettings = {'theme': 'system'};
List<Ship> globalShips = [
  Ship(
    'Танкер Велес',
    'Снабжение судов топливом',
    'https://www.myshiptracking.com/ru/vessels/veles-mmsi-273320870-imo-9009700',
  ),
  Ship(
    'Танкер Катран',
    'Снабжение судов топливом',
    'https://www.myshiptracking.com/ru/vessels/katran-mmsi-273440860-imo-8727343',
  ),
  Ship(
    'Танкер Партизанск',
    'Перевозка нефтепродуктов в основном в арктических районах в навигационный период',
    'https://www.myshiptracking.com/ru/vessels/partizansk-mmsi-273336730-imo-0',
  ),
];
SearchHistory searchHistory = SearchHistory([]);
Contacts globalContacts = Contacts([]);
List<dynamic> globalClients = [];
List<Request> globalRequests = [];
