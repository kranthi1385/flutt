class QuestionData {
  bool? isRoutable;
  String? internalName;
  TranslatedQuestion? translatedQuestion;
  String? childQuestions;
  List<TranslatedAnswers>? translatedAnswers;
  String? answerType;
  String? answerValidationRegularExpression;
  int? categoryID;

  QuestionData(
      {this.isRoutable,
      this.internalName,
      this.translatedQuestion,
      this.childQuestions,
      this.translatedAnswers,
      this.answerType,
      this.answerValidationRegularExpression,
      this.categoryID});

  QuestionData.fromJson(Map<String, dynamic> json) {
    isRoutable = json['IsRoutable'];
    internalName = json['InternalName'];
    translatedQuestion = json['TranslatedQuestion'] != null
        ? TranslatedQuestion.fromJson(json['TranslatedQuestion'])
        : null;
    childQuestions = json['ChildQuestions'];
    if (json['TranslatedAnswers'] != null) {
      translatedAnswers = <TranslatedAnswers>[];
      json['TranslatedAnswers'].forEach((v) {
        translatedAnswers!.add(TranslatedAnswers.fromJson(v));
      });
    }
    answerType = json['AnswerType'];
    answerValidationRegularExpression =
        json['AnswerValidationRegularExpression'];
    categoryID = json['CategoryID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['IsRoutable'] = isRoutable;
    data['InternalName'] = internalName;
    if (translatedQuestion != null) {
      data['TranslatedQuestion'] = translatedQuestion!.toJson();
    }
    data['ChildQuestions'] = childQuestions;
    if (translatedAnswers != null) {
      data['TranslatedAnswers'] =
          translatedAnswers!.map((v) => v.toJson()).toList();
    }
    data['AnswerType'] = answerType;
    data['AnswerValidationRegularExpression'] =
        answerValidationRegularExpression;
    data['CategoryID'] = categoryID;
    return data;
  }
}

class TranslatedQuestion {
  int? questionID;
  int? cultureID;
  String? displayNameTranslation;
  String? helpTextTranslation;
  String? samplingSequenceNumber;
  int? translationDisplayStatus;

  TranslatedQuestion(
      {this.questionID,
      this.cultureID,
      this.displayNameTranslation,
      this.helpTextTranslation,
      this.samplingSequenceNumber,
      this.translationDisplayStatus});

  TranslatedQuestion.fromJson(Map<String, dynamic> json) {
    questionID = json['QuestionID'];
    cultureID = json['CultureID'];
    displayNameTranslation = json['DisplayNameTranslation'];
    helpTextTranslation = json['HelpTextTranslation'];
    samplingSequenceNumber = json['SamplingSequenceNumber'];
    translationDisplayStatus = json['TranslationDisplayStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['QuestionID'] = questionID;
    data['CultureID'] = cultureID;
    data['DisplayNameTranslation'] = displayNameTranslation;
    data['HelpTextTranslation'] = helpTextTranslation;
    data['SamplingSequenceNumber'] = samplingSequenceNumber;
    data['TranslationDisplayStatus'] = translationDisplayStatus;
    return data;
  }
}

class TranslatedAnswers {
  int? answerID;
  String? translation;
  String? answerInternalName;

  TranslatedAnswers({this.answerID, this.translation, this.answerInternalName});

  TranslatedAnswers.fromJson(Map<String, dynamic> json) {
    answerID = json['AnswerID'];
    translation = json['Translation'];
    answerInternalName = json['AnswerInternalName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AnswerID'] = answerID;
    data['Translation'] = translation;
    data['AnswerInternalName'] = answerInternalName;
    return data;
  }
}
