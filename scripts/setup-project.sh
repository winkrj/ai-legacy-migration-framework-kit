#!/bin/bash
# 이관 대상 프로젝트에 kit 실행 환경을 설치한다.
#
# 하는 일 (전부 멱등 — 이미 있으면 건드리지 않는다)
#   1. docs/migration, reports, docs/conventions 디렉터리 생성
#   2. scripts/verify.sh 복사 (빌드 도구 탐지 결과 확인)
#   3. docs/conventions/binding-rules.md 빈 템플릿 배치
#   4. Codex를 쓰면 .codex/agents/*.toml 복사 (플러그인이 배포할 수 없는 부분)
#   5. 마지막에 실제로 동작하는지 검증하고 요약 출력
#
# 하지 않는 일
#   - 컨벤션 내용을 생성하지 않는다. 프로젝트의 실제 패턴에서 사람이 채운다.
#   - 기존 파일을 덮어쓰지 않는다.
#
# 사용법
#   bash <kit>/scripts/setup-project.sh [--target <프로젝트경로>] [--with-codex-agents]
set -uo pipefail

KIT_ROOT=$(cd "$(dirname "$0")/.." && pwd)
TARGET=$(pwd)
CODEX_AGENTS=auto

while [ $# -gt 0 ]; do
  case "$1" in
    --target) TARGET=$(cd "$2" 2>/dev/null && pwd) || { echo "대상 경로를 찾을 수 없습니다: $2" >&2; exit 2; }; shift 2 ;;
    --with-codex-agents) CODEX_AGENTS=yes; shift ;;
    --no-codex-agents) CODEX_AGENTS=no; shift ;;
    -h|--help) sed -n '2,18p' "$0"; exit 0 ;;
    *) echo "알 수 없는 옵션: $1" >&2; exit 2 ;;
  esac
done

echo "kit:    $KIT_ROOT"
echo "대상:   $TARGET"
echo ""

CREATED=0
SKIPPED=0

note_new()  { echo "  + $1"; CREATED=$((CREATED+1)); }
note_keep() { echo "  = $1 (이미 있음)"; SKIPPED=$((SKIPPED+1)); }

copy_if_absent() { # copy_if_absent <원본> <대상> <표시이름>
  if [ -e "$2" ]; then note_keep "$3"; else
    mkdir -p "$(dirname "$2")" && cp "$1" "$2" && note_new "$3"
  fi
}

# 1. 디렉터리
echo "[1/5] 디렉터리"
for d in docs/migration reports docs/conventions; do
  if [ -d "$TARGET/$d" ]; then note_keep "$d/"; else mkdir -p "$TARGET/$d" && note_new "$d/"; fi
done

# 2. verify.sh
echo ""
echo "[2/5] 검증 스크립트"
copy_if_absent "$KIT_ROOT/templates/target-project/scripts/verify.sh" \
               "$TARGET/scripts/verify.sh" "scripts/verify.sh"
chmod +x "$TARGET/scripts/verify.sh" 2>/dev/null

# 빌드 도구 탐지 — verify.sh가 실제로 쓸 수 있는지 미리 알려준다.
if   [ -f "$TARGET/gradlew" ];      then BUILD_TOOL="gradle (gradlew)"
elif [ -f "$TARGET/mvnw" ];         then BUILD_TOOL="maven (mvnw)"
elif [ -f "$TARGET/pom.xml" ];      then BUILD_TOOL="maven (mvn)"
elif [ -f "$TARGET/package.json" ]; then BUILD_TOOL="npm"
else BUILD_TOOL=""
fi

# 3. binding-rules
echo ""
echo "[3/5] 컨벤션"
copy_if_absent "$KIT_ROOT/templates/conventions/binding-rules-template.md" \
               "$TARGET/docs/conventions/binding-rules.md" "docs/conventions/binding-rules.md"

# 4. Codex agent role
echo ""
echo "[4/5] 서브에이전트"
if [ "$CODEX_AGENTS" = auto ]; then
  if command -v codex >/dev/null 2>&1 || [ -d "$TARGET/.codex" ]; then CODEX_AGENTS=yes; else CODEX_AGENTS=no; fi
fi
if [ "$CODEX_AGENTS" = yes ]; then
  for f in "$KIT_ROOT"/codex/agents/*.toml; do
    [ -e "$f" ] || continue
    copy_if_absent "$f" "$TARGET/.codex/agents/$(basename "$f")" ".codex/agents/$(basename "$f")"
  done
else
  echo "  - Codex 미사용으로 판단해 건너뜀 (--with-codex-agents로 강제 가능)"
fi
echo "  · Claude Code는 플러그인이 서브에이전트를 직접 제공하므로 복사가 필요 없습니다."

# 5. 검증 — 설치했다고 동작하는 것이 아니다.
echo ""
echo "[5/5] 검증"
PROBLEMS=0

if [ -x "$TARGET/scripts/verify.sh" ]; then
  echo "  ✓ verify.sh 실행 가능"
else
  echo "  ✗ verify.sh 실행 권한 없음"; PROBLEMS=$((PROBLEMS+1))
fi

if [ -n "$BUILD_TOOL" ]; then
  echo "  ✓ 빌드 도구 탐지: $BUILD_TOOL"
else
  echo "  ✗ 빌드 도구를 탐지하지 못했습니다 — scripts/verify.sh의 탐지 블록에 명령을 직접 적으세요"
  PROBLEMS=$((PROBLEMS+1))
fi

if [ "$CODEX_AGENTS" = yes ]; then
  n=$(ls "$TARGET"/.codex/agents/*.toml 2>/dev/null | wc -l | tr -d ' ')
  if [ "$n" -ge 3 ]; then echo "  ✓ Codex agent role ${n}개 배치됨"
  else echo "  ✗ Codex agent role이 부족합니다 (${n}개)"; PROBLEMS=$((PROBLEMS+1)); fi
fi

if grep -q "Human Decision: Draft\|Decision: Pending\|Draft" "$TARGET/docs/conventions/binding-rules.md" 2>/dev/null; then
  echo "  ⚠ binding-rules.md가 Draft입니다 — 승인 전까지 binding 컨벤션 없이 동작합니다"
fi

echo ""
echo "생성 $CREATED개 · 유지 $SKIPPED개"
if [ "$PROBLEMS" -gt 0 ]; then
  echo "확인 필요 $PROBLEMS건 — 위 ✗ 항목을 해결한 뒤 다시 실행하세요."
  exit 1
fi
echo ""
echo "다음 단계"
echo "  1) ./scripts/verify.sh 를 한 번 실행해 현재 빌드·테스트가 통과하는지 확인"
echo "  2) docs/conventions/binding-rules.md 에 위반 시 반려할 규칙을 10줄 이내로 작성하고 승인"
if [ -n "$BUILD_TOOL" ] && [ "${BUILD_TOOL#maven}" != "$BUILD_TOOL" -o "${BUILD_TOOL#gradle}" != "$BUILD_TOOL" ]; then
  echo "  3) (선택) 컨벤션을 테스트로 강제하려면 ArchUnit 스켈레톤을 쓴다:"
  echo "     $KIT_ROOT/templates/target-project/ArchitectureTest.java.template"
  echo "     — 컨벤션 문서에 이미 있는 규칙만 옮기고, 지켜지지 않는 규칙은 켜지 않는다"
  echo "  4) 이관 시작"
else
  echo "  3) 이관 시작"
fi
