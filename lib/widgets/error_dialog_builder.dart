import 'package:flutter/cupertino.dart';

class ErrorDialogBuilder {
  static Route<Object?> buildConnectionErrorRoute(
      BuildContext context, Object? arguments) {
    return CupertinoDialogRoute<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
            title: const Text("Errore"),
            actions: [
              CupertinoDialogAction(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
            content: const Center(
              child: Text("Errore di connessione"),
            ));
      },
    );
  }

  static Route<Object?> buildConnectionErrorReloadAppRoute(
      BuildContext context, Object? arguments) {
    return CupertinoDialogRoute<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
            title: const Text("Errore"),
            actions: [
              CupertinoDialogAction(
                  child: const Text("Riprova"),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (route) => false);
                  })
            ],
            content: const Center(
              child: Text("Errore di connessione"),
            ));
      },
    );
  }

  static Route<Object?> buildGenericConnectionErrorRoute(
      BuildContext context, Object? arguments) {
    return CupertinoDialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
            title: const Text("Errore"),
            actions: [
              CupertinoDialogAction(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
            content: const Center(
              child: Text(
                  "Errore nell'eseguire l'operazione richiesta. Assicurati che la connessione sia funzionante e che le credenziali siano valide"),
            ));
      },
    );
  }

  static Route<Object?> buildGenericErrorRoute(
      BuildContext context, Object? arguments) {
    return CupertinoDialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
            title: const Text("Errore"),
            actions: [
              CupertinoDialogAction(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
            content: const Center(
              child: Text("Errore nell'eseguire l'operazione richiesta."),
            ));
      },
    );
  }

  static Route<Object?> buildCredentialsErrorRoute(
      BuildContext context, Object? arguments) {
    return CupertinoDialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
            title: const Text("Errore"),
            actions: [
              CupertinoDialogAction(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
            content: const Center(
              child: Text("Credentiali errate"),
            ));
      },
    );
  }
}
