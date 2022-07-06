import 'package:appartapp/classes/enum_gender.dart';
import 'package:appartapp/classes/enum_month.dart';
import 'package:appartapp/classes/enum_temporalq.dart';
import 'package:appartapp/classes/like_from_user.dart';
import 'package:appartapp/classes/runtime_store.dart';
import 'package:appartapp/classes/user.dart';
import 'package:appartapp/classes/user_handler.dart';
import 'package:appartapp/widgets/error_dialog_builder.dart';
import 'package:appartapp/widgets/tenant_viewer.dart';
import 'package:dio/dio.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';

class Tenants extends StatefulWidget {
  final Future<LikeFromUser?> firstTenantFuture;

  Tenants({Key? key, required this.child, required this.firstTenantFuture})
      : super(key: key);

  final Widget child;

  @override
  _Tenants createState() => _Tenants();
}

class _Tenants extends State<Tenants> {
  int _currentRoute = 0;

  bool match = false;

  void updateUI(bool value) {
    setState(() {
      match = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/background.gif"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ContentPage(
                  currentTenantFuture: widget.firstTenantFuture,
                  updateUI: updateUI,
                  match: match,
                  whoCreatedMe: "Tenants creation",
                ));
          },
        );
      },
    );
  }
}

class ContentPage extends StatefulWidget {
  bool match;
  String whoCreatedMe;

  final likeUrlStr =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/likeuser";
  final ignoreUrlStr =
      "http://ratti.dynv6.net/appartapp-1.0-SNAPSHOT/api/reserved/ignoreuser";
//------------------------
  Future<void> _networkFunction(BuildContext context, String urlString,
      int userId, int apartmentId) async {
    var dio = RuntimeStore().dio;
    try {
      Response response = await dio.post(
        urlString,
        data: {
          "userid": userId, //the tenant I like or ignore
          "apartmentid": apartmentId
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode != 200) {
        Navigator.restorablePush(
            context, ErrorDialogBuilder.buildGenericConnectionErrorRoute);
      }
    } on DioError {
      Navigator.restorablePush(
          context, ErrorDialogBuilder.buildConnectionErrorRoute);
    }
  }

  void likeTenant(BuildContext context, int tenantId, int apartmentId) async {
    await _networkFunction(context, likeUrlStr, tenantId, apartmentId);
  }

  void ignoreTenant(BuildContext context, int tenantId, int apartmentId) async {
    await _networkFunction(context, ignoreUrlStr, tenantId, apartmentId);
  }

  Future<LikeFromUser?> currentTenantFuture;
  Function(bool value) updateUI;

//Function updateHouses;

  @override
  _ContentPage createState() => _ContentPage();

  ContentPage(
      {Key? key,
      required this.currentTenantFuture,
      required this.updateUI,
      required this.match,
      required this.whoCreatedMe})
      : super(key: key);
}

class _ContentPage extends State<ContentPage> {
  LikeFromUser? currentTenant = LikeFromUser(
      null,
      User.temp(
          000,
          "Caricamento in corso...",
          "Caricamento in corso...",
          "Caricamento in corso...",
          DateTime(2022),
          Gender.NB,
          [],
          [],
          "Caricamento in corso...",
          "Caricamento in corso...",
          Month.Luglio,
          "Caricamento in corso...",
          "Caricamento in corso...",
          TemporalQ.Sometimes,
          "Caricamento in corso..."));

  late Future<LikeFromUser?> nextTenantFuture;
  bool tenantLoaded = false;

  bool firstDrag = true;
  double initialCoord = 0.0;
  double finalCoord = 0.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    nextTenantFuture =
        UserHandler().getNewLikeFromUser((LikeFromUser likeFromUser) {
          for (final Image im in likeFromUser.user.images) {
            precacheImage(im.image, context);
          }
        });
  }

  @override
  void initState() {
    super.initState();

    widget.currentTenantFuture.then((value) {
      if (value != null) tenantLoaded = true;
      setState(() {
        currentTenant = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              return DismissiblePage(
                //backgroundColor: Colors.white,
                  onDismissed: () {
                    widget.updateUI(false);
                    if (currentTenant != null) {
                      if (finalCoord < initialCoord) {
                        widget.likeTenant(context, currentTenant!.user.id,
                            currentTenant!.apartment!.id);
                      } else {
                        widget.ignoreTenant(context, currentTenant!.user.id,
                            currentTenant!.apartment!.id);
                      }
                    }
                    Navigator.of(context).pop();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ContentPage(
                              currentTenantFuture: nextTenantFuture,
                              updateUI: widget.updateUI,
                              match: widget.match,
                              whoCreatedMe: "Content creation",
                            )));
                  },
                  direction: widget.match
                      ? DismissiblePageDismissDirection.endToStart
                      : DismissiblePageDismissDirection.horizontal,
                  onDragUpdate: (DismissiblePageDragUpdateDetails details) {
                    double value = details.offset.dx;
                    if (firstDrag) {
                      initialCoord = value;
                      firstDrag = false;
                    } else {
                      finalCoord = value;
                    }
                  },
                  dragSensitivity: 0.5,
                  disabled: !tenantLoaded,
                  child: TenantViewer(
                    tenantLoaded: tenantLoaded,
                    lessor: false,
                    currentLikeFromUser: currentTenant,
                    updateUI: widget.updateUI,
                    match: widget.match,
                  ));
            });
      },
    );
  }
}
