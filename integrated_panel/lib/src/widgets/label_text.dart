import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({super.key,required this.content,required this.type});
  final String content;
  final TextType type;

  @override
  Widget build(BuildContext context) {
    switch (type){
      case TextType.label:
        return Text(content, style: Theme.of(context).textTheme.bodyLarge,
         );
      case TextType.header:
        return Text(content, style: Theme.of(context).textTheme.headlineMedium,
        );
      case TextType.normal:
        return Text(content,style:  Theme.of(context).textTheme.headlineSmall
        );
    }
      
  }
}



enum TextType{
  label,
  header,
  normal,
}