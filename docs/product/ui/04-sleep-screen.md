# 1.4 Sleep Recording: Recharge (수면 충전)

| Attribute | Value |
| :--- | :--- |
| **Version** | 1.2 |
| **Status** | Final Draft |
| **Date** | 2025-12-18 |
| **Author** | Mind-Gardener Committee |
| **Related** | `features/04-sleep.md` |

## 1. 기획 의도 (Design Intent)
> **"Sleep is the light of the garden."**

수면은 정원에 **빛(Light)**을 공급하는 에너지원입니다.
충분한 수면은 **'Moon Lantern'**을 밝히고, 식물의 광합성(성장)을 돕습니다.

## 2. 진입 (Trigger)
1.  **Morning Check-in:** 기상 후 앱 실행 시 자동 팝업.
2.  **Manual Entry:** 홈 화면 좌측 상단 **Moon Lantern** 터치.

---

## 3. 화면 구성 (Layout)

### 3.1 Recharge Dashboard (Main)
*   **Hero Visual:** **Moon Lantern (달빛 랜턴)**
    *   화면 중앙에 크게 배치.
    *   **Light Intensity:** 수면 효율(Sleep Efficiency)에 따라 밝기 및 색상 변화.
        *   💡 Bright Yellow (90%↑): "완충! 정원이 환하게 빛납니다."
        *   🕯️ Warm Orange (80%~): "은은한 달빛."
        *   🌑 Dim Blue (<80%): "빛이 필요해요."

*   **Interactive Controls (Time Setting):**
    *   **Moon Time Dial:** 취침/기상 시간을 설정하는 원형 슬라이더.
    *   **Labels:**
        *   `In Bed (취침)`
        *   `Wake Up (기상)`
        *   `Sleep Quality (수면질)` (1~5 Star Rating).

### 3.2 Morning Insight
*   간단한 수면 통계 및 조언 표시.
    *   *"어제보다 30분 일찍 주무셨네요."*
    *   *"수면 빚(Sleep Debt)이 쌓이고 있어요."*

---

## 4. Feedback Logic (Effect)
*   **Lantern State Update:** 홈 화면의 랜턴 밝기 즉시 반영.
*   **Growth Boost:** 수면 효율(90%↑) 달성 시, 당일 식물 성장 경험치 **1.5배** 보너스 (광합성 효과).
