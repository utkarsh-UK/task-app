import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/app/modules/home/controller.dart';

import '../../../core/utils/extensions.dart';

class DoingList extends StatelessWidget {
  final HomeController homeController = Get.find<HomeController>();

  DoingList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => homeController.doingTodos.isEmpty && homeController.doneTodos.isEmpty
          ? Padding(
              padding: EdgeInsets.only(top: 5.0.wp),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/task.png',
                    fit: BoxFit.cover,
                    width: 65.0.wp,
                  ),
                  Text(
                    'Add Task',
                    style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          : ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                ...homeController.doingTodos
                    .map((element) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 3.0.wp, horizontal: 9.0.wp),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                  value: element['done'],
                                  fillColor: MaterialStateProperty.resolveWith((states) => Colors.grey),
                                  onChanged: (value) {
                                    homeController.doneTodo(element['title']);
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.0.wp),
                                child: Text(element['title'], overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
                if (homeController.doingTodos.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0.wp),
                    child: const Divider(thickness: 2),
                  ),
              ],
            ),
    );
  }
}
