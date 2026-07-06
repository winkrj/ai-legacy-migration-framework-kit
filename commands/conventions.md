---
description: 프로젝트 컨벤션 등록 — 직접 입력, 참고 프로젝트에서 추출, 또는 현재 프로젝트에서 추출
argument-hint: [참고-프로젝트-경로 | "직접 입력"]
---

Target 프로젝트의 컨벤션(코드 컨벤션/아키텍처/비즈니스 규칙)을 `docs/conventions/`에 정리한다. 인자: $ARGUMENTS

여기서 만든 컨벤션은 이후 `/legacy-migration:start`(스펙 반영)와 `/legacy-migration:implement`(구현 규칙)가 자동으로 읽는다.

[소스 판별]
1. 인자가 디렉토리 경로면 → **참고 프로젝트 추출 모드**. 그 프로젝트(팀 가이드/모범 프로젝트)는 read-only로만 읽는다.
2. 사용자가 대화에서 규칙을 직접 제시했거나 문서를 붙여넣었으면 → **직접 입력 모드**.
3. 인자가 없으면 → 현재 프로젝트에서 추출할지, 직접 입력할지, 참고 프로젝트를 줄지 사용자에게 묻는다.

[추출 모드 규칙]
- 반복되는 code/test 패턴을 evidence로 수집하고, **반례도 함께** 기록한다 (파일/심볼 단위).
- 한 번 관찰된 패턴을 프로젝트 규칙으로 승격하지 않는다. 컨벤션을 발명하지 않는다.
- 영역별로 정리: layer responsibility, DTO, paging, exception, date/time, testing, 네이밍/응답 형식.
- 패턴이 갈리는 지점(2가지 스타일 혼재 등)은 규칙으로 쓰지 말고 Open Question으로 만들어 사용자에게 묻는다.

[직접 입력 모드 규칙]
- 사용자가 준 규칙을 템플릿 구조로 정규화만 한다. 내용을 임의로 보강하거나 빼지 않는다.
- 모호하거나 서로 충돌하는 규칙은 그대로 쓰지 말고 사용자에게 묻는다.
- 참고 프로젝트/문서와 직접 입력이 충돌하면 **직접 입력이 우선**이되, 충돌 사실을 보고한다.

[작성]
- `${CLAUDE_PLUGIN_ROOT}/templates/conventions/project-conventions-template.md`를 기반으로 `docs/conventions/project-conventions.md`를 작성한다. 영역이 크면 `${CLAUDE_PLUGIN_ROOT}/templates/conventions/`의 영역별 템플릿(dto/paging/exception/date-time/testing 등)으로 분리한다.
- Convention Status는 **Draft**로 둔다. Human Decision 섹션의 Decision은 Pending으로 둔다.
- 어느 소스에서 왔는지(참고 프로젝트 경로/사용자 입력/현재 프로젝트 추출)를 각 규칙의 Evidence에 기록한다.

[종료 — 승인은 사람이 한다]
다음을 출력하고 턴을 종료한다:
1. 정리된 컨벤션 영역 요약
2. Open Question 목록 (사용자가 답해야 확정되는 것)
3. 안내: "docs/conventions/를 검토하고 Human Decision을 Approved로 바꾸면, 이후 start/implement가 이 컨벤션을 binding rule로 사용합니다. Draft 상태면 참고만 하고 binding으로 쓰지 않습니다."
