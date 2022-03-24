import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:todo/app/modules/home/controller.dart';

import '../../../core/utils/extensions.dart';

class AddDialog extends StatelessWidget {
  final HomeController homeController = Get.find<HomeController>();

  AddDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Form(
          key: homeController.formKey,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(3.0.wp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Get.back();
                          homeController.editController.clear();
                          homeController.changeTask(null);
                        },
                        icon: const Icon(Icons.close)),
                    TextButton(
                      onPressed: () {
                        if (homeController.formKey.currentState!.validate()) {
                          if (homeController.task.value == null) {
                            EasyLoading.showError('Please select task type');
                          } else {
                            final success = homeController.updateTask(
                                homeController.task.value!, homeController.editController.text);
                            if (success) {
                              EasyLoading.showSuccess('Todo item add success');
                              Get.back();
                              homeController.changeTask(null);
                            } else {
                              EasyLoading.showError('Todo item already exists');
                            }

                            homeController.editController.clear();
                          }
                        }
                      },
                      style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
                      child: Text(
                        'Done',
                        style: TextStyle(fontSize: 14.0.sp),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                child: Text(
                  'New Task',
                  style: TextStyle(fontSize: 20.0.sp, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                child: TextFormField(
                  controller: homeController.editController,
                  decoration: InputDecoration(
                    focusedBorder:
                        UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[400]!)),
                  ),
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your todo item';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0.wp, left: 5.0.wp, right: 5.0.wp, bottom: 2.0.wp),
                child: Text(
                  'Add to',
                  style: TextStyle(fontSize: 14.0.sp, color: Colors.grey),
                ),
              ),
              ...homeController.tasks
                  .map((task) => Obx(
                        () => InkWell(
                          onTap: () => homeController.changeTask(task),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 3.0.wp, horizontal: 5.0.wp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(IconData(task.icon, fontFamily: 'MaterialIcons'),
                                        color: HexColor.fromHex(task.color)),
                                    SizedBox(width: 3.0.wp),
                                    Text(
                                      task.title,
                                      style: TextStyle(fontSize: 12.0.sp, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                if (homeController.task.value == task)
                                  Padding(
                                    padding: EdgeInsets.only(left: 5.0.wp),
                                    child: const Icon(Icons.check, color: Colors.blue),
                                  )
                              ],
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
