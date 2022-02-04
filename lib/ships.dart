import 'package:flutter/material.dart';
import 'classes.dart';
import 'global.dart';

class ShipsPage extends StatefulWidget {
  const ShipsPage({Key? key}) : super(key: key);

  @override
  _ShipsPageState createState() => _ShipsPageState();
}

class _ShipsPageState extends State<ShipsPage> {
  @override
  Widget build(BuildContext context) {
    return const ShipsView();
  }
}

class ShipView extends StatelessWidget {
  final Ship ship;

  const ShipView(this.ship, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 120,
                height: 120,
                margin: const EdgeInsets.fromLTRB(2, 2, 10, 2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: const Icon(Icons.directions_boat_outlined),
                ),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ship.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      ship.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.caption!.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShipsView extends StatelessWidget {
  const ShipsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: const PageStorageKey('Ships'),
      padding: const EdgeInsets.symmetric(vertical: 5),
      itemCount: globalShips.length,
      itemBuilder: (context, int i) {
        return ShipView(globalShips[i]);
      },
    );
  }
}
