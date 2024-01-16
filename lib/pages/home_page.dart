import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_first_flutter_project/components/heat_map.dart';
import 'package:my_first_flutter_project/pages/work_out_page.dart';
import 'package:my_first_flutter_project/user%20data/workout_data.dart';
import 'package:provider/provider.dart';
import 'package:my_first_flutter_project/pages/drawer_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final newWorkoutNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList();
  }

  // sign user out method
  void logout() {
    FirebaseAuth.instance.signOut();
  }

  // create new workout
  void createNewWorkout() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Create new workout",
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            controller: newWorkoutNameController,
          ),
          actions: [
            // save button
            MaterialButton(
              onPressed: save,
              child: Text("save"),
            ),
            MaterialButton(
                onPressed: cancel,
                child: Text("cancel"),
            ),
          ],
        ),
    );
  }

  //go to new work out page
  void goToWorkoutPage(String workoutName) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutPage(
      workoutName: workoutName,
    ),));
  }

  // save new workout
  void save() {
    String newWorkoutName = newWorkoutNameController.text;
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);
    Navigator.of(context).pop();
    clear();
  }

  // cancel new workout
  void cancel() {
    Navigator.of(context).pop();
    clear();
  }

  void clear() {
    newWorkoutNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text("H O M E P A G E"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewWorkout,
          backgroundColor: Colors.black,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        drawer: MyDrawer(logout: logout),
        body: ListView(
          children: [
            // Heat Map
            MyHeatMap(
              datasets: value.heatMapDataSet,
              startDateYYYYMMDD: value.getStartDate(),
            ),

            // Workout List
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.all(24),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: value.getWorkoutList().length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0), // Adjust the vertical padding as needed
                    child: Slidable(
                      endActionPane: ActionPane(
                        motion: StretchMotion(),
                        children: [
                          // setting option
                          SlidableAction(
                            onPressed: (context) {},
                            backgroundColor: Colors.black,
                            icon: Icons.settings,
                            borderRadius: BorderRadius.circular(12),
                          ),

                          //delete option
                          SlidableAction(
                            onPressed: (context) {},
                            backgroundColor: Colors.red.shade400,
                            icon: Icons.delete,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ],
                      ),
                      child: Card(
                        color: Colors.grey[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: GestureDetector(
                          onTap: () => goToWorkoutPage(value.getWorkoutList()[index].name),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16.0), // Adjust the padding within the box as needed
                            title: Text(
                              value.getWorkoutList()[index].name,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}