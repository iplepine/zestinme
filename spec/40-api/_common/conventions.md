# API Conventions

## 1. Response Format
모든 API 응답은 아래 표준 래퍼(Wrapper)를 사용한다.

```json
{
  "success": true,
  "data": { ... }, // 실제 페이로드
  "meta": { // 페이징 등 메타 정보
    "page": 1,
    "totalCount": 150
  },
  "error": null
}