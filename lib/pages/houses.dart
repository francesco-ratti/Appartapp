import 'package:appartapp/classes/apartmentHandler.dart';
import 'package:appartapp/widgets/apartment_model.dart';
import 'package:appartapp/widgets/tab_widget.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Houses extends StatefulWidget {
  Houses({required this.child});

  final Widget child;

  @override
  _Houses createState() => _Houses();
}

class _Houses extends State<Houses> {
  int _currentRoute = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            // da fare: crea un widget che contiene gli appartamenti
            // da fare: crea un widget che contiene le foto di un appartm
            return DismissiblePage(
              onDismissed: () => {
                setState(() {
                  print("DISMISSED");
                  ApartmentHandler().getNewApartment();
                })
              },
              direction: DismissiblePageDismissDirection.horizontal,
              dragSensitivity: 0.5,
              child: SlidingUpPanel(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
                panelBuilder: (scrollController) =>
                    buildSlidingPanel(scrollController: scrollController),
                body: ApartmentModel(),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildSlidingPanel({required ScrollController scrollController}) =>
      TabWidget(scrollController: scrollController, listingTitle: "Bilocale Milano", description: "Casa molto carina, senza soffitto, senza cucina", price: 350, address: "Via di Paperone, Paperopoli", additionalExpenseDetail: "No, pagamento trimestrale",);
}