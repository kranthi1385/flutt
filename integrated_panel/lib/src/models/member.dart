class Member {
  String? partnerGUID='';
  String? memberCode;
  bool? isActive;
  String? birthDate;
  String? postalCode;
  String? email;
  bool? isTest;
  List<RegistrationAnswers>? registrationAnswers;

  Member(
      {required this.memberCode,
      this.partnerGUID,
      this.isActive = true,
      this.birthDate,
      this.postalCode,
      this.email,
      this.isTest = false,
      this.registrationAnswers});

  Member.fromJson(Map<String, dynamic> json) {
    partnerGUID = json['PartnerGUID'];
    memberCode = json['MemberCode'];
    isActive = json['IsActive'];
    email = json['Email'];
    birthDate = json['BirthDate'];
    postalCode = json['PostalCode'];
    isTest = json['IsTest'];
    if (json['RegistrationAnswers'] != null) {
      registrationAnswers = <RegistrationAnswers>[];
      json['RegistrationAnswers'].forEach((v) {
        registrationAnswers!.add(RegistrationAnswers.fromJson(v));
      });
    }else {
      registrationAnswers = null;
    }
  }

  bool isValid(){
    return memberCode!.isNotEmpty && partnerGUID!.isNotEmpty;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['PartnerGUID'] = partnerGUID;
    data['MemberCode'] = memberCode;
    data['IsActive'] = isActive;
    data['BirthDate'] = birthDate;
    data["Email"] = email;
    data['PostalCode'] = postalCode;
    data['IsTest'] = isTest;
    if (registrationAnswers != null) {
      data['RegistrationAnswers'] =
          registrationAnswers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RegistrationAnswers {
  int? questionID;
  List<Answers>? answers;

  RegistrationAnswers({this.questionID, this.answers});

  RegistrationAnswers.fromJson(Map<String, dynamic> json) {
    questionID = json['QuestionID'];
    if (json['Answers'] != null) {
      answers = <Answers>[];
      json['Answers'].forEach((v) {
        answers!.add(Answers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['QuestionID'] = questionID;
    if (answers != null) {
      data['Answers'] = answers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Answers {
  int? answerID;
  String? answerValue;
  Answers({this.answerID,this.answerValue});

  Answers.fromJson(Map<String, dynamic> json) {
    answerID = json['AnswerID'];
    answerValue = json['AnswerValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AnswerID'] = answerID;
    data['AnswerValue'] = answerValue ;
    return data;
  }
}
