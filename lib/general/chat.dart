import 'package:compwaste/custom/chat_tile.dart';
import 'package:compwaste/custom/searchBar.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Text('Chat', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),),
                  const Spacer(),
                  TextButton(onPressed: (){}, child: Text("Pilih"))
                ],
              ),
              const SizedBox(height: 16),
              Searchbar(),
              const SizedBox(height: 16),
              ListView.builder(
                itemCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ChatTile(
                    index: index,
                  );
                })
            ],
          )
      ),
    );
  }
}
