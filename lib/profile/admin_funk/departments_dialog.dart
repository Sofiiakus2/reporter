import 'package:flutter/material.dart';
import 'package:reporter/models/user_model.dart';
import 'package:reporter/services/admin_service.dart';

class DepartmentsDialog extends StatefulWidget {
  final UserModel user;

  const DepartmentsDialog({Key? key, required this.user}) : super(key: key);

  @override
  _DepartmentsDialogState createState() => _DepartmentsDialogState();
}

class _DepartmentsDialogState extends State<DepartmentsDialog> {
  List<String> departments = [];
  String? selectedDepartment;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchDepartments();
  }

  Future<void> _fetchDepartments() async {

      departments = await AdminService.getDepartmentsForUser();
      setState(() {});

  }

  void _addDepartment() {
    if (_controller.text.isNotEmpty) {
      final newDepartment = _controller.text.trim();
      final adminService = AdminService();

      adminService.addDepartmentToUser(newDepartment).then((_) {
        setState(() {
          departments.add(newDepartment);
          _controller.clear();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Зробити ${widget.user.name} керівником?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: selectedDepartment,
            hint: const Text("Оберіть відділ"),
            items: departments.map((department) {
              return DropdownMenuItem<String>(
                value: department,
                child: Text(department),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedDepartment = value;
              });
            },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Додати новий відділ',
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.topRight,
            child: ElevatedButton(
              onPressed: _addDepartment,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              child: const Text('Додати відділ',
              style: TextStyle(
                color: Colors.white
              ),),
            ),
          )

        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            AdminService.makeNewManager(widget.user.id!, selectedDepartment!);
            Navigator.of(context).pop();
          },
          child: const Text('Зробити керівником', style: TextStyle(fontSize: 16),),
        ),
      ],
    );
  }
}
