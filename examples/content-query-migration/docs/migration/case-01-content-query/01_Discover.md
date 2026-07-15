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
