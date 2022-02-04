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
}
