class Survey {
  int? surveyID;
  String? name;
  String? uRL;
  String? duration;
  int? iR;
  double? memberAmount;
  double? partnerAmount;
  int? waveId;
  bool? isTqsSurvey;

  Survey(
      {this.surveyID,
      this.name,
      this.uRL,
      this.duration,
      this.iR,
      this.memberAmount,
      this.partnerAmount,
      this.waveId,
      this.isTqsSurvey});

Survey.fromMap(Map<String, dynamic> json) {
  surveyID = json['SurveyID'] as int?;
  name = json['Name'] as String?;
  uRL = json['URL'] as String?;
  duration = json['Duration'] as String?;
  iR = json['IR'] as int?;
  memberAmount = json['MemberAmount'] as double?;
  partnerAmount = json['PartnerAmount'] as double?;
  waveId = json['WaveId'] as int?;
  isTqsSurvey = json['IsTqsSurvey'] as bool?;
}

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SurveyID'] = surveyID;
    data['Name'] = name;
    data['URL'] = uRL;
    data['Duration'] = duration;
    data['IR'] = iR;
    data['MemberAmount'] = memberAmount;
    data['PartnerAmount'] = partnerAmount;
    data['WaveId'] = waveId;
    data['IsTqsSurvey'] = isTqsSurvey;
    return data;
  }
}
