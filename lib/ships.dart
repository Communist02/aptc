import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'classes.dart';
import 'global.dart';
import 'state_update.dart';
import 'package:easy_web_view/easy_web_view.dart';

Ship? _ship;

class ShipsPage extends StatefulWidget {
  const ShipsPage({Key? key}) : super(key: key);

  @override
  _ShipsPageState createState() => _ShipsPageState();
}

class _ShipsPageState extends State<ShipsPage> {
  @override
  Widget build(BuildContext context) {
    context.watch<ChangeShip>();

    if (_ship == null) {
      return const ShipsView();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(_ship!.name),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              _ship = null;
              context.read<ChangeShip>().change();
            },
          ),
        ),
        body: EasyWebView(
          src: _ship!.link,
        ),
      );
    }
  }
}

class ShipView extends StatelessWidget {
  final Ship ship;

  const ShipView(this.ship, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _ship = ship;
        context.read<ChangeShip>().change();
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                  borderRadius: BorderRadius.circular(16),
                  child: const Icon(
                    Icons.directions_boat_outlined,
                    size: 100,
                  ),
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
      itemCount: globalShips.length,
      itemBuilder: (context, int i) {
        return ShipView(globalShips[i]);
      },
    );
  }
}
