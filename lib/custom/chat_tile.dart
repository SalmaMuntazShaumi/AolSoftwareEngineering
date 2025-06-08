import 'package:flutter/material.dart';
class ChatTile extends StatefulWidget {
  final String? user;
  final double? width;
  final int index;
  const ChatTile({super.key, this.user, this.width, this.index = 0});

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  List<String> users = [
    'User 1',
    'User 2',
    'User 3'
  ];
  int index = 0;

  @override
  Widget build(BuildContext context) {
    Widget tile = ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/avatar${widget.index + 1}.png'),
      ),
      title: Text('Chat with ${users[widget.index]}'),
      subtitle: Text('Last message from User ${widget.index + 1}'),
      trailing: Text('10:00 AM'),
      onTap: () {
        // Navigate to chat details
      },
    );
    return widget.width != null ? SizedBox(width: widget.width, child: tile) : tile;
  }
}