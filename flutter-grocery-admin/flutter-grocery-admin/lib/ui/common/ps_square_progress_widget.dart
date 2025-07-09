import 'package:flutter/material.dart';

class PsSquareProgressWidget extends StatelessWidget {
  const PsSquareProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox( 
      width : 25, 
      height : 25,       
      child: const LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.black12),
        backgroundColor: Colors.black12    
      ),
    );
  }
}