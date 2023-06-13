import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  const RoundButton(
      {Key? key,
      required this.title,
      required this.onTap,
      required this.loading})
      : super(key: key);
  final String title;
  final Function onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Text(
                title,
                style:const TextStyle(color: Colors.white,fontSize: 25,),
              ),
      ),
    );
  }
}
