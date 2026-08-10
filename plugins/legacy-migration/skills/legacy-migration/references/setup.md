---
description: 이관 대상 프로젝트에 kit 실행 환경 설치 (디렉터리·verify.sh·컨벤션 템플릿·서브에이전트)
---

이관 대상 프로젝트에 kit 실행 환경을 설치한다. 프로젝트당 1회면 된다.

[실행]

```bash
bash "${PLUGIN_ROOT}/scripts/setup-project.sh"
```

이 스크립트가 전부 처리한다. **직접 파일을 만들거나 복사하지 않는다** — 스크립트가 멱등하고 검증까지 하므로 손으로 하면 오히려 어긋난다.

[스크립트가 하는 일]
1. `docs/migration/`, `reports/`, `docs/conventions/` 생성
2. `scripts/verify.sh` 배치 (빌드 도구 자동 탐지: gradle·maven·npm)
3. `docs/conventions/binding-rules.md` 빈 템플릿 배치
4. `.codex/agents/*.toml` 복사 — **Codex는 플러그인 매니페스트로 agent role을 배포할 수 없어 이 단계가 필수다**
5. 설치가 실제로 동작하는지 검증하고 요약 출력

기존 파일은 덮어쓰지 않는다.

[실행 후 사용자에게 안내할 것]
- 출력의 `✗` 항목이 있으면 그것부터 해결한다. 빌드 도구 미탐지면 `scripts/verify.sh`의 탐지 블록을 직접 채워야 한다.
- **새 스레드를 열어야** 복사된 agent role이 `spawn_agent`의 `agent_type`에 나타난다.
- `./scripts/verify.sh`를 한 번 실행해 현재 빌드·테스트가 통과하는 상태인지 확인하도록 안내한다.
- `binding-rules.md`는 비어 있다. **컨벤션 내용을 대신 채우지 않는다** — 사람이 정하고 승인해야 binding이 된다.
