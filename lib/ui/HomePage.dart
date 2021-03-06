import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/controllers/task_controller.dart';
import 'package:todoapp/services/notification_services.dart';
import 'package:todoapp/services/theme_services.dart';
import 'package:todoapp/ui/add_task.dart';
import 'package:todoapp/ui/theme.dart';
import 'package:todoapp/ui/widgets/button.dart';
import 'package:todoapp/ui/widgets/task_tile.dart';

import '../models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  var notifyHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        body: Column(children: [
          //TaskBar
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            DateFormat.yMMMMd().format(DateTime.now()),
                          style: subHeadingStyle,
                        ),
                        Text("Today",
                        style: headingStyle),
                      ],
                    )),

                MyButton(label: "+ Add Task", onTap: () async {
                  await Get.to(()=> AddTaskPage());
                  _taskController.getTasks();
                }),
              ],
            ),
          ),
          //DateBar
          Container(
            margin: const EdgeInsets.only(top: 20, left: 20),
            child: DatePicker(
              DateTime.now(),
              height: 100,
              width: 80,
              initialSelectedDate: DateTime.now(),
              selectionColor: primaryClr,
              selectedTextColor: Colors.white,

              dateTextStyle: GoogleFonts.lato(
                textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                ),
              ),
              dayTextStyle: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              monthTextStyle: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),

              onDateChange: (date){
                _selectedDate = date;
              },
            )
          ),
          //Tasks
          SizedBox(height: 10,),
          _showTasks(),
        ]));
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
              title: "Theme changed",
              body: Get.isDarkMode
                  ? "Activated Light Mode"
                  : "Activated Dark Mode");
        },
        child: Icon(
          Icons.nightlight_round,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        Icon(
          Icons.person,
          size: 20,
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx((){
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder:(_, index){
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            _showBottomSheet(context, _taskController.taskList[index]);
                          },
                          child: TaskTile(_taskController.taskList[index]),
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
      })
    );
  }

  _showBottomSheet(BuildContext context, Task task){
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted==1 ?
        MediaQuery.of(context).size.height*0.24:
        MediaQuery.of(context).size.height*0.32,
        color: Get.isDarkMode?darkGreyClr:Colors.white,

        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode?Colors.grey[600]:Colors.grey[300],
              ),
            ),
            Spacer(),

            task.isCompleted==1
            ?Container()
            :_bottomSheetButton(
              label: "Task Completed",
              onTap: (){
                Get.back();
              },
              clr: primaryClr,
              context: context,
            )
          ],
        ),
      ),
    );
  }

  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose = false,
    required BuildContext context,
}){
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      height: 55,
      width: MediaQuery.of(context).size.width*0.9,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: isClose==true ? Colors.red:clr,
        ),
        borderRadius: BorderRadius.circular(20),
      ),

    ),
  );
}
}

/*GestureDetector(
onTap: (){
_taskController.delete(_taskController.taskList[index]);
_taskController.getTasks();
},*/
