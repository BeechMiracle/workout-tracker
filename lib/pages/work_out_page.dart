import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/components/exercise_tile.dart';
import 'package:workout_tracker/data/workout_data.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({
    super.key,
    required this.workoutName,
  });

  final String workoutName;

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  late TextEditingController exerciseNameController;
  late TextEditingController weightController;
  late TextEditingController repsController;
  late TextEditingController setsController;

  @override
  void initState() {
    super.initState();

    exerciseNameController = TextEditingController();
    weightController = TextEditingController();
    repsController = TextEditingController();
    setsController = TextEditingController();
  }

  @override
  void dispose() {
    exerciseNameController.dispose();
    weightController.dispose();
    repsController.dispose();
    setsController.dispose();

    super.dispose();
  }

  // clear controllers
  void clearController() {
    exerciseNameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

  // checkbox clicked
  void onCheckboxChange(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExercise(workoutName, exerciseName);
  }

  // create new exercise
  void createNewExercise() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Add New Exercise',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // exercise name
            TextField(
              controller: exerciseNameController,
              decoration: const InputDecoration(
                hintText: 'Exercise name',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple),
                ),
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            // weight
            TextField(
              controller: weightController,
              decoration: const InputDecoration(
                hintText: 'Weight',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple),
                ),
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            // reps
            TextField(
              controller: repsController,
              decoration: const InputDecoration(
                hintText: 'Reps',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple),
                ),
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            // sets
            TextField(
              controller: setsController,
              decoration: const InputDecoration(
                hintText: 'Sets',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple),
                ),
              ),
            ),
          ],
        ),
        actions: [
          // cancel button
          MaterialButton(
            onPressed: onCancel,
            child: const Text(
              'Cancel',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          // save button
          MaterialButton(
            onPressed: onSave,
            child: const Text(
              'Save',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // onSave clicked
  void onSave() {
    String exerciseName = exerciseNameController.text;

    // add new exercise
    Provider.of<WorkoutData>(context, listen: false).addExercise(
      widget.workoutName,
      exerciseName,
      weightController.text,
      repsController.text,
      setsController.text,
    );

    // pop context
    Navigator.pop(context);

    // clear controllers
    clearController();
  }

  // onCancel clicked
  void onCancel() {
    // pop context
    Navigator.pop(context);

    // clear controllers
    clearController();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            widget.workoutName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 16,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.numberOfExercisesInWorkout(widget.workoutName),
              itemBuilder: (context, index) => ExerciseTile(
                name: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .name,
                weight: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .weight,
                reps: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .reps,
                sets: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .sets,
                isCompleted: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .isCompleted,
                onCheckboxChange: (p0) => onCheckboxChange(
                  widget.workoutName,
                  value
                      .getRelevantWorkout(widget.workoutName)
                      .exercises[index]
                      .name,
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewExercise,
          backgroundColor: Colors.deepPurple[900],
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
