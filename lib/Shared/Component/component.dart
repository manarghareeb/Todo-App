import 'package:flutter/material.dart';

Widget textFormField({
  required String label,
  required IconData icon,
  required TextEditingController controller,
  required TextInputType type,
  required var validate,
  var onTap,
  var isClickable = true,
}) =>
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        enabled: isClickable,
        controller: controller,
        keyboardType: type,
        validator: validate,
        onTap: onTap,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          label: Text(label),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );

Widget buildTaskItem() => const Padding(
      padding: EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.purple,
            child: Text(
              '02:00 PM',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Task Name',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                '2 Apr 2022',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
