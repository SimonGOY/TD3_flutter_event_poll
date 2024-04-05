import 'dart:ffi';

import 'package:event_poll/states/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    this.title,
    this.body,
    super.key,
  });

  final String? title;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    String? nom = context.watch<AuthState>().currentUser?.username;
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? 'Event Poll'),
        centerTitle: true,
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: nom == null ? Text("Vous n'êtes pas connecté") : Text(nom),
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Événements'),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/polls', (_) => false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Connexion'),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (_) => false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Inscription'),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/signup', (_) => false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Déconnexion'),
              onTap: () {
                context.read<AuthState>().logout();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/polls', (_) => false);
              },
            ),
          ],
        ),
      ),
      body: SizedBox.expand(
        child: body,
      ),
    );
  }
}
