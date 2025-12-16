# Feature 04: Sleep Optimization (Vibe Coding Standard)

| Attribute | Value |
| :--- | :--- |
| **Version** | 2.0 (Vibe Coding Edition) |
| **Status** | Final Draft |
| **Last Updated** | 2025-12-14 |
| **Related UI** | `spec/50-ui/04-sleep-screen.md` |
| **Tech Stack** | Flutter, Isar (Local DB), Riverpod |

## 1. 서론: 프로젝트 정의 및 개발 철학

### 1.1 프로젝트 배경 및 목표
현대인의 수면 문제는 단순한 불면을 넘어, 생체 리듬(Circadian Rhythm)과 사회적 일정(Social Schedule)의 부조화에서 비롯됩니다. 본 프로젝트 **'SleepSync' (Mind-Gardener Sleep Module)**는 단순한 수면 추적을 넘어, **'언제 자고 언제 일어나는 것이 최적인가'**를 과학적으로 제안하는 것을 목표로 합니다.

**바이브코딩(Vibe Coding)** 철학을 기반으로, AI 에이전트가 명확히 실행할 수 있는 수학적 알고리즘과 로직을 정의합니다.

### 1.2 핵심 가치 제안 (Value Proposition)
1.  **Optimal Sleep Window (Golden Hour):** 90분 수면 사이클과 기분(Mood) 데이터를 결합하여 최적의 취침/기상 시간을 역산.
2.  **Social Jetlag Diagnosis:** 주중/주말 수면 불일치 분석 및 만성 피로 원인 시각화.
3.  **Sensor Fusion:** 가속도 센서와 시간 로그를 결합한 비침습적 수면 분석.

## 2. 과학적 알고리즘 및 로직 명세 (The Algorithmic Core)

### 2.1 최적 수면 시간 산출 (Golden Hour Calculator)
사용자의 기상 목표 시간($T_{wake}$)을 기준으로 수면 관성(Sleep Inertia)을 최소화하는 취침 시간($T_{bed}$)을 역산합니다.

*   **변수 정의:**
    *   $T_{wake}$: 목표 기상 시간 (User Input)
    *   $L_{latency}$: 입면 잠복기 (Default: 15min)
    *   $C_{duration}$: 수면 사이클 길이 (Default: 90min)
    *   $N_{cycles}$: 목표 사이클 수 (5 cycles = 7.5h)

*   **Logic:**
    *   **Option A (Optimal, 5 cycles):** $T_{bed} = T_{wake} - (5 \times 90) - 15$
    *   **Option B (Sufficient, 6 cycles):** $T_{bed} = T_{wake} - (6 \times 90) - 15$
    *   **Option C (Minimal, 4 cycles):** $T_{bed} = T_{wake} - (4 \times 90) - 15$

### 2.2 크로노타입 및 사회적 시차 (MCTQ based)
*   **MSF (Mid-Sleep on Free days):** 휴일 수면의 중간점.
*   **SJL (Social Jetlag):** $| MSF - MSW |$ (휴일 중간점 - 평일 중간점).
*   **Insight:** $SJL \ge 1h$ 일 경우 "해외여행 수준의 시차 피로" 경고.

### 2.3 수면 효율 (Sleep Efficiency, SE)
*   **Formula:** $SE = \frac{Total Sleep Time (TST)}{Time In Bed (TIB)} \times 100$
    *   $TIB$: 침대에 누운 시간 ~ 침대에서 나온 시간
    *   $TST$: $TIB - (Sleep Latency + WASO)$
*   **Evaluation:**
    *   $\ge 90\%$: 매우 좋음 (Green)
    *   $85 \sim 89\%$: 정상 (Yellow)
    *   $< 85\%$: 효율 저하 (Red)

## 3. 데이터베이스 스키마 (Isar Schema)

Isar NoSQL 데이터베이스를 사용하여 로컬 중심의 데이터를 관리합니다.

