class CoachingQuestions {
  /// Returns a question for the given [tag] and [stage] (0, 1, 2).
  /// [stage] 0 = Mirroring/Grounding (Somatic)
  /// [stage] 1 = Expansion/Differentiation (Cognitive)
  /// [stage] 2 = Core Need/Values (Deep)
  static String getQuestion(String tag, int stage) {
    if (!_questions.containsKey(tag)) {
      // Fallback to generic if tag not found
      return _getGenericQuestion(stage);
    }

    final stages = _questions[tag]!;
    if (stage >= stages.length) {
      return (List.of(
        stages.last,
      )..shuffle()).first; // Fallback to last available stage
    }

    final questions = stages[stage];
    // Return a random question from the list for variety
    return (List.of(questions)..shuffle()).first;
  }

  static String _getGenericQuestion(int stage) {
    switch (stage) {
      case 0:
        return (List.of(_genericStage1)..shuffle()).first;
      case 1:
        return (List.of(_genericStage2)..shuffle()).first;
      case 2:
        return (List.of(_genericStage3)..shuffle()).first;
      default:
        return _genericStage1.first;
    }
  }

  // --- Data Structure ---
  // Key: Emotion Tag
  // Value: List of List of Strings (Stages -> Questions)
  static const Map<String, List<List<String>>> _questions = {
    // --- RED ZONE (Anger) ---
    'Angry': [
      // Stage 1: Mirroring (Validation)
      [
        "아까 '{context}'라고 적으셨네요.\n지금 다시 읽어보니 어떤 느낌이 드나요?",
        "'{context}'... 이 문장을 소리 내어 읽었을 때, 몸의 어느 부분에서 반응이 오나요?",
        "'{context}'라고 기록할 당시의 나에게, 지금의 내가 해주고 싶은 말이 있나요?",
      ],
      // Stage 2: Expansion (Analysis)
      [
        "지금 이 상황에서 '이것만은 지켜졌어야 했다'고 생각하는 것은 무엇인가요?",
        "이 분노가 나에게 어떤 행동을 하라고 부추기고 있나요?",
        "혹시 이 분노 뒤에 숨어있는 다른 감정(억울함, 슬픔 등)은 없나요?",
      ],
      // Stage 3: Core Need (Values)
      [
        "내가 진정으로 원했던 것은 '사과'인가요, 아니면 '존중'인가요?",
        "이 상황에서 내가 지키고 싶었던 나의 중요한 가치는 무엇인가요?",
        "이 에너지를 상대를 공격하는 대신, 나를 보호하는 데 쓴다면 어떻게 할 수 있을까요?",
      ],
    ],

    // --- RED ZONE (Anxiety) ---
    'Anxious': [
      // Stage 1
      [
        "아까 '{context}'라고 기록했었죠.\n지금은 그 마음의 크기가 조금 달라졌나요?",
        "'{context}'... 이 걱정이 내 머릿속에서 얼마나 많은 공간을 차지하고 있나요?",
        "잠시 심호흡을 하고 '{context}'를 다시 바라보세요. 무엇이 보이나요?",
      ],
      // Stage 2
      [
        "최악의 상황을 상상했을 때, 내가 잃어버릴까 봐 가장 두려운 것은 무엇인가요?",
        "내가 통제할 수 없는 것을 통제하려 하고 있지는 않나요?",
        "이 불안감을 해결하기 위해 지금 당장 내가 할 수 있는 아주 작은 행동 하나는 무엇인가요?",
      ],
      // Stage 3
      [
        "내가 만약 완벽하게 안전하다고 느낀다면, 지금 무엇을 하고 싶나요?",
        "이 불안함이 나에게 '준비하라'고 신호를 보내는 것이라면, 무엇을 준비하면 될까요?",
        "지금 나에게 가장 필요한 위로는 어떤 말인가요?",
      ],
    ],

    // --- BLUE ZONE (Sadness) ---
    'Sad': [
      // Stage 1
      [
        "'{context}'... 이 글에서 어떤 물기(눈물)가 느껴지나요?",
        "아까 '{context}'라고 적을 때, 내 어깨는 무거웠나요, 아니면 축 처져 있었나요?",
        "이 슬픔을 있는 그대로 잠시 안아준다면, 어떤 표정을 지을까요?",
      ],
      // Stage 2
      [
        "무엇이 내 삶에서 빠져나간 것 같은 느낌이 드나요?",
        "지금 이 슬픔을 충분히 느끼지 않고 억누른다면, 나는 무엇을 잃게 될까요?",
        "이 슬픔이 지나가고 나면, 나는 어떤 사람으로 성장해 있을까요?",
      ],
      // Stage 3
      [
        "나를 위로하기 위해 지금 당장 해줄 수 있는 따뜻한 밥 한 끼 같은 행동은 무엇인가요?",
        "이 빈자리를 채우기 위해 내가 스스로에게 줄 수 있는 선물은 무엇인가요?",
        "슬픔이 바닥나면 그 곳에 무엇을 채우고 싶나요?",
      ],
    ],

    // --- YELLOW ZONE (Excitement) ---
    'Excited': [
      // Stage 1
      [
        "'{context}'! 다시 봐도 가슴이 뛰나요?",
        "이 에너지를 색깔로 표현한다면 무슨 색일까요?",
        "'{context}'라고 적는 순간, 내 표정은 어땠나요?",
      ],
      // Stage 2
      [
        "시간 가는 줄 모르고 했던 이 행동의 어떤 요소가 나를 자극했나요?",
        "이 순간 내가 '살아있다'고 느끼게 해 준 핵심적인 경험은 무엇인가요?",
        "이 설렘이 내일의 나에게 어떤 영감을 줄 수 있을까요?",
      ],
      // Stage 3
      [
        "이 에너지를 활용해서 더 확장해보고 싶은 나의 능력은 무엇인가요?",
        "이 기쁨을 누구와 가장 먼저 나누고 싶나요? 그 이유는 무엇인가요?",
        "내가 정말로 좋아하는 내 모습은 어떤 모습인가요?",
      ],
    ],

    // --- GREEN ZONE (Peace/Gratitude) ---
    'Grateful': [
      // Stage 1
      [
        "'{context}'... 읽기만 해도 마음이 편안해지나요?",
        "이 고마움을 떠올릴 때, 내 가슴의 온도는 몇 도쯤 되나요?",
        "아까 느꼈던 그 감사를 지금 다시 한 번 깊게 들이마셔 보세요.",
      ],
      // Stage 2
      [
        "당연하다고 생각했는데 다시 보니 선물처럼 느껴지는 것은 무엇인가요?",
        "지금 가진 것만으로도 충분하다고 느낀다면, 그 이유는 무엇인가요?",
        "어떤 걱정을 내려놓았더니 이런 평화가 찾아왔나요?",
      ],
      // Stage 3
      [
        "이 고마운 마음을 누구에게, 어떻게 표현하고 싶은가요?",
        "이 평온함을 지키기 위해 나는 일상에서 무엇을 보호해야 할까요?",
        "오늘의 이 감사가 내일의 나를 어떻게 지탱해 줄까요?",
      ],
    ],
  };

  // --- Generics ---
  static const List<String> _genericStage1 = [
    "아까 '{context}'라고 기록했었죠. 지금은 기분이 좀 어때요?",
    "'{context}'... 다시 읽어보니 어떤 생각이 가장 먼저 드나요?",
    "그 때의 감정을 날씨로 비유하면 어떤 날씨였나요?",
  ];

  static const List<String> _genericStage2 = [
    "지금 이 감정이 나에게 말해주고 싶은 것은 무엇일까요?",
    "이 감정의 원인이 만약 '나'에게 있디면, 그것은 무엇일까요?",
    "이 감정의 원인이 만약 '외부'에 있다면, 그것은 무엇일까요?",
  ];

  static const List<String> _genericStage3 = [
    "이 감정을 통해 내가 중요하게 생각하는 가치가 무엇인지 알 수 있나요?",
    "지금 나에게 가장 필요한 것은 '휴식'인가요, 아니면 '해결'인가요?",
    "내일의 내가 오늘의 나를 본다면 뭐라고 해줄까요?",
  ];
}
