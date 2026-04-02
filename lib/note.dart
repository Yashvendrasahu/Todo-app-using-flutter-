import 'package:flutter/material.dart';
import 'package:myapp/data_base/local_db/local.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  List<Map<String, dynamic>> _allNotes = [];
  late final HelperDB _dbHelper;
  final _titleCont = TextEditingController();
  final _discCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dbHelper = HelperDB.instance;
    _getNotes();
  }

  void _getNotes() async {
    _allNotes = await _dbHelper.getAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: Column(
        children: [
          _allNotes.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: _allNotes.length,
                    itemBuilder: (context, index) {
                      final note = _allNotes[index];
                      return ListTile(
                        leading: Text('${index + 1}'),
                        title: Text(note[HelperDB.columnInfo]),
                        subtitle: Text(note[HelperDB.columnDisp]),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _titleCont.text = note[HelperDB.columnInfo];
                                _discCont.text = note[HelperDB.columnDisp];
                                _showBottomSheet(true, note[HelperDB.columnNoteSno]);
                              },
                            ),
                            IconButton(
                              onPressed: () async {
                                bool check = await _dbHelper.deleteNote(
                                  sno: note[HelperDB.columnNoteSno],
                                );
                                if (check) {
                                  _getNotes();
                                }
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : const Center(child: Text('No Notes Yet')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _titleCont.clear();
          _discCont.clear();
          _showBottomSheet(false, 0);
        },
      ),
    );
  }

  void _showBottomSheet(bool isUpdate, int sno) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(21.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isUpdate ? 'Update Note' : 'Add Note',
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 21),
              TextField(
                controller: _titleCont,
                decoration: InputDecoration(
                  labelText: 'Enter Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
              ),
              const SizedBox(height: 21),
              TextField(
                controller: _discCont,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Enter Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
              ),
              const SizedBox(height: 21),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: Text(isUpdate ? 'Update' : 'Add Note'),
                      onPressed: () async {
                        var title = _titleCont.text;
                        var disc = _discCont.text;
                        if (title.isNotEmpty && disc.isNotEmpty) {
                          bool check = isUpdate
                              ? await _dbHelper.updateNote(
                                  title: title,
                                  disc: disc,
                                  sno: sno,
                                )
                              : await _dbHelper.addNote(title: title, disc: disc);
                          if (check) {
                            _getNotes();
                          }
                        }
                        if (mounted) Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: ElevatedButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
