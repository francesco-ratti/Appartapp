// ignore_for_file: prefer_const_constructors

import 'package:appartapp/classes/user.dart';
import 'package:appartapp/classes/first_arguments.dart';
import 'package:appartapp/pages/edit_profile.dart';
import 'package:appartapp/pages/houses.dart';
import 'package:appartapp/pages/matches.dart';
import 'package:appartapp/pages/tenants.dart';
import 'package:flutter/material.dart';

import '../classes/runtime_store.dart';
import 'owned_apartments.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.yellowAccent;

    User? user = RuntimeStore().getUser();
    if (user != null) {
      for (final Image im in user.images) {
        precacheImage(im.image, context);
      }
    }

    return Scaffold(
      //backgroundColor: RuntimeStore.backgroundColor,
      body: SafeArea(
        top: false,
        bottom: true,
        child: IndexedStack(
          index: _pageIndex,
          children: <Widget>[
            Houses(
                child: Text('Esplora'),
                firstApartmentFuture: ((ModalRoute.of(context)!
                        .settings
                        .arguments) as FirstArguments)
                    .firstApartmentFuture),
            Matches(),
            Tenants(
                child: Text('Esplora'),
                firstTenantFuture: ((ModalRoute.of(context)!.settings.arguments)
                as FirstArguments)
                    .firstTenantFuture),
            OwnedApartments(),
            EditProfile(),
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: BottomNavigationBar(
        //backgroundColor: Colors.white, //try transparent
        type: BottomNavigationBarType.shifting,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_rounded,
              color: Colors.black,
            ),
            label: 'Esplora',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.filter_list_rounded,
              color: Colors.black,
            ),
            label: 'Matches',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_sharp, color: Colors.black),
              label: "Tenants",
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_bubble_rounded,
              color: Colors.black,
            ),
            label: 'I miei appartamenti',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline_rounded,
              color: Colors.black,
            ),
            label: 'Profilo',
          ),
        ],
        currentIndex: _pageIndex,
        onTap: (int index) {
          setState(
            () {
              _pageIndex = index;
            },
          );
        },
      ),
    );
  }
}
