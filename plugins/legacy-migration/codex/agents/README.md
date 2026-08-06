# Codex 서브에이전트 role 설치

Codex 플러그인 매니페스트는 agent role을 배포하지 못한다(`skills`/`hooks`/`mcpServers`/`apps`만 지원). 따라서 아래 TOML을 직접 설치해야 한다.

## 설치

프로젝트 단위(팀 공유, 권장):

```bash
mkdir -p .codex/agents && cp "$(dirname "$0")"/*.toml .codex/agents/
```

또는 사용자 단위(모든 프로젝트):

```bash
mkdir -p ~/.codex/agents && cp *.toml ~/.codex/agents/
```

설치 후 새 Codex 스레드를 연다. role이 로드되면 `spawn_agent`의 `agent_type`에 이름이 노출된다.

## 제공 role (전부 읽기 전용)

| 이름 | 용도 |
|---|---|
| `legacy_explorer` | 화면·설정에서 도달 가능한 endpoint 전수 열거 (미발견 API 탐지) |
| `spec_gap_hunter` | 스펙 ↔ 레거시 대조로 누락·근거약함·모순 탐지 |
| `improvement_scout` | N+1·캐싱·트랜잭션·쿼리·구조 개선 후보 탐지 |

## 읽기 전용은 무엇이 보장하나

Codex 0.146.0에는 Claude Code의 `disallowedTools` 같은 role 단위 도구 제한이 없고, role TOML의 `sandbox_mode = "read-only"`도 신뢰할 수 없다(spawn 시 부모의 permission profile이 마지막에 다시 적용된다).

**대신 이 kit의 `spec-gate` 훅이 강제한다.** `PreToolUse` 훅은 서브에이전트의 도구 호출에도 적용되고 입력에 `agent_type`이 포함되므로, 훅이 위 세 role의 쓰기 도구 호출(`apply_patch`, 셸 리다이렉트 등)을 **승인 이후에도** 차단한다.

즉 보장의 출처는 프롬프트 문구가 아니라 훅이다. 훅이 설치·신뢰(trust)되지 않았다면 이 보장은 없다.

## 호출 예시

```json
{
  "task_name": "endpoint_inventory",
  "message": "방문평가 목록 화면에서 도달 가능한 endpoint를 전부 찾아 인용과 함께 보고하세요.",
  "agent_type": "legacy_explorer",
  "fork_turns": "none"
}
```

`fork_turns="all"`(전체 히스토리 fork)에서는 `agent_type` 지정이 거부된다. 특정 role을 쓰려면 `"none"` 또는 양의 정수 문자열을 쓴다.
