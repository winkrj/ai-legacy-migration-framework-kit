# 상세 스펙 (Specify)

## 상태

Status: Planning
Implementation: Not Started
Automation: Not Started
MCP/Plugin: Deferred

## 범위와 용어

- 포함: 합성 콘텐츠 조회 (예시)
- 제외: 콘텐츠 생성/수정/삭제
- 용어: 레거시 `CONTENTS_MST` → 신규 `synthetic-content`

## 공통 규칙

- 응답 형식/에러: 예시 케이스 — 컨벤션 문서 미등록. 케이스 예외: 없음
- 페이징/정렬: 예시 케이스 — 컨벤션 문서 미등록. 케이스 예외: 없음

## 도메인 규칙

| 규칙 ID | 규칙 | 근거 수준 | 승인 |
|---|---|---|---|
| RULE-001 | 유효한 조회는 조건에 맞는 합성 콘텐츠를 반환한다. | Observed | Draft |
| RULE-002 | 결과가 없으면 빈 컬렉션을 반환한다. | Observed | Draft |

## API 목록

| API ID | Method/Path | 기능명 | 레거시 근거 (파일:라인 + 인용) | 외부 연동 | 미결(OQ) | 연결 Task |
|---|---|---|---|---|---|---|
| API-001 | `GET /contents` | 콘텐츠 조회 | `ContentMapper.xml:34` "SELECT ... WHERE published = ?" (합성 예시) | 없음 | OQ-EX-001 | PLAN-API-001, IMPL-API-001, VAL-API-001 |

## API별 상세 스펙

### API-001 콘텐츠 조회

#### 목적

이관 예시용 합성 콘텐츠 목록 조회.

#### 권한·사전조건

- 권한: 없음 (공개 조회)
- 사전조건: 없음

#### 시나리오

- **Given** 승인된 샘플 콘텐츠가 있고 **When** 유효한 조회가 들어오면 **Then** 조건에 맞는 콘텐츠를 반환한다
- **Given** 일치하는 콘텐츠가 없고 **When** 유효한 조회가 들어오면 **Then** 데이터를 지어내지 않고 빈 컬렉션을 반환한다
- **Given** 파라미터가 계약을 위반하고 **When** 조회가 들어오면 **Then** 문서화된 검증 에러를 반환한다

#### Request

| 파라미터 | 위치 | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|---|
| category | query | string | N | 전체 | 카테고리 필터 |
| publishedStatus | query | string | N | 전체 | 게시 상태 필터 |
| page | query | number | N | 1 | 페이지 |

#### Response

| 필드 | 타입 | 설명 | 레거시 원 필드 |
|---|---|---|---|
| id | string | 콘텐츠 식별자 | CONT_ID |
| title | string | 제목 placeholder | CONT_TITLE |
| category | string | 카테고리 | CATE_CD |
| publishedStatus | string | 게시 상태 | PUB_YN |

#### 레거시 호출 흐름

`ContentController.java:52` → `ContentService.java:88` → `ContentMapper.xml:34` (합성 예시)

#### DB·외부 연동

- DB R: `synthetic-content` — 선택적 category/published-status 필터
- 외부 연동: 없음

#### 변환 규칙

- `PUB_YN` (Y/N) → `publishedStatus` (PUBLISHED/UNPUBLISHED)

#### 오류·빈 결과

- 빈 결과: 빈 컬렉션 반환, 에러 없음 (레거시 동작 유지)
- 오류: 잘못된 파라미터 → 문서화된 검증 에러

#### Acceptance Criteria

- AC-001-1: 유효 조회 시 조건에 맞는 콘텐츠 반환
- AC-001-2: 결과 없음 시 빈 컬렉션 (데이터 미조작)
- AC-001-3: 계약 위반 파라미터 시 검증 에러

#### 연결 Task

PLAN-API-001 / IMPL-API-001 / VAL-API-001

## 미결 질문

- OQ-EX-001

## Specify Gate

Needs Human Policy Decision
