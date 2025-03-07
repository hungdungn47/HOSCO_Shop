import 'package:flutter/material.dart';
import 'package:hosco_shop_2/utils/constants.dart';

class IosToggleButton extends StatefulWidget {
  final String leftText;
  final String rightText;
  final ValueChanged<bool> onChange;
  final initValue;

  const IosToggleButton({
    Key? key,
    required this.leftText,
    required this.rightText,
    required this.initValue,
    required this.onChange,
  }) : super(key: key);

  @override
  _IosToggleButtonState createState() => _IosToggleButtonState();
}

class _IosToggleButtonState extends State<IosToggleButton> {
  bool isOn = false;

  @override
  void initState() {
    // TODO: implement initState
    isOn = widget.initValue;
    super.initState();
  }
  void _toggleSwitch() {
    setState(() {
      isOn = !isOn;
    });
    widget.onChange(isOn); // Notify parent about the state change
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleSwitch,
      child: Container(
        width: 90,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.grey[300], // Static background color
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // Moving Toggle Circle (Behind the text)
            AnimatedAlign(
              duration: Duration(milliseconds: 250),
              alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: Container(
                  width: isOn ? 45 : 55,
                  height: 30,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),

            // Text Labels (Always on top)
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    widget.leftText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isOn ? FontWeight.w300 : FontWeight.bold,
                      color: isOn ? Colors.grey : Colors.white, // Always visible
                    ),
                  ),
                  Text(
                    " ${widget.rightText} ",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isOn ? FontWeight.bold : FontWeight.w300,
                      color: isOn ? Colors.white : Colors.grey, // Always visible
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
