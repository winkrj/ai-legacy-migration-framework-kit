# Claude Hooks

Status: Implemented (plugin)

스펙 승인 게이트 훅이 플러그인에 포함됐다: [`hooks/spec-gate.sh`](../../../hooks/spec-gate.sh), [`hooks/hooks.json`](../../../hooks/hooks.json).

이관 브랜치(`feature/ai-migration-*`)에서 `02_Spec.md`의 구현 승인 체크박스가 체크되기 전에는 `docs/migration/`, `reports/` 밖의 파일 수정을 차단한다(PreToolUse, exit 2). 일반 브랜치에서는 아무 동작도 하지 않는다.

코드를 수정하는 훅(auto-fix)은 여전히 포함하지 않는다.
