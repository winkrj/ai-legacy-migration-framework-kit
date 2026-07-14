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
>
> **근거 규칙: 인용 없는 근거는 근거가 아니다.** 레거시 근거는 `파일경로:라인` + 실제 코드 1~3줄 인용만 인정한다.
> 산문 요약("SiteController가 호출함")은 무효. 사람이 30초 안에 열어서 대조할 수 있어야 한다.

| API ID | Method/Path | 기능명 | 레거시 근거 (파일:라인 + 인용) | 요청 파라미터/body | 응답 field | DB R/W | 외부 연동 | business rule | empty/error 정책 | 미결(OQ) | 연결 Task |
|---|---|---|---|---|---|---|---|---|---|---|---|
| API-001 | `<METHOD /path>` | <기능명> | `XxxController.java:120` "코드 인용" | <파라미터/body> | <응답 field> | <R/W 대상 엔티티(별칭)> | <없음 또는 대상> | <business rule> | <빈 결과/에러 정책> | <OQ-ID 또는 없음> | PLAN-API-001, IMPL-API-001, VAL-API-001 |

## External Route Matrix

> **외부 연동이 있는 API만 필수.** 외부 연동 열이 전부 "없음"이면 이 섹션은 지워도 된다.
> 각 셀도 근거 규칙을 따른다 — 환경설정 파일의 실제 라인을 인용한다. "직접 호출 vs 내부 프록시(gpapi류)"를 반드시 확정한다.

| API ID | 외부 시스템 | 직접/프록시 | 환경별 host (dev/qa/prod) | base path | Method/Path | 인증 | 근거 (파일:라인 + 인용) |
|---|---|---|---|---|---|---|---|
| API-001 | <시스템명> | 직접 / 프록시(<프록시명>) | <dev> / <qa> / <prod> | `<base path>` | `<METHOD /path>` | <방식> | `config.properties:15` "인용" |

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
