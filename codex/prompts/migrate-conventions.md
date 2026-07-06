# migrate-conventions — 프로젝트 컨벤션 등록

인자: `[참고-프로젝트-경로]` (선택)

Target 프로젝트의 컨벤션(코드 컨벤션/아키텍처/비즈니스 규칙)을 `docs/conventions/`에 정리한다.
이후 `/migrate-start`(스펙 반영)와 `/migrate-implement`(구현 규칙)가 이 문서를 읽는다.

[소스 판별]
1. 인자가 디렉토리 경로면 → 참고 프로젝트 추출 모드. 그 프로젝트는 read-only로만 읽는다.
2. 사용자가 대화에서 규칙을 직접 제시했으면 → 직접 입력 모드.
3. 인자가 없으면 → 현재 프로젝트 추출/직접 입력/참고 프로젝트 중 무엇으로 할지 사용자에게 묻는다.

[추출 모드 규칙]
- 반복 code/test 패턴을 evidence로 수집하고 반례도 함께 기록한다 (파일/심볼 단위).
- 한 번 관찰된 패턴을 규칙으로 승격하지 않는다. 컨벤션을 발명하지 않는다.
- 영역: layer responsibility, DTO, paging, exception, date/time, testing, 네이밍/응답 형식.
- 패턴이 갈리는 지점은 Open Question으로 만들어 사용자에게 묻는다.

[직접 입력 모드 규칙]
- 사용자 규칙을 템플릿 구조로 정규화만 한다. 임의로 보강/삭제하지 않는다.
- 모호하거나 충돌하는 규칙은 사용자에게 묻는다. 직접 입력이 참고 프로젝트보다 우선이되 충돌은 보고한다.

[작성]
- kit의 `templates/conventions/project-conventions-template.md` 구조로 `docs/conventions/project-conventions.md`를 작성한다 (템플릿을 못 찾으면 같은 섹션 구조로 직접 생성: Status / Scope / Current Project Rule / Existing Evidence / Exceptions / Open Questions / Human Decision / AI Agent Rules).
- Convention Status는 Draft, Human Decision은 Pending으로 둔다.
- 각 규칙의 출처(참고 프로젝트/사용자 입력/현재 프로젝트)를 Evidence에 기록한다.

[종료 — 승인은 사람이 한다]
컨벤션 영역 요약, Open Question 목록을 출력하고, "docs/conventions/ 검토 후 Human Decision을 Approved로 바꾸면 binding rule로 사용됩니다"를 안내하고 종료한다.
