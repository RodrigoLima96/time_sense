// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../controllers/tasks_controller.dart';
import '../utils/utils.dart';

class AddTaskWidget extends StatefulWidget {
  const AddTaskWidget({
    super.key,
  });

  @override
  State<AddTaskWidget> createState() => _AddTaskWidgetState();
}

class _AddTaskWidgetState extends State<AddTaskWidget> {
  final TextEditingController textFieldController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final tasksController = context.watch<TasksController>();

    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: size.width * 0.7,
            child: TextFormField(
              controller: textFieldController,
              decoration: InputDecoration(
                hintText: tasksController.textFieldlHintText,
                hintStyle: TextStyle(
                    color:
                        tasksController.textFieldlHintText == "Criar tarefa..."
                            ? Colors.white.withOpacity(0.5)
                            : Colors.red.shade300,
                    fontWeight: FontWeight.normal),
                border: InputBorder.none,
              ),
              style: textBold,
              onChanged: (value) {
                if (value.isEmpty) {
                  tasksController.changeTextFieldlHintText(
                      text: "Criar tarefa...");
                }
              },
            ),
          ),
          GestureDetector(
            child: Container(
              height: 35,
              width: 40,
              color: Colors.transparent,
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/more-icon.svg',
                  color: primaryColor,
                  width: 20,
                ),
              ),
            ),
            onTap: () {
              if (_formKey.currentState!.validate()) {
                tasksController.addNewTask(text: textFieldController.text);
                textFieldController.text = "";
              }
            },
          ),
        ],
      ),
    );
  }
}
