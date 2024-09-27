import 'package:flutter/material.dart';
import 'package:integrated_panel/src/widgets/label_text.dart';

class SurveyCard extends StatelessWidget {
  final String surveyId;
  final String surveyName;
  final String reward;
  final String date;
  final String surveyUrl;
  final Function() onTakeSurvey;

  const SurveyCard({
    super.key,
    required this.surveyId,
    required this.surveyName,
    required this.reward,
    required this.date,
    required this.surveyUrl,
    required this.onTakeSurvey,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(15.0),
      // ),
      color: Theme.of(context).cardColor,
      elevation: 4.0,
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(20, 0, 10, 2),
        title: Text(
          surveyName,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("#$surveyId", style: const TextStyle(color: Colors.grey)),
            Row(
              children: [
                const Icon(
                  Icons.card_giftcard,
                  size: 16,
                  color: Colors.orange,
                ),
                const SizedBox(width: 4),
                CustomText(content:reward,type: TextType.normal,)
                // Text(
                //   reward, // Assuming reward is 0.0 or a positive number
                //   style: const TextStyle(
                //     fontSize: 16.0,
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.schedule, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                CustomText(content:"$date min",type: TextType.normal,),
                // Text(
                //   "$date min",
                //   style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                // ),
              ],
            ),
          ],
        ),
        trailing: IconButton.filledTonal(
          
          onPressed: onTakeSurvey,
          tooltip: "survey",
          icon: const Icon(Icons.arrow_forward),
        ),
      ),
    );
  }

}
