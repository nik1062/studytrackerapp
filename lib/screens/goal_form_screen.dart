import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../models/goal.dart';
import '../providers/goal_provider.dart';

class GoalFormScreen extends StatefulWidget {
  final Goal? goal;

  const GoalFormScreen({super.key, this.goal});

  @override
  _GoalFormScreenState createState() => _GoalFormScreenState();
}

class _GoalFormScreenState extends State<GoalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _description;
  late int _targetMinutes;
  late DateTime _dueDate;

  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.goal != null) {
      _description = widget.goal!.description;
      _targetMinutes = widget.goal!.targetMinutes;
      _dueDate = widget.goal!.dueDate;
    } else {
      _description = '';
      _targetMinutes = 60; // Default to 1 hour
      _dueDate = DateTime.now();
    }
    _dateController.text = DateFormat.yMd().format(_dueDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
        _dateController.text = DateFormat.yMd().format(_dueDate);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final goalProvider = Provider.of<GoalProvider>(context, listen: false);

      if (widget.goal != null) {
        // Update existing goal
        widget.goal!.description = _description;
        widget.goal!.targetMinutes = _targetMinutes;
        widget.goal!.dueDate = _dueDate;
        goalProvider.updateGoal(widget.goal!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Goal updated successfully!')),
        );
      } else {
        // Add new goal
        goalProvider.addGoal(_description, _targetMinutes, _dueDate);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Goal added successfully!')),
        );
      }
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.goal == null ? 'Add Goal' : 'Edit Goal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Goal Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              TextFormField(
                initialValue: _targetMinutes.toString(),
                decoration: const InputDecoration(labelText: 'Target Minutes'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid number of minutes';
                  }
                  return null;
                },
                onSaved: (value) {
                  _targetMinutes = int.parse(value!);
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Due Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Save Goal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
