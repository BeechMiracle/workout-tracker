import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  const ExerciseTile({
    super.key,
    required this.name,
    required this.weight,
    required this.reps,
    required this.sets,
    required this.isCompleted,
    required this.onCheckboxChange,
  });

  final String name;
  final String weight;
  final String reps;
  final String sets;
  final bool isCompleted;
  final void Function(bool?)? onCheckboxChange;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isCompleted ? Colors.purple : Colors.purple[50],
      margin: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
        ),
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              name,
              style: TextStyle(color: isCompleted ? Colors.white : null),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                // weight
                Chip(
                  label: Text('$weight kg'),
                  side: BorderSide.none,
                ),
          
                const SizedBox(
                  width: 8,
                ),
          
                // reps
                Chip(
                  label: Text('$reps reps'),
                  side: BorderSide.none,
                ),
          
                const SizedBox(
                  width: 8,
                ),
          
                // sets
                Chip(
                  label: Text('$sets sets'),
                  side: BorderSide.none,
                ),
              ],
            ),
          ),
          trailing: Checkbox(
            value: isCompleted,
            activeColor: Colors.purple,
            onChanged: (value) => onCheckboxChange!(value),
          ),
        ),
      ),
    );
  }
}
