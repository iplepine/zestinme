# Feature 04: Sleep (수면)

| Attribute | Value |
| :--- | :--- |
| **Version** | 1.0 |
| **Status** | Final Draft |
| **Date** | 2025-12-14 |
| **Related UI** | `spec/50-ui/04-sleep-screen.md` |

## 1. 개요 (Overview)
**"Bio-Rhythm & Sleep Optimization System"**

단순한 기록을 넘어, 사용자의 **생체 리듬(Circadian Rhythm)**과 **사회적 시차(Social Jetlag)**를 분석하여 최적의 수면 패턴을 제안합니다.
90분 수면 주기 이론과 기분 데이터를 결합하여 **"Golden Hour (가장 개운한 취침/기상 타이밍)"**를 발견하는 것이 핵심 목표입니다.

## 2. 데이터 모델 (SleepRecord)

| Field | Type | Description |
| :--- | :--- | :--- |
| `id` | `int` | Auto Increment ID. |
| `date` | `DateTime` | 해당 기록의 기준 날짜 (기상일 기준). |
| `bedTime` | `DateTime` | 침대에 누운 시간 (TIB Start). |
| `wakeTime` | `DateTime` | 침대에서 일어난 시간 (TIB End). |
| `sleepOnset` | `DateTime?` | 실제 잠든 시간 (알고리즘 추정, Future). |
| `durationMinutes` | `int` | 총 수면 시간 (TST). |
| `efficiency` | `int` | 수면 효율 (SE) = (TST / TIB) * 100. |
| `qualityScore` | `int` | 기상 직후 기분 (1-5) - Golden Hour 판단 기준. |
| `isNaturalWake` | `bool` | 알람 없이 기상 여부 (수면 관성 분석용). |
| `tags` | `List<String>` | 수면 방해/도움 요인 (Variances). |

## 3. 핵심 알고리즘 (The Algorithmic Core)

### 3.1 최적 수면 시간 산출 (Golden Hour Calculator)
*   **Goal:** 기상 목표 시간($T_{wake}$) 기준, 수면 관성을 최소화하는 취침 시간($T_{bed}$) 역산.
*   **Cycles:** 90분 주기 기준 (NREM + REM).
*   **Formula:** $T_{bed} = T_{wake} - (5 \times 90min) - 15min(Latency)$
*   **Calculation:** 5사이클(7.5h, 최적) / 6사이클(9h, 충분) / 4사이클(6h, 최소) 옵션 제공.

### 3.2 수면 효율 (Sleep Efficiency, SE)
*   **Formula:** $SE = \frac{Total Sleep Time (TST)}{Time In Bed (TIB)} \times 100$
*   **Benchmark:** 90% 이상(매우 좋음), 85% 미만(효율 저하/불면 징후).

### 3.3 사회적 시차 (Social Jetlag) - Future
*   주중(Workday)과 주말(Free day)의 수면 중간점($MSF$) 차이를 계산하여 만성 피로 원인 분석.

### 3.1 Morning Trigger
*   **Condition:**
    *   현재 시각 >= 설정된 기상 예정 시각 (Default: 07:00).
    *   당일 `SleepRecord`가 없을 것.
*   **Action:** 앱 실행 시 `SleepCheckInDialog` 띄움.

### 3.2 Sleep Debt Calculation (수면 부채)
*   **Target:** 사용자 설정 목표 시간 (Default: 7시간 30분).
*   **Logic:** `수면 부채 = 목표 시간 - 실제 수면 시간`.
*   **Feedback:** 누적 부채가 5시간 이상이면 "주말에 보충 수면이 필요해요" 팁 제공.

### 3.3 Insight Correlation (Future)
*   수면 질(Quality)이 낮은 날 -> 부정적 감정(Red/Blue Zone) 비율이 높은지 분석하여 리포팅.
