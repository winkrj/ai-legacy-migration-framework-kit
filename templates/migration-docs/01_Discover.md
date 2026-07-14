# 분석 (Discover)

## 상태

Status: Not Started
Implementation: Not Started
Automation: Not Started
MCP/Plugin: Deferred

## 범위

### 포함

- <점검할 레거시 동작>

### 제외

- <범위 밖 동작>

## 출처

| ID | 출처 유형 | 정제된 참조 | 접근 |
|---|---|---|---|
| SRC-001 | Code / Test / Document | `<공개 가능한 참조>` | Read-only |

## 발견

> **근거 규칙: 인용 없는 근거는 근거가 아니다.** Confirmed는 `파일경로:라인` + 실제 코드 1~3줄 인용이 있을 때만 쓴다.
> 응답값만 보고 판단하지 말 것 — 로직(조건/분기/기본값)을 코드에서 확인한다.

| ID | 출처 | 근거 수준 | 발견 내용 | 인용 (파일:라인 + 코드) |
|---|---|---|---|---|
| EV-001 | SRC-001 | Confirmed / Observed / Inferred | <관찰된 동작> | `XxxService.java:88` "코드 인용" |

## 레거시 흐름

> 각 hop마다 실제 파일을 열어 확인하고 인용을 남긴다. 한 hop이라도 건너뛰면 그 지점부터는 Inferred다.

```text
진입점(JSP/URL) → Controller → Service → Client/DAO → 환경설정
   :라인            :라인        :라인       :라인        :라인
```

## 리스크

- <리스크>

## 미결 질문

- <OQ-ID — `99_Open-Questions.md`와 연결>
