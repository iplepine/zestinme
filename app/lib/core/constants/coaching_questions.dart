class CoachingQuestions {
  static const Map<String, List<String>> _questions = {
    // --- RED ZONE ---

    // Angry, Annoyed, Resentful (Boundaries Violated)
    'Angry': _angryQuestions,
    'Annoyed': _angryQuestions,
    'Resentful': _angryQuestions,

    // Anxious, Overwhelmed (Threat/Fear)
    'Anxious': _anxiousQuestions,
    'Overwhelmed': _anxiousQuestions,

    // Jealous (Resources/Relationship)
    'Jealous': _jealousQuestions,

    // --- BLUE ZONE ---

    // Sad, Disappointed (Loss)
    'Sad': _sadQuestions,
    'Disappointed': _sadQuestions,

    // Bored, Lonely, Envious (Lack/Connection)
    'Bored': _boredQuestions,
    'Lonely': _lonelyQuestions,
    'Envious':
        _jealousQuestions, // Envy is similar to Jealousy in spec context or I can reuse
    'Guilty':
        _guiltyQuestions, // Not explicitly in spec details above but implies moral standard
    // --- YELLOW ZONE ---

    // Excited, Enthusiastic, Amused (Passion/Energy)
    'Excited': _passionQuestions,
    'Enthusiastic': _passionQuestions,
    'Amused': _passionQuestions,

    // Proud (Achievement)
    'Proud': _achievementQuestions,

    // Inspired, Curious (Vision/Growth)
    'Inspired': _inspirationQuestions,
    'Curious': _inspirationQuestions,

    // --- GREEN ZONE ---

    // Relaxed, Serene (Peace)
    'Relaxed': _peaceQuestions,
    'Serene': _peaceQuestions,

    // Grateful, Content, Trusting, Reflective (Satisfaction)
    'Grateful': _gratitudeQuestions,
    'Content': _gratitudeQuestions,
    'Trusting': _gratitudeQuestions,
    'Reflective': _peaceQuestions,
  };

  static String getQuestionForTag(String tag) {
    // Default to generic if not found
    final list = _questions[tag] ?? _genericQuestions;
    // Use spread operator to create a mutable copy before shuffling
    return ([...list]..shuffle()).first;
  }

  // --- Question Lists ---

  static const List<String> _angryQuestions = [
    "지금 이 상황에서 '이것만은 지켜졌어야 했다'고 생각하는 것은 무엇인가요?",
    "상대방이 나의 어떤 부분을 가볍게 여겼다고 느껴지나요?",
    "내가 만약 이 상황을 그냥 넘긴다면, 내 모습이 어떻게 비춰질까 봐 걱정되나요?",
    "이 분노가 나에게 어떤 행동을 하라고 부추기고 있나요?",
  ];

  static const List<String> _anxiousQuestions = [
    "최악의 상황을 상상했을 때, 내가 잃어버릴까 봐 가장 두려운 것은 무엇인가요?",
    "내가 통제할 수 없는 것을 통제하려 하고 있지는 않나요?",
    "이 불안감을 해결하기 위해 지금 당장 내가 할 수 있는 아주 작은 행동 하나는 무엇인가요?",
    "내가 만약 완벽하게 안전하다고 느낀다면, 지금 무엇을 하고 싶은가요?",
  ];

  static const List<String> _jealousQuestions = [
    "저 사람이 가진 것 중, 솔직히 나도 갖고 싶어서 배가 아픈 것은 정확히 무엇인가요?",
    "나는 그것을 가질 자격이 없다고 스스로 믿고 있지는 않나요?",
    "그것을 얻기 위해 나는 어떤 대가를 치를 준비가 되어 있나요?",
  ];

  static const List<String> _sadQuestions = [
    "무엇이 내 삶에서 빠져나간 것 같은 느낌이 드나요?",
    "그것이 없어서 내 삶이 빈껍데기 같다고 느낀다면, 그것은 나에게 어떤 의미였나요?",
    "지금 이 슬픔을 충분히 느끼지 않고 억누른다면, 나는 무엇을 잃게 될까요?",
  ];

  static const List<String> _boredQuestions = [
    // Mapped to Burnout/Tired partly or Lack of Meaning
    "나는 누구의 기대를 만족시키기 위해 이렇게 애쓰고 있나요?",
    "지금 당장 모든 의무가 사라진다면, 가장 먼저 하고 싶은(혹은 안 하고 싶은) 것은 무엇인가요?",
    "나를 충전시키는 활동과 방전시키는 활동의 비율은 어떠한가요?",
  ];

  static const List<String> _lonelyQuestions = [
    "나는 어떤 종류의 연결을 갈망하고 있나요? (이해받는 것? 함께 하는 것?)",
    "내가 진정으로 나답게 있을 수 있는 관계는 어디인가요?",
  ];

  static const List<String> _guiltyQuestions = [
    "내가 어겼다고 생각하는 나만의 원칙은 무엇인가요?",
    "그 행동을 할 수밖에 없었던 상황적 이유는 없었나요?",
    "이번 일을 통해 내가 더 지키고 싶어진 가치는 무엇인가요?",
  ];

  static const List<String> _passionQuestions = [
    "시간 가는 줄 모르고 했던 이 행동의 어떤 요소가 나를 자극했나요?",
    "이 순간 내가 '살아있다'고 느끼게 해 준 핵심적인 경험은 무엇인가요?",
    "이 에너지를 활용해서 더 확장해보고 싶은 나의 능력은 무엇인가요?",
  ];

  static const List<String> _achievementQuestions = [
    "오늘의 성과 중 나 스스로 가장 칭찬해주고 싶은 부분은 무엇인가요?",
    "이 성취가 나에게 중요한 이유는 남들의 인정 때문인가요, 아니면 나 스스로의 만족 때문인가요?",
    "이 경험을 통해 확인한 나의 강점은 무엇인가요?",
  ];

  static const List<String> _inspirationQuestions = [
    "이 새로운 아이디어가 나를 설레게 하는 이유는 무엇인가요?",
    "이 호기심을 따라가면 내 삶의 어떤 부분이 성장할 것 같은가요?",
  ];

  static const List<String> _peaceQuestions = [
    "지금 내 마음을 고요하게 만드는 환경적/심리적 조건은 무엇인가요?",
    "어떤 걱정을 내려놓았더니 이런 평화가 찾아왔나요?",
    "이 평온함을 지키기 위해 나는 일상에서 무엇을 보호해야 할까요?",
  ];

  static const List<String> _gratitudeQuestions = [
    "당연하다고 생각했는데 다시 보니 선물처럼 느껴지는 것은 무엇인가요?",
    "지금 가진 것만으로도 충분하다고 느낀다면, 그 이유는 무엇인가요?",
    "이 고마운 마음을 누구에게, 어떻게 표현하고 싶은가요?",
  ];

  static const List<String> _genericQuestions = [
    "지금 이 감정이 나에게 말해주고 싶은 것은 무엇일까요?",
    "이 감정을 통해 내가 중요하게 생각하는 것이 무엇인지 알 수 있나요?",
    "오늘 하루 중 가장 기억에 남는 순간은 언제였나요?",
  ];
}
