# 상세 스펙 (Specify)

## 상태

Status: Not Started
Implementation: Not Started
Automation: Not Started
MCP/Plugin: Deferred

## 도메인 규칙

| 규칙 ID | 규칙 | 근거 수준 | 승인 |
|---|---|---|---|
| RULE-001 | <관찰된 규칙> | Confirmed / Observed / Inferred | Draft / Approved / Blocked |

## API 상세 스펙

> 큰 단위는 메뉴/feature, 상세 계약 단위는 API다. 각 API를 한 행으로 적고 **모든 행은 API ID와 연결 Task를 가진다.**
> 연결 Task는 `tasks.md`의 `PLAN-API-NNN / IMPL-API-NNN / VAL-API-NNN`과 같은 번호로 맞춘다.

| API ID | Method/Path | 기능명 | 레거시 근거 | 요청 파라미터/body | 응답 field | DB R/W | 외부 연동 | business rule | empty/error 정책 | 미결(OQ) | 연결 Task |
|---|---|---|---|---|---|---|---|---|---|---|---|
| API-001 | `<METHOD /path>` | <기능명> | <JSP/config/controller/service/mapper/query 근거> | <파라미터/body> | <응답 field> | <R/W 대상 엔티티(별칭)> | <없음 또는 대상> | <business rule> | <빈 결과/에러 정책> | <OQ-ID 또는 없음> | PLAN-API-001, IMPL-API-001, VAL-API-001 |

## 데이터 매핑

- 데이터 엔티티: `<의미 별칭 — 실제 테이블/스키마명 금지>`
- 조회 조건: <공개 가능한 조건>
- 결과 형태: <공개 가능한 field>

## 호환성

- <레거시 호환성 기대치>

## 미결 질문

- <미결 정책 — OQ-ID로 `99_Open-Questions.md`와 연결>

## Specify Gate

Ready / Blocked / Needs Human Policy Decision
