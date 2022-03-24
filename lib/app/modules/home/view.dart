import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:todo/app/core/values/colors.dart';
import 'package:todo/app/data/models/task.dart';
import 'package:todo/app/modules/home/controller.dart';
import 'package:todo/app/modules/home/widgets/task_card.dart';
import 'package:todo/app/modules/report/view.dart';

import '../../core/utils/extensions.dart';
import 'widgets/add_card.dart';
import 'widgets/add_dialog.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: DragTarget<Task>(
        onAccept: (Task task) {
          controller.deleteTask(task);
          EasyLoading.showSuccess('Delete Success');
        },
        builder: (_, __, ___) {
          return Obx(
            () => FloatingActionButton(
              onPressed: () {
                if (controller.tasks.isNotEmpty) {
                  Get.to(() => AddDialog(), transition: Transition.downToUp);
                } else {
                  EasyLoading.showInfo('Please create your task type');
                }
              },
              backgroundColor: controller.deleting.value ? Colors.red : blue,
              child: Icon(controller.deleting.value ? Icons.delete : Icons.add),
            ),
          );
        },
      ),
      body: Obx(
        () => IndexedStack(
          index: controller.tabIndex.value,
          children: [
            SafeArea(
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.all(4.0.wp),
                    child: Text('My List',
                        style: TextStyle(fontSize: 24.0.sp, fontWeight: FontWeight.bold)),
                  ),
                  Obx(
                    () => GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      children: [
                        ...controller.tasks
                            .map((task) => LongPressDraggable(
                                  data: task,
                                  onDragStarted: () => controller.changeDeleting(true),
                                  onDraggableCanceled: (_, __) => controller.changeDeleting(false),
                                  onDragEnd: (_) => controller.changeDeleting(false),
                                  child: TaskCard(task: task),
                                  feedback: Opacity(
                                    opacity: 0.8,
                                    child: TaskCard(task: task),
                                  ),
                                ))
                            .toList(),
                        AddCard(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ReportPage(),
          ],
        ),
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Obx(
          () => BottomNavigationBar(
            onTap: controller.changeTabIndex,
            currentIndex: controller.tabIndex.value,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(right: 15.0.wp),
                    child: const Icon(Icons.apps),
                  ),
                  label: 'Home'),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(left: 15.0.wp),
                    child: const Icon(Icons.data_usage),
                  ),
                  label: 'Report')
            ],
          ),
        ),
      ),
    );
  }
}
