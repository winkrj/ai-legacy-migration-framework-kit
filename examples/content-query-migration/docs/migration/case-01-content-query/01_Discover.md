# 분석 (Discover)

## 상태

Status: Planning
Implementation: Not Started
Automation: Not Started
MCP/Plugin: Deferred

## 범위

### 포함

- category / published-status로 합성 콘텐츠 조회
- 페이징과 빈 결과 동작 확인

### 제외

- 콘텐츠 생성·수정·삭제
- 실제 시스템, host, 데이터 소스 일체

## 출처

| ID | 출처 유형 | 정제된 참조 | 접근 |
|---|---|---|---|
| SRC-001 | Synthetic Code | `example-legacy-flow` | Read-only |

## 발견

| ID | 출처 | 근거 수준 | 발견 내용 | 인용 (파일:라인 + 코드) |
|---|---|---|---|---|
| EV-001 | SRC-001 | Confirmed | 콘텐츠 목록 조회는 선택적 category/published-status 필터를 지원한다 | `ContentMapper.xml:34` "SELECT ... WHERE published = ?" (합성 예시) |
| EV-002 | SRC-001 | Confirmed | 빈 결과는 에러가 아니라 빈 컬렉션을 반환한다 | `ContentService.java:92` "return Collections.emptyList()" (합성 예시) |

## 심문 체크리스트

> 빈 칸은 "안 물어봤다"는 뜻이다. ⚡ 항목은 개선 후보를 만든다 → `07_Improvements.md`.

### API-001 `GET /contents`

| # | 질문 | 답변 | 근거 (파일:라인) | 상태 |
|---|---|---|---|---|
| 1 | 이 API를 호출하는 화면·이벤트는? | 목록 화면 진입, 필터 변경 시 재조회 | `content-list.jsp:88` "loadContents()" | 확인 |
| 2 | 호출 권한은? | 공개 조회, 권한 분기 없음 | `ContentController.java:52` | 확인 |
| 3 | 요청 파라미터의 필수·선택·기본값은? | 모두 선택, page 기본 1 | `ContentController.java:55` | 확인 |
| 4 | 조회 조건과 출처는? | category, publishedStatus (둘 다 선택) | `ContentMapper.xml:34` | 확인 |
| 5 | 제외되는 레코드가 있는가? | published = 'Y'만 조회 | `ContentMapper.xml:36` "WHERE published = ?" | 확인 |
| 6 | 정렬 키와 tie-breaker는? | 등록일 DESC, tie-breaker 없음 | `ContentMapper.xml:41` | 확인 |
| 7 | 페이징 기본·최대 size는? | 기본 20, 최대 미정 | `ContentService.java:74` | 미확인(OQ-EX-001) |
| 8 | 날짜·시간 형식·timezone은? | 서버 기본 timezone 사용 | `ContentService.java:96` | 확인 |
| 9 | 빈 결과·null 필드의 응답은? | 빈 컬렉션 반환, 에러 없음 | `ContentService.java:92` "emptyList()" | 확인 |
| 10 | 예외 시 응답과 로깅은? | 조용한 실패 없음 | `ContentService.java:100` | 확인 |
| 11 | ⚡ 트랜잭션 경계와 그 안의 외부 호출은? | 읽기 전용, 외부 호출 없음 | `ContentService.java:70` | 확인 |
| 12 | ⚡ 목록 순회 중 추가 쿼리가 있는가? | 없음 (단일 쿼리) | `ContentMapper.xml:34` | 확인 |
| 13 | ⚡ 같은 조회가 요청당 반복되는가? | 1회 | `ContentService.java:74` | 확인 |
| 14 | ⚡ 조회 조건에 인덱스가 있는가? | 합성 예시라 확인 불가 | | 미확인(OQ-EX-001) |
| 15 | 조회인데 부수효과가 있는가? | 없음 | `ContentService.java:88` | 확인 |
| 16 | 외부 연동은 직접인가 프록시인가? | 외부 연동 없음 | `ContentService.java:70` | 확인 |

## 레거시 흐름

> 각 hop마다 파일을 열어 확인하고 인용을 남긴다. 안 연 hop부터는 Inferred다.

```text
진입점 → Controller → Service → Mapper
         :52          :88       :34
```

`ContentController.java:52` → `ContentService.java:88` → `ContentMapper.xml:34` (합성 예시)

## 리스크

- 예시 동작은 실제 도메인 규칙이 아니다.

## 미결 질문

- OQ-EX-001: 최대 page size는 의도적으로 미결로 남긴다.
