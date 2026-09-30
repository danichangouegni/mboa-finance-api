import '../core/app_texts.dart';

class ApiErrorTranslator {

  static String translate(
    String? code,
    AppTexts texts,
  ) {

    switch (code) {

      case "REQUIRED_FIELDS":
        return texts.requiredFields;

      case "INVALID_EMAIL":
        return texts.invalidEmail;

      case "EMAIL_ALREADY_EXISTS":
        return texts.emailAlreadyExists;

      case "INVALID_PASSWORD":
        return texts.invalidPassword;

      case "INVALID_CREDENTIALS":
        return texts.emailOrPasswordIncorrect;

      case "INVALID_RESET_CODE":
        return texts.invalidResetCode;

      case "SERVER_ERROR":
        return texts.serverError;
      case "RESET_CODE_SENT":
      return texts.resetCodeSent;

      
      case "EMAIL_ALREADY_EXISTS":
        return texts.emailAlreadyExists;

      case "EMAIL_NOT_FOUND":
        return texts.emailNotFound;

      default:
        return texts.serverError;

    }

  }

}