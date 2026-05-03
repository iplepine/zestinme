# 2. Growth System Specification

| Attribute | Value |
| :--- | :--- |
| **Version** | 1.0 (7-Day Cycle) |
| **Status** | Implementation Phase |
| **Date** | 2026-01-20 |

## 1. Growth Cycle (7 Days)

Mind-Gardener의 식물은 **7일(1주)** 주기로 성장합니다.
사용자의 활동(물주기)이 있다면 아래 스케줄에 따라 진화합니다.

| Day | Stage | Description | Visual Strategy |
| :--- | :--- | :--- | :--- |
| **Day 1** | **Step 1 (Sprout)** | 씨앗에서 갓 나온 새싹. | `asset_1` (새싹) |
| **Day 2** | **Step 2 (Seedling)** | 떡잎이 갈라짐. (외떡잎/쌍떡잎 구분) | `asset_2` (본잎 출현) |
| **Day 3** | **Step 2 (Pause)** | 뿌리를 내리는 시기 (변화 없음). | `asset_2` 유지 |
| **Day 4** | **Step 2 (Pause)** | 뿌리를 내리는 시기 (변화 없음). | `asset_2` 유지 |
| **Day 5** | **Step 3 (Growth)** | **[Jack-in-the-box]** 갑작스런 성장. | `asset_3` (성체) |
| **Day 6** | **Step 4 (Rich)** | 가지가 뻗고 잎이 풍성해짐. | `asset_4` (나무) or `Scale Up` |
| **Day 7** | **Step 5 (Full)** | 꽃이 피거나 열매를 맺음. (완성) | `asset_5` (완성) or `Effect` |

## 2. Condition Rules

*   **Logic:** `DaysSincePlanted = (Now - PlantedAt).inDays + 1`
*   **Asset Mapping:**
    *   **Herb/Leaf:** Stage 1 -> 2 -> 2 -> 2 -> 3 -> 3(Scale) -> 3(Flower)
    *   **Tree:** Stage 1 -> 2 -> 2 -> 2 -> 3 -> 4 -> 5

## 3. Monocot vs Dicot (Day 2)
*   식물 DB의 `description`이나 `type`을 파싱하여 구분.
*   **쌍떡잎 (Dicot):** 잎이 2개로 갈라지며 나옴.
*   **외떡잎 (Monocot):** 잎이 1개로 길게 나옴.