```dart
@collection
class SleepRecord {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime date; // 기록 기준 날짜 (기상일)

  late DateTime inBedTime; // 침대에 누운 시간 (Behavior)
  late DateTime wakeTime; // 침대에서 일어난 시간 (Out of Bed Time)
  
  // 과학적 분석용 필드
  DateTime? lightsOutTime; // 불 끄고 잠을 청한 시간 (수면 시도)
  int? sleepLatencyMinutes; // 잠들기까지 걸린 시간 (Difference)
  
  // 계산된 메트릭 (Derived)
  // sleepOnsetTime = inBedTime + sleepLatencyMinutes (State: 실제 잠든 시간)
  int? wasoMinutes; // 수면 중 깬 시간 합계 (Wake After Sleep Onset)
  
  int durationMinutes = 0; // 총 수면 시간 (TST)
  double? sleepEfficiency; // 수면 효율 (%)

  // 주관적 평가
  int qualityScore = 3; // 1-5 Scale (기분/개운함)
  int? selfRefreshmentScore; // 0-100 (모닝 체크인 상세 점수)
  
  // 플래그
  bool isNaturalWake = false; // 알람 없이 기상 여부
  int snoozeCount = 0; // 스누즈 횟수
  
  List<String> tags = []; // 수면 영향 태그
}
```

## 4. 상세 기능 명세 (Functional Specs)

### 4.1 수면 추적 (Manual & Sensor Fusion Support)
*   **Manual:** 사용자가 `inBedTime`과 `wakeTime`을 직접 수정.
*   **Sensor (Future):** 가속도 센서(Accelerometer) 데이터를 활용하여 움직임이 없는 구간을 $TST$로 추정.

### 4.2 스마트 알람 (Rule-based)
*   **Logic:** 기상 시간 30분 전부터 움직임이 감지되면(얕은 수면) 알람 울림.
*   **Adaptive Snooze:** 스누즈 시 다음 알람은 9분이 아닌 10~20분(렘수면 고려) 뒤로 조정 가능.

### 4.3 수면-기분 상관 분석
*   `selfRefreshmentScore`가 80점 이상인 날들의 $T_{bed}$ 평균을 **"Golden Hour"**로 제시.

### 4.4 수면 빚 (Sleep Debt)
*   최근 14일간 `(Target Sleep Time - TST)` 누적값 시각화.

### 4.5 수면 영향 태그 시스템
다음 4가지 카테고리로 태그를 분류하여 기록합니다.

1.  **섭취 (Ingestion):** #카페인_오후, #알코올, #야식, #공복
2.  **활동 (Activity):** #격한운동_저녁, #스크린타임, #낮잠, #독서/명상
3.  **환경 (Environment):** #소음, #빛, #온도_부적절, #잠자리_변경
4.  **심리/신체 (Condition):** #스트레스, #생리통/호르몬, #통증/질병

## 5. UI/UX 플로우

### 5.1 온보딩 (Onboarding)
*   기본 생체 정보, 평소 기상 시간($T_{wake}$), 수면 목표 설정.

### 5.2 모닝 체크인 (Morning Check-in)
기상 직후 실행되는 핵심 화면.
1.  **Time Check:** 기상 시간 확인 (자동 기록 확인).
2.  **Refreshment:** "오늘 얼마나 개운한가요?" (슬라이더 0-100).
3.  **Wake Type:** "알람 소리를 듣고 일어났나요?" (Y/N), 스누즈 횟수 체크.
4.  **Tags:** 어젯밤 수면 방해 요인 아이콘 선택.

### 4.4 Future Improvements
*   [ ] **Voice Input (STT):** Allow users to input Memo via voice.
*   [ ] **Sleep Sound Analysis:** Measure noise levels during sleep.
*   **Tonight's Target:** 오늘 밤 권장 취침 시간($T_{bed}$) 카운트다운.

### 5.3 홈 대시보드
*   **Sleep Battery:** 오늘 수면 효율에 따른 배터리 잔량 표시.
*   **Tonight's Target:** 오늘 밤 권장 취침 시간($T_{bed}$) 카운트다운.

---
**Note:** 이 문서는 AI 에이전트가 코드를 생성할 때 `Logic`, `Formula`, `Schema`를 참조하는 기준이 됩니다.
