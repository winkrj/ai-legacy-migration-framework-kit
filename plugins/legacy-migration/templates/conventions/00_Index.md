# Project Convention Templates

## Purpose

이 폴더는 Target project의 기존 code pattern을 evidence로 정리하기 위한 template이다. 고정 architecture나 universal rule을 제공하지 않는다.

## Lifecycle

`Observed Patterns → Draft Convention → Human Review → Approved Convention`

Human approval 전에는 어떤 draft도 binding AI Agent rule 또는 Implementation Permission이 아니다.

## Templates

- `project-conventions-template.md`
- `layer-responsibility-template.md`
- `dto-policy-template.md`
- `paging-policy-template.md`
- `exception-policy-template.md`
- `date-time-policy-template.md`
- `testing-policy-template.md`
- `ai-agent-coding-rules-template.md`

## Usage

1. 기존 code/test/document에서 반복 사례와 반례를 수집한다.
2. 각 template의 Existing Evidence와 Open Questions를 먼저 채운다.
3. Current Project Rule은 draft로 작성한다.
4. Human Decision에 승인자, 날짜와 범위를 기록한다.
5. 승인된 문서만 `AGENTS.md`/`CLAUDE.md`에서 binding convention으로 참조한다.
