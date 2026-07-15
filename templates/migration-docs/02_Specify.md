# 상세 스펙 (Specify)

> 이 문서가 이 케이스의 **단일 계약(SDD)**이다. 시나리오(Given/When/Then)와 Acceptance Criteria도 여기에 있다 — OpenSpec spec.md는 이 문서를 가리키는 포인터일 뿐이다.
> **근거 규칙: 인용 없는 근거는 근거가 아니다.** 모든 레거시 근거는 `파일경로:라인` + 실제 코드 1~3줄 인용만 인정한다.

## 상태

Status: Not Started
Implementation: Not Started
Automation: Not Started
MCP/Plugin: Deferred

## 범위와 용어

- 포함: <이 케이스가 다루는 메뉴/feature 범위>
- 제외: <안 하는 것>
- 용어: <레거시 용어 → 신규 용어 매핑. 응답 필드는 레거시 명칭이 아니라 신규 API 의미 기준>

## 공통 규칙

> **컨벤션 문서를 재서술하지 않는다** — 재서술은 drift의 원천이다. Approved 컨벤션을 링크하고, 이 케이스에서 다른 점만 적는다.

- 인증/권한: `docs/conventions/<문서>` 참조. 케이스 예외: <없음 또는 예외>
- 응답 형식/에러: `docs/conventions/<문서>` 참조. 케이스 예외: <없음 또는 예외>
- 페이징/정렬: `docs/conventions/<문서>` 참조. 케이스 예외: <없음 또는 예외>
- 날짜/시간: `docs/conventions/<문서>` 참조. 케이스 예외: <없음 또는 예외>

## 도메인 규칙

| 규칙 ID | 규칙 | 근거 수준 | 승인 |
|---|---|---|---|
| RULE-001 | <관찰된 규칙> | Confirmed / Observed / Inferred | Draft / Approved / Blocked |

## API 목록

> 이 표는 **색인**이다 — 계약은 아래 API별 상세 스펙 섹션에 있다. 표의 모든 API ID는 상세 섹션을 가져야 한다(validator가 검사).
> 연결 Task는 `tasks.md`의 `PLAN-API-NNN / IMPL-API-NNN / VAL-API-NNN`과 같은 번호로 맞춘다.

| API ID | Method/Path | 기능명 | 레거시 근거 (파일:라인 + 인용) | 외부 연동 | 미결(OQ) | 연결 Task |
|---|---|---|---|---|---|---|
| API-001 | `<METHOD /path>` | <기능명> | `XxxController.java:120` "코드 인용" | <없음 또는 대상> | <OQ-ID 또는 없음> | PLAN-API-001, IMPL-API-001, VAL-API-001 |

## API별 상세 스펙

> API마다 아래 섹션 세트를 채운다. **깊이는 위험에 비례** — 단순 CRUD는 각 항목 한두 줄이면 충분하고, 외부 연동·변환이 많은 API는 꽉 채운다.

### API-001 <기능명>

#### 목적

<이 API가 왜 필요한가, 누가 쓰는가 — 1~2줄>

#### 권한·사전조건

- 권한: <필요 권한/역할>
- 사전조건: <선행 상태>

#### 시나리오

- **Given** <전제> **When** <행위> **Then** <결과>
- **Given** <전제 — 빈 결과 케이스> **When** <행위> **Then** <데이터를 지어내지 않고 빈 결과>
- **Given** <전제 — 오류 케이스> **When** <행위> **Then** <문서화된 에러>

#### Request

| 파라미터 | 위치 | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|---|
| <name> | query/path/body | <타입> | Y/N | <기본값> | <설명> |

#### Response

| 필드 | 타입 | 설명 | 레거시 원 필드 |
|---|---|---|---|
| <field> | <타입> | <신규 의미 기준 설명> | <레거시 명칭 — 명칭 그대로 가져오지 않는다> |

#### 레거시 호출 흐름

> 각 hop마다 인용. 안 연 hop부터는 Inferred.

`XxxController.java:120` → `XxxService.java:88` → `XxxMapper.xml:34`
- <hop별 핵심 코드 인용>

#### DB·외부 연동

- DB R/W: <엔티티 별칭과 조건>
- 외부 연동: <없음 / 있으면 External Route Matrix에 행 추가>

#### 변환 규칙

- <레거시 값 → 신규 값 매핑, 날짜/금액/코드 변환. 없으면 "없음">

#### 오류·빈 결과

- 빈 결과: <동작>
- 오류: <에러 계약 — 외부 실패를 null로 삼키지 않는다, 원인 로그 보존>

#### Acceptance Criteria

> AC ID는 `VAL-API-NNN`이 항목별로 검증 결과를 기록하는 기준이다.

- AC-001-1: <검증 가능한 완료 조건>
- AC-001-2: <빈 결과/오류 포함>

#### 연결 Task

PLAN-API-001 / IMPL-API-001 / VAL-API-001 (spec: 이 섹션)

## External Route Matrix

> **외부 연동이 있는 API만 필수.** 외부 연동 열이 전부 "없음"이면 이 섹션은 지워도 된다.
> 각 셀도 근거 규칙을 따른다 — 환경설정 파일의 실제 라인을 인용한다. "직접 호출 vs 내부 프록시(gpapi류)"를 반드시 확정한다.

| API ID | 외부 시스템 | 직접/프록시 | 환경별 host (dev/qa/prod) | base path | Method/Path | 인증 | 근거 (파일:라인 + 인용) |
|---|---|---|---|---|---|---|---|
| API-001 | <시스템명> | 직접 / 프록시(<프록시명>) | <dev> / <qa> / <prod> | `<base path>` | `<METHOD /path>` | <방식> | `config.properties:15` "인용" |

## 미결 질문

- <미결 정책 — OQ-ID로 `99_Open-Questions.md`와 연결>

## Specify Gate

Ready / Blocked / Needs Human Policy Decision
