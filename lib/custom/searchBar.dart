import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:compwaste/helper/screen_utils.dart';

class Searchbar extends StatefulWidget {
  final String? imageUrl;
  final String? title;
  final String? releaseDate;
  Searchbar({super.key, this.imageUrl, this.releaseDate, this.title});

  @override
  State<Searchbar> createState() => _SearchbarState();
}

class _SearchbarState extends State<Searchbar> {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        height: 34,
        child: TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            hintText: 'Cari',
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(100),
            ),
            suffixIcon: Container(padding: EdgeInsets.all(4), margin: EdgeInsets.only(right: 16), child: Image.asset('assets/loupe.png', width: 12, height: 12)),
          ),
        ),
      ),
    );
  }
}
