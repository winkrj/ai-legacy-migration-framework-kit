# 구현 (Implement)

## 상태

Status: Not Started
Implementation: Not Started
Automation: Not Started
MCP/Plugin: Deferred

## Permission

Implementation Permission: Not Granted

## 승인된 Task

- <IMPL-API-NNN 및 연결 requirement — Implementation Permission이 Granted된 것만>

## 구현 메모

> Task ID 없는 구현은 금지한다. 승인된 IMPL task만, 작은 단위로 구현한다.

| Task | 결과 | 테스트 |
|---|---|---|
| IMPL-API-001 | Not Performed | Not Run |

## 변경 파일

- None

## 2-Pass 기록

> Pass 1(동작)과 Pass 2(정리)는 분리해서 수행하고 각각 기록한다. Pass 2 없이 완료 표시하지 않는다.
> Pass 2 점검: 책임 분리 / 이름(비즈니스 의도, `data`·`temp`·`util`류 금지) / 조건문(보호 절 우선) / null 흐름(원인 로그 보존) / 중복·추상화(성급한 추상화 금지). 요청 범위 초과 리팩터링은 하지 않는다.

| Task | Pass 1 (동작/테스트) | Pass 2 — 책임 분리 | Pass 2 — 이름/조건문 | Pass 2 — null 흐름 | Pass 2 — 중복/추상화 |
|---|---|---|---|---|---|
| IMPL-API-001 | Not Performed |  |  |  |  |

## Binding 컨벤션 대조

> `docs/conventions/binding-rules.md`(Approved)의 규칙별로 기록한다. 미등록이면 "binding 컨벤션 미등록" 한 줄.

| 규칙 | 결과 | 비고 |
|---|---|---|
| <규칙 1> | 지켰음 / 예외(사유) |  |

## 이탈 사항

- <없음 또는 Human 승인 필요 — 예상 밖 API/파일/외부 연동을 발견하면 멈추고 질문한다>
