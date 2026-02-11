import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/subject.dart';
import '../providers/subject_provider.dart';

class SubjectFormScreen extends StatefulWidget {
  final Subject? subject;

  const SubjectFormScreen({super.key, this.subject});

  @override
  _SubjectFormScreenState createState() => _SubjectFormScreenState();
}

class _SubjectFormScreenState extends State<SubjectFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late Color _selectedColor;

  // Predefined colors for the user to choose from
  final List<Color> _predefinedColors = [
    Colors.red, Colors.green, Colors.blue, Colors.orange, Colors.purple,
    Colors.pink, Colors.teal, Colors.amber, Colors.cyan, Colors.brown,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.subject != null) {
      _name = widget.subject!.name;
      _selectedColor = widget.subject!.color;
    } else {
      _name = '';
      _selectedColor = _predefinedColors[0];
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final subjectProvider = Provider.of<SubjectProvider>(context, listen: false);

      if (widget.subject != null) {
        // Update existing subject
        widget.subject!.name = _name;
        widget.subject!.color = _selectedColor;
        subjectProvider.updateSubject(widget.subject!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Subject updated successfully!')),
        );
      } else {
        // Add new subject
        subjectProvider.addSubject(_name, _selectedColor);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Subject added successfully!')),
        );
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject == null ? 'Add Subject' : 'Edit Subject'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Subject Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              const SizedBox(height: 20),
              const Text('Choose a color'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _predefinedColors.map((color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: color,
                      child: _selectedColor == color
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Save Subject'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
