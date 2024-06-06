import 'package:flutter/material.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen({super.key});

  @override
  _ItemListScreenState createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<String> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedItems = prefs.getStringList('items');
    if (savedItems != null) {
      setState(() {
        _items.addAll(savedItems);
      });
    }
  }

  Future<void> _addItem() async {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _items.add(_textController.text);
      });
      _textController.clear();
      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList('items', _items);
    }
  }

  Future<void> _removeItem(int index) async {
    setState(() {
      _items.removeAt(index);
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('items', _items);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: "Insert text",
                suffixIcon: IconButton(
                  onPressed: () {
                    _textController.clear();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _addItem,
            child: const Text("Add"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_items[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeItem(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
