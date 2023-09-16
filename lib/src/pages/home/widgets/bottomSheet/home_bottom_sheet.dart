import 'package:flutter/material.dart';
import 'package:time_sense/src/pages/home/widgets/bottomSheet/add_task_widget.dart';
import './task_container_bottom_sheet.dart';

import '../../../../shared/utils/utils.dart';
import '../../../../shared/widgets/widgets.dart';

class HomeBottomSheet extends StatelessWidget {
  const HomeBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final List<Map<String, dynamic>> tasks = [
      {'id': 1, 'text': 'Criar de um site de compras'},
      {'id': 2, 'text': 'Desenvolvimento do projeto X em flutter'},
      {'id': 3, 'text': 'Desenvolvimento do projeto X em flutter'},
      {'id': 4, 'text': 'Refatorar código do projeto X'},
      {'id': 5, 'text': 'Refatorar código do projeto X'},
      {'id': 6, 'text': 'Refatorar código do projeto X'},
      {'id': 7, 'text': 'Refatorar código do projeto X'},
      {'id': 8, 'text': 'Refatorar código do projeto X'},
      {'id': 9, 'text': 'Refatorar código do projeto X'},
      {'id': 10, 'text': 'Refatorar código do projeto X'},
    ];

    return Container(
      height: size.height * 0.5,
      color: backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: const AddTaskWidget(),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    tasks.length,
                    (index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: TaskContainerBottomSheet(
                          backIcon: 'assets/icons/right-arrow.svg',
                          press: () {},
                          text: 'Curso de flutter',
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20, top: 20),
              child: PrimaryButton(
                text: 'Fechar',
                press: () => Navigator.pop(context),
                color: primaryColor,
                height: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

