import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:todo/app/modules/detail/widgets/doing_list.dart';
import 'package:todo/app/modules/detail/widgets/done_list.dart';
import 'package:todo/app/modules/home/controller.dart';

import '../../core/utils/extensions.dart';

class DetailPage extends StatelessWidget {
  final HomeController homeController = Get.find<HomeController>();

  DetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final task = homeController.task.value!;
    final color = HexColor.fromHex(task.color);

    return Scaffold(
      body: Form(
        key: homeController.formKey,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(3.0.wp),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                        homeController.updateTodos();
                        homeController.changeTask(null);
                        homeController.editController.clear();
                      },
                      icon: const Icon(Icons.arrow_back))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.wp),
              child: Row(
                children: [
                  Icon(IconData(task.icon, fontFamily: 'MaterialIcons'), color: color),
                  SizedBox(width: 3.0.wp),
                  Text(
                    task.title,
                    style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0.wp, top: 3.0.wp, right: 16.0.wp),
              child: Obx(
                () {
                  final totalTodos = homeController.doingTodos.length + homeController.doneTodos.length;

                  return Row(
                    children: [
                      Text(
                        '$totalTodos Tasks',
                        style: TextStyle(fontSize: 12.0.sp, color: Colors.grey),
                      ),
                      SizedBox(width: 3.0.wp),
                      Expanded(
                        child: StepProgressIndicator(
                          totalSteps: totalTodos == 0 ? 1 : totalTodos,
                          currentStep: homeController.doneTodos.length,
                          size: 5,
                          padding: 0,
                          selectedGradientColor: LinearGradient(
                              colors: [color.withOpacity(0.5), color],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight),
                          unselectedGradientColor: LinearGradient(
                              colors: [Colors.grey[300]!, Colors.grey[300]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0.wp, horizontal: 5.0.wp),
              child: TextFormField(
                controller: homeController.editController,
                autofocus: true,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  prefixIcon: Icon(Icons.check_box_outline_blank, color: Colors.grey[400]),
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (homeController.formKey.currentState!.validate()) {
                        final success = homeController.addTodo(homeController.editController.text);
                        if (success) {
                          EasyLoading.showSuccess('Todo item add success');
                        } else {
                          EasyLoading.showError('Todo item already exists');
                        }

                        homeController.editController.clear();
                      }
                    },
                    icon: const Icon(Icons.done),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your todo item';
                  }
                  return null;
                },
              ),
            ),
            DoingList(),
            DoneList(),
          ],
        ),
      ),
    );
  }
}
