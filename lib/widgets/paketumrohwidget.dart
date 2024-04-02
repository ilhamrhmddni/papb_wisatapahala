import 'package:flutter/material.dart';
import 'package:wisatapahala/models/paketumrohmodel.dart';

class PaketUmrohCard extends StatelessWidget {
  final PaketUmroh paketUmroh;
  final void Function() onTap;

  PaketUmrohCard(this.paketUmroh, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: ListTile(
          title: Text(paketUmroh.nama),
          subtitle: Text('Harga: ${paketUmroh.harga}'),
        ),
      ),
    );
  }
}
