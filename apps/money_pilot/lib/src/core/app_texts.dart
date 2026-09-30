class AppTexts {

  final String language;

  AppTexts(this.language);

  bool get isFrench =>
      language == "Français";

  String get dashboard =>
      isFrench
          ? "Tableau de bord"
          : "Dashboard";

  String get transactions =>
      isFrench
          ? "Transactions"
          : "Transactions";

  String get goals =>
      isFrench
          ? "Objectifs"
          : "Goals";

  String get debts =>
      isFrench
          ? "Dettes"
          : "Debts";

  String get activity =>
      isFrench
          ? "Mon activité"
          : "My Activity";

  String get settings =>
      isFrench
          ? "Paramètres"
          : "Settings";

    String get balance =>
    isFrench
        ? "Solde disponible"
        : "Available Balance";
    

String get expenses =>
    language == "Français"
        ? "Dépenses"
        : "Expenses";

String get income =>
    language == "Français"
        ? "Revenus"
        : "Income";

String get today =>
    language == "Français"
        ? "Aujourd'hui"
        : "Today";

String get yesterday =>
    language == "Français"
        ? "Hier"
        : "Yesterday";

String get edit =>
    language == "Français"
        ? "Modifier"
        : "Edit";

String get delete =>
    language == "Français"
        ? "Supprimer"
        : "Delete";

String get cancel =>
    language == "Français"
        ? "Annuler"
        : "Cancel";

String get deleteTransaction =>
    language == "Français"
        ? "Supprimer cette transaction ?"
        : "Delete this transaction?";

String get statistics =>
    isFrench
        ? "Statistiques"
        : "Statistics";


String get addExpense =>
    isFrench
        ? "Ajouter une dépense"
        : "Add Expense";

String get amount =>
    isFrench
        ? "Montant"
        : "Amount";

String get category =>
    isFrench
        ? "Catégorie"
        : "Category";

String get paymentMethod =>
    isFrench
        ? "Moyen de paiement"
        : "Payment Method";

String get date =>
    isFrench
        ? "Date"
        : "Date";

String get note =>
    isFrench
        ? "Note"
        : "Note";

String get save =>
    isFrench
        ? "Enregistrer"
        : "Save";

String get orangeMoney => "Orange Money";

String get mtnMoney =>
    isFrench
        ? "MTN Mobile Money"
        : "MTN Mobile Money";

String get cash =>
    isFrench
        ? "Espèces"
        : "Cash";

String get bankCard =>
    isFrench
        ? "Carte bancaire"
        : "Bank Card";

String get transfer =>
    isFrench
        ? "Virement"
        : "Bank Transfer";


String get addDebt =>
    isFrench
        ? "Ajouter une dette"
        : "Add Debt";

String get personName =>
    isFrench
        ? "Nom de la personne"
        : "Person Name";

String get debtDescription =>
    isFrench
        ? "Description"
        : "Description";

String get dueDate =>
    isFrench
        ? "Date d'échéance"
        : "Due Date";

String get debtType =>
    isFrench
        ? "Type de dette"
        : "Debt Type";

String get oweMe =>
    isFrench
        ? "À me devoir"
        : "Owes Me";

String get iOwe =>
    isFrench
        ? "Je dois"
        : "I Owe";

String get tontines =>
    isFrench
        ? "Tontines"
        : "Tontines";

String get nextRound =>
    isFrench
        ? "Prochain tour"
        : "Next Round";

String get contributors =>
    isFrench
        ? "Cotisants"
        : "Contributors";

String get viewDetails =>
    isFrench
        ? "Voir les détails"
        : "View Details";

String get members =>
    isFrench
        ? "membres"
        : "members";

String get months =>
    isFrench
        ? "mois"
        : "months";

String perMonth(
  String currency,
) =>
    isFrench
        ? "$currency / mois"
        : "$currency / month";

String get addBeneficiary =>
    isFrench
        ? "Ajouter un bénéficiaire"
        : "Add Beneficiary";

String get beneficiaryName =>
    isFrench
        ? "Nom du bénéficiaire"
        : "Beneficiary Name";

String get tourDate =>
    isFrench
        ? "Date du tour"
        : "Round Date";

String get observation =>
    isFrench
        ? "Observation"
        : "Observation";

String get contribution =>
    isFrench
        ? "Cotisation"
        : "Contribution";

String get expectedGain =>
    isFrench
        ? "Gain attendu"
        : "Expected Gain";

String get progress =>
    isFrench
        ? "Progression"
        : "Progress";

String get noBeneficiaryYet =>
    isFrench
        ? "Aucun bénéficiaire encore"
        : "No beneficiary yet";

String get lastBeneficiary =>
    isFrench
        ? "Dernier bénéficiaire"
        : "Last Beneficiary";

String get distributedAmount =>
    isFrench
        ? "Montant déjà distribué"
        : "Distributed Amount";

String get remainingAmount =>
    isFrench
        ? "Montant restant"
        : "Remaining Amount";

String get cycleCompleted =>
    isFrench
        ? "Cycle terminé"
        : "Cycle Completed";

String get beneficiariesHistory =>
    isFrench
        ? "Historique des bénéficiaires"
        : "Beneficiaries History";

String get deleteBeneficiary =>
    isFrench
        ? "Supprimer bénéficiaire"
        : "Delete Beneficiary";

String get deleteBeneficiaryQuestion =>
    isFrench
        ? "Supprimer ce bénéficiaire ?"
        : "Delete this beneficiary?";

String get editBeneficiary =>
    isFrench
        ? "Modifier bénéficiaire"
        : "Edit Beneficiary";

String get name =>
    isFrench
        ? "Nom"
        : "Name";

String get add =>
    isFrench
        ? "Ajouter"
        : "Add";

String get addTontine =>
    isFrench
        ? "Ajouter une tontine"
        : "Add Tontine";

String get noTontine =>
    isFrench
        ? "Aucune tontine"
        : "No Tontine";

String get monthlyContribution =>
    isFrench
        ? "Cotisation mensuelle"
        : "Monthly Contribution";

String get tontineName =>
    isFrench
        ? "Nom de la tontine"
        : "Tontine Name";

String get membersCount =>
    isFrench
        ? "Nombre de membres"
        : "Number of Members";

String get deleteTontine =>
    isFrench
        ? "Supprimer la tontine"
        : "Delete Tontine";

String get deleteTontineQuestion =>
    isFrench
        ? "Voulez-vous supprimer cette tontine ?"
        : "Do you want to delete this tontine?";

String get editTontine =>
    isFrench
        ? "Modifier la tontine"
        : "Edit Tontine";

String get totalMobilized =>
    isFrench
        ? "Montant total mobilisé"
        : "Total Amount Mobilized";

String get debtRecorded =>
    isFrench
        ? "Dette enregistrée"
        : "Recorded debt";

String get addGoal =>
    isFrench
        ? "Ajouter un objectif"
        : "Add Goal";

String get editGoal =>
    isFrench
        ? "Modifier l'objectif"
        : "Edit Goal";

String get deleteGoal =>
    isFrench
        ? "Supprimer l'objectif"
        : "Delete Goal";

String get deleteGoalQuestion =>
    isFrench
        ? "Voulez-vous supprimer cet objectif ?"
        : "Do you want to delete this goal?";

String get goalTitle =>
    isFrench
        ? "Titre de l'objectif"
        : "Goal Title";

String get targetAmount =>
    isFrench
        ? "Montant cible"
        : "Target Amount";

String get currentAmount =>
    isFrench
        ? "Montant actuel"
        : "Current Amount";

String get targetDate =>
    isFrench
        ? "Date cible"
        : "Target Date";

String get activeGoals =>
    isFrench
        ? "Objectifs actifs"
        : "Active Goals";

String get completedGoals =>
    isFrench
        ? "Objectifs atteints"
        : "Completed Goals";

String get addContribution =>
    isFrench
        ? "Ajouter une contribution"
        : "Add Contribution";

String get contributionAmount =>
    isFrench
        ? "Montant de la contribution"
        : "Contribution Amount";

String get goalReached =>
    isFrench
        ? "Objectif atteint"
        : "Goal Reached";

String get remaining =>
    isFrench
        ? "Restant"
        : "Remaining";

String get noGoal =>
    isFrench
        ? "Aucun objectif"
        : "No Goal";

String get progressGoal =>
    isFrench
        ? "Progression"
        : "Progress";

String get editDebt =>
    isFrench
        ? "Modifier la dette"
        : "Edit debt";

String get notes => "Notes";


String get about =>
    language == "Français"
        ? "À propos"
        : "About";

String get notifications =>
    language == "Français"
        ? "Notifications"
        : "Notifications";

String get theme =>
    language == "Français"
        ? "Thème"
        : "Theme";

String get languageText =>
    language == "Français"
        ? "Langue"
        : "Language";

String get profile =>
    language == "Français"
        ? "Profil"
        : "Profile";

String get aboutTitle =>
    language == "Français"
        ? "À propos de Mboa Finance"
        : "About Mboa Finance";

String get aboutDescription =>
    language == "Français"
        ? "Mboa Finance est une application de gestion financière personnelle qui permet de suivre les revenus, les dépenses, les dettes, les tontines et les objectifs d'épargne."
        : "Mboa Finance is a personal finance management application that helps users track income, expenses, debts, tontines and savings goals.";

String get features =>
    language == "Français"
        ? "Fonctionnalités"
        : "Features";

String get howToUse =>
    language == "Français"
        ? "Comment utiliser l'application ?"
        : "How to use the application?";

String get support =>
    language == "Français"
        ? "Support"
        : "Support";

String get close =>
    language == "Français"
        ? "Fermer"
        : "Close";

String get incomeManagement =>
    isFrench
        ? "• Gestion des revenus"
        : "• Income management";

String get expenseManagement =>
    isFrench
        ? "• Gestion des dépenses"
        : "• Expense management";

String get debtManagement =>
    isFrench
        ? "• Gestion des dettes"
        : "• Debt management";

String get tontineManagement =>
    isFrench
        ? "• Gestion des tontines"
        : "• Tontine management";

String get savingsManagement =>
    isFrench
        ? "• Gestion des objectifs d'épargne"
        : "• Savings goals management";

String get financialDashboard =>
    isFrench
        ? "• Tableau de bord financier"
        : "• Financial dashboard";

String get financialStatistics =>
    isFrench
        ? "• Statistiques financières"
        : "• Financial statistics";

String get deadlineNotifications =>
    isFrench
        ? "• Notifications des échéances"
        : "• Due date notifications";

String get step1 =>
    isFrench
        ? "1. Ajoutez vos revenus et dépenses."
        : "1. Add your income and expenses.";

String get step2 =>
    isFrench
        ? "2. Créez vos objectifs d'épargne."
        : "2. Create your savings goals.";

String get step3 =>
    isFrench
        ? "3. Gérez vos dettes et tontines."
        : "3. Manage your debts and tontines.";

String get step4 =>
    isFrench
        ? "4. Consultez régulièrement votre tableau de bord."
        : "4. Check your dashboard regularly.";

String get supportText =>
    isFrench
        ? "Pour toute assistance ou suggestion :"
        : "For assistance or suggestions:";

String get requiredFields =>
    isFrench
        ? "Tous les champs sont obligatoires"
        : "All fields are required";

String get invalidEmail =>
    isFrench
        ? "Email invalide"
        : "Invalid email";

String get emailAlreadyExists =>
    isFrench
        ? "Cet email existe déjà"
        : "This email already exists";

String get invalidPassword =>
    isFrench
        ? "Mot de passe incorrect"
        : "Incorrect password";

String get emailOrPasswordIncorrect =>
    isFrench
        ? "Email ou mot de passe incorrect"
        : "Email or password is incorrect";

String get invalidResetCode =>
    isFrench
        ? "Code invalide"
        : "Invalid code";

String get serverError =>
    isFrench
        ? "Une erreur est survenue"
        : "An error occurred";

String get passwordUpdated =>
    isFrench
        ? "Mot de passe modifié"
        : "Password updated";

String get accountCreated =>
    isFrench
        ? "Compte créé avec succès"
        : "Account created successfully";

String get weakPassword =>
    isFrench
        ? "Le mot de passe doit contenir au moins 8 caractères, une majuscule, une minuscule et un chiffre."
        : "Password must contain at least 8 characters, one uppercase letter, one lowercase letter and one number.";

String get loginFieldsRequired =>
    isFrench
        ? "Email et mot de passe requis"
        : "Email and password are required";

String get resetCodeSent =>
    isFrench
        ? "Code envoyé par email"
        : "Verification code sent by email";

String get resetMailTitle =>
    isFrench
        ? "Réinitialisation du mot de passe"
        : "Password reset";
String get emailNotFound =>
    isFrench
        ? "Aucun compte associé à cette adresse email."
        : "No account is associated with this email address.";

String get currency =>
    isFrench
        ? "Devise"
        : "Currency";

String get currencySaved =>
    isFrench
        ? "Devise enregistrée"
        : "Currency saved";

String get transport =>
    isFrench
        ? "Transport"
        : "Transport";

String get food =>
    isFrench
        ? "Alimentation"
        : "Food";

String get housing =>
    isFrench
        ? "Logement"
        : "Housing";

String get health =>
    isFrench
        ? "Santé"
        : "Health";

String get communication =>
    isFrench
        ? "Communication"
        : "Communication";

String get education =>
    isFrench
        ? "Éducation"
        : "Education";

String get leisure =>
    isFrench
        ? "Loisirs"
        : "Leisure";

String get savings =>
    isFrench
        ? "Épargne"
        : "Savings";

String get investment =>
    isFrench
        ? "Investissement"
        : "Investment";

}
