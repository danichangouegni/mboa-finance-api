class CategoryHelper {

  static String normalize(
    String category,
  ) {

    final value =
        category
            .trim()
            .toLowerCase();

    // TRANSPORT

if (
  value.contains("transport") ||
  value.contains("taxi") ||
  value.contains("moto") ||
  value.contains("bus") ||
  value.contains("uber") ||
  value.contains("yango") ||
  value.contains("carburant") ||
  value.contains("essence") ||
  value.contains("péage") ||
  value.contains("peage")
) {
  return "transport";
}

// ALIMENTATION

if (
  value.contains("restaurant") ||
  value.contains("repas") ||
  value.contains("riz") ||
  value.contains("pain") ||
  value.contains("poisson") ||
  value.contains("marché") ||
  value.contains("marche") ||
  value.contains("viande") ||
  value.contains("déjeuner") ||
  value.contains("dejeuner")
) {
  return "food";
}

    // LOGEMENT

    if (
      value.contains("loyer") ||
      value.contains("maison") ||
      value.contains("eau") ||
      value.contains("electricite") ||
      value.contains("électricité") ||
      value.contains("housing") ||
      value.contains("logement")
    ) {
      return "housing";
    }

    // SANTE

    if (
      value.contains("hopital") ||
      value.contains("hôpital") ||
      value.contains("clinique") ||
      value.contains("medicament") ||
      value.contains("médicament") ||
      value.contains("pharmacie") ||
      value.contains("health") ||
      value.contains("santé") ||
      value.contains("sante")
    ) {
      return "health";
    }

  // COMMUNICATION

    if (
    value.contains("orange") ||
    value.contains("mtn") ||
    value.contains("camtel") ||
    value.contains("internet") ||
    value.contains("wifi") ||
    value.contains("forfait") ||
    value.contains("crédit") ||
    value.contains("credit")
    ) {
    return "communication";
    }
    // EDUCATION

    if (
      value.contains("education") ||
        value.contains("éducation") ||
        value.contains("ecole") ||
        value.contains("école") ||
        value.contains("universite") ||
        value.contains("université") ||
        value.contains("formation") ||
        value.contains("livre")
    ) {
      return "education";
    }

    // LOISIRS

    if (
        value.contains("leisure") ||
        value.contains("loisirs") ||
      value.contains("voyage") ||
      value.contains("football") ||
      value.contains("cinema") ||
      value.contains("cinéma") ||
      value.contains("sortie")
    ) {
      return "leisure";
    }

    if (
  value.contains("epargne") ||
  value.contains("épargne") ||
  value.contains("saving")
) {
  return "savings";
}

if (
  value.contains("investissement") ||
  value.contains("investment") ||
  value.contains("action") ||
  value.contains("crypto")
) {
  return "investment";
}
    return "others";
  }

static String canonicalCategory(
  String category,
) {
  return normalize(category);
}
}