// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
    final tasksController = context.watch<TasksController>();

    return Form(
      key: _formKey,
      child: Animate(
        effects: const [FadeEffect(), SlideEffect()],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextFormField(
                controller: textFieldController,
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                  hintText: tasksController.textFieldlHintText,
                  hintStyle: TextStyle(
                      color: tasksController.textFieldlHintText ==
                              "Criar tarefa..."
                          ? whiteColor.withOpacity(0.5)
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
              )
                  .animate(
                      target: tasksController.textFieldlHintText ==
                                  "Digite o nome da tarefa..." &&
                              textFieldController.text == ''
                          ? 1
                          : 0)
                  .shake(),
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
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  await tasksController.addNewTask(
                      text: textFieldController.text);

                  if (tasksController.textFieldlHintText !=
                      'Digite o nome da tarefa...') {
                    FocusScope.of(context).unfocus();
                  }
                  textFieldController.text = "";
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
