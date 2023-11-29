import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/components/heat_map.dart';
import 'package:workout_tracker/data/workout_data.dart';
import 'package:workout_tracker/pages/work_out_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController workoutNameController;

  @override
  void initState() {
    super.initState();

    Provider.of<WorkoutData>(context, listen: false)
        .initializeWorkout();

    workoutNameController = TextEditingController();
  }

  @override
  void dispose() {
    workoutNameController.dispose();

    super.dispose();
  }

  // create a new workout
  void createNewWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Create New Workout',
        ),
        content: TextField(
          controller: workoutNameController,
          decoration: const InputDecoration(
            hintText: 'Workout name',
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple),
            ),
          ),
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

  // goto workout page
  void gotoWorkoutPage(String workoutName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutPage(workoutName: workoutName),
      ),
    );
  }

  // clear controller
  void clearController() {
    workoutNameController.clear();
  }

  // onSave workout
  void onSave() {
    String workoutName = workoutNameController.text;

    // add workout name
    Provider.of<WorkoutData>(context, listen: false).addWorkout(workoutName);

    // pop dialog
    Navigator.pop(context);

    // clear controller
    clearController();
  }

  // onCancel workout
  void onCancel() {
    // pop dialog
    Navigator.pop(context);

    // clear controller
    clearController();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Workout Tracker',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple),
          ),
        ),
        body: ListView(
          children: [
            HeatMaps(
              dataSets: value.dataSets,
              startDate: value.getStartDate(),
            ),
            const SizedBox(
              height: 16,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.getWorkoutList().length,
              itemBuilder: (context, index) => Container(
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.only(
                  bottom: 16,
                  left: 8,
                  right: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  title: Text(
                    value.getWorkoutList()[index].name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () =>
                        gotoWorkoutPage(value.getWorkoutList()[index].name),
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewWorkout,
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
