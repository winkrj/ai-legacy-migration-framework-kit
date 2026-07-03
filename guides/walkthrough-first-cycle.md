# 따라하기 — Zip으로 받아서 첫 이관 한 사이클

Git clone 없이 zip으로 받아, 새 프로젝트에서 Light 모드 한 사이클(분석 → 스펙 승인 → 구현 → 결과)을 도는 전체 예시다. 예시 기능은 합성 도메인인 **"Content 목록 조회"**를 사용한다 — 실제 기능명으로 바꿔서 그대로 따라 하면 된다.

## 0. Kit 받기 (zip이면 충분)

Kit은 Markdown 템플릿과 프롬프트 모음이라 git 없이 zip으로 받아도 문제없다.

**방법 A — GitHub에서 직접** (repo 접근 권한 필요):
repo 페이지 → `Code` → `Download ZIP`

**방법 B — maintainer가 만들어서 전달**:

```bash
# maintainer가 실행
git archive --format=zip HEAD -o migration-kit-a8a55ae.zip
```

> **한 가지 습관:** zip 파일명이나 아래 1단계의 케이스 문서에 **kit commit hash**(예: `a8a55ae`)를 적어둔다. 나중에 "어느 버전 템플릿으로 했더라"를 추적하는 유일한 방법이다. git으로 받는 경우와의 차이는 업데이트를 pull로 못 받는 것뿐이며, 템플릿은 자주 바뀌지 않는다.

압축을 풀면 필요한 건 사실상 두 폴더다:

```text
kit/
├── templates/migration-docs-light/   ← 문서 템플릿 3개
└── prompts/                          ← AI에게 줄 프롬프트
```

## 1. 새 프로젝트에 세팅 (1분)

이관 대상 프로젝트에서:

```bash
cd my-target-project

# 격리 브랜치 — 이게 안전망의 전부
git checkout -b feature/ai-migration-content-list

# 케이스 폴더 만들고 템플릿 3개 복사
mkdir -p docs/migration/content-list
cp <kit압축푼경로>/templates/migration-docs-light/0*.md docs/migration/content-list/
```

케이스 폴더 `01_Analysis.md` 맨 위에 한 줄 적는다: `Kit version: a8a55ae (zip)`

세팅 끝. 설치할 것도, 설정 파일도 없다.

## 2. 분석 — AI에게 레거시를 읽힌다

AI(Codex/Claude)에게 아래처럼 지시한다. `prompts/codex/02_legacy-discover.md`를 쓰면 더 정교하지만, Light 모드는 이 정도로 충분하다:

```text
레거시 프로젝트 <legacy-repo경로>의 "Content 목록 조회" 기능을 분석해줘.

규칙:
- 레거시 코드는 읽기만 한다. 절대 수정하지 않는다.
- 코드/쿼리에서 확인한 사실만 기록한다.
- 확인 못 한 동작은 추측하지 말고 "미확인"으로 남긴다.

추적할 것: 진입점(URL/컨트롤러), 호출 흐름, 쿼리 조건(필터/삭제/상태),
정렬, 페이징, 숨은 규칙(기본값, 예외 처리).

결과를 docs/migration/content-list/01_Analysis.md 템플릿 형식에 맞춰 작성해줘.
```

결과물 예시 (요약):

```markdown
## 레거시가 하는 일
- 진입점: GET /contents/list → ContentController.list
- 조회 조건: category='CONTENT', del_yn='N' (삭제글 제외), 상태 필터 없음
- 정렬: content_seq DESC 고정 / 페이징: 1-based, 기본 10건

## 미확인 (추측 금지 목록)
- 페이지 크기 상한 (설정 파일에서 미발견)
- 날짜 형식이 잘못된 입력의 동작
```

**여기서 당신이 할 일:** 읽고, "미확인" 목록이 말이 되는지 본다. 이상하면 더 파게 시킨다.

## 3. 스펙 — 계약을 쓰고 승인한다 (여기가 핵심 gate)

`02_Spec.md`를 채운다. AI에게 초안을 시켜도 되지만 **결정과 승인 체크는 반드시 사람이** 한다:

```markdown
## 동작 계약
- API: GET /v1/contents
- 응답: { contents[], meta{ totalCount, size } }
- 빈 결과: 빈 배열 (에러 아님)
- 정렬/페이징: 최신순 고정, 기본 page 1 / size 10

## 사람이 결정할 것
- [x] 삭제글 제외 유지 → 유지한다
- [x] 페이지 상한 → 100으로 신규 도입 (레거시엔 없었음, 의도적 개선)

## 범위 제외
- 상세 조회, 등록/수정/삭제 (다음 사이클)

## 구현 승인
- [x] 위 계약대로 구현을 승인한다 (승인자: 홍길동 / 날짜: 2026-07-04)
```

> 승인 체크 전까지 AI는 production 코드를 한 줄도 만들지 않는다. 이 체크가 곧 "구현 시작" 버튼이다.

## 4. 구현 — 승인된 범위만

```text
docs/migration/content-list/02_Spec.md의 승인된 계약대로 구현해줘.

규칙:
- 계약에 있는 것만 구현한다. "범위 제외" 항목은 건드리지 않는다.
- 이 프로젝트의 기존 코드 컨벤션(구조/네이밍/테스트 방식)을 따른다.
- 스펙에 없는 동작이 필요해지면 구현하지 말고 멈춰서 질문한다.
- 테스트를 함께 작성하고 실행 결과를 그대로 보고한다.
```

AI가 구현 + 테스트 후 diff와 테스트 결과를 보고한다. 실패를 숨기지 않는 것까지가 규칙이다.

## 5. 결과 — 기록하고 MR

`03_Result.md`를 채운다:

```markdown
## 구현한 것
- 변경 파일: Controller/UseCase/Repository + 테스트 3개 (총 7파일)
- 커밋: abc1234

## 검증한 것
- 단위 테스트 5/5 통과
- 로컬 수동 확인: 목록/빈 결과/페이징

## 검증 못 한 것 / 남은 결정
- 실데이터 건수 비교 (staging 접근 후)

## 롤백
- 브랜치: feature/ai-migration-content-list — merge 전 삭제로 롤백
```

```bash
git add -A && git commit -m "feat: migrate content list query"
git push -u origin feature/ai-migration-content-list   # MR/PR 생성
```

MR 설명에 `02_Spec.md`와 `03_Result.md` 내용을 붙이면 리뷰어가 "무엇을 왜"를 바로 본다.

## 전체 소요 구조

| 단계 | 하는 사람 | 산출물 |
|---|---|---|
| 세팅 | 사람 (1분) | 브랜치 + 템플릿 3개 |
| 분석 | AI 작성 → 사람 확인 | `01_Analysis.md` |
| 스펙 | AI 초안 가능 → **사람 결정·승인** | `02_Spec.md` ✅ |
| 구현 | AI (승인 범위만) → 사람 리뷰 | 코드 + 테스트 |
| 결과 | 같이 | `03_Result.md` + MR |

## 주의

- 결제·인증·개인정보·공유 코드·cutover가 걸리면 Light가 아니라 Full 모드(`templates/migration-docs/` + `guides/01~06`)로 올린다.
- Validator CLI는 Full 모드 문서 전용이다. Light 문서에는 돌리지 않는다.
- 문서·MR에 credential, 실서버 주소, 실데이터를 넣지 않는다.
