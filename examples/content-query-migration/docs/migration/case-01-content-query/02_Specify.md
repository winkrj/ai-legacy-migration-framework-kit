# 상세 스펙 (Specify)

## 상태

Status: Planning
Implementation: Not Started
Automation: Not Started
MCP/Plugin: Deferred

## 도메인 규칙

| 규칙 ID | 규칙 | 근거 수준 | 승인 |
|---|---|---|---|
| RULE-001 | 유효한 조회는 조건에 맞는 합성 콘텐츠를 반환한다. | Observed | Draft |
| RULE-002 | 결과가 없으면 빈 컬렉션을 반환한다. | Observed | Draft |

## API 상세 스펙

| API ID | Method/Path | 기능명 | 레거시 근거 | 요청 파라미터/body | 응답 field | DB R/W | 외부 연동 | business rule | empty/error 정책 | 미결(OQ) | 연결 Task |
|---|---|---|---|---|---|---|---|---|---|---|---|
| API-001 | `GET /contents` | 콘텐츠 조회 | mapper 조회 (합성 예시) | `category`, `publishedStatus`, `page` (선택) | id, title, category, publishedStatus | R: `synthetic-content` | 없음 | RULE-001, RULE-002 | 빈 컬렉션 반환, 에러 없음 | OQ-EX-001 | PLAN-API-001, IMPL-API-001, VAL-API-001 |

## 데이터 매핑

- 데이터 엔티티: `synthetic-content` (의미 별칭, 실제 저장소 아님)
- 조회 조건: 선택적 category / published-status 필터
- 결과 형태: 콘텐츠 식별자, 제목 placeholder, category, published status

## 호환성

- 예시 target은 레거시의 빈 결과 동작을 유지한다: 빈 컬렉션, 에러 없음.

## 미결 질문

- OQ-EX-001

## Specify Gate

Needs Human Policy Decision
