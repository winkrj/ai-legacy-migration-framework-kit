#!/bin/bash
# 스펙 승인 게이트 (PreToolUse)
# 이관 브랜치(feature/ai-migration-*)에서 승인 전에는 docs/migration/, reports/
# 밖의 파일 수정을 차단한다. 승인 신호는 모드별로:
#   Light: 02_Spec.md의 구현 승인 체크박스 (- [x] 위 계약대로 구현을 승인한다)
#   Full : 03_Plan.md의 "Implementation Permission: Granted*" 라인
# 이관 브랜치가 아니면 아무것도 하지 않는다.
#
# 승인 탐색은 두 단계다. 케이스 폴더명이 브랜치명과 다른 경우(예: 브랜치
# feature/ai-migration-visitreview + 폴더 case-01-visit-review)에도 승인을
# 인식해야 한다 — 못 찾으면 승인 후에도 영구 차단되고, 그러면 에이전트가
# 셸 리다이렉트로 우회해 깨진 파일을 만든다.
set -u

input=$(cat)

parsed=$(printf '%s' "$input" | python3 -c '
import json, sys
try:
    d = json.load(sys.stdin)
    ti = d.get("tool_input", {}) or {}
    print(ti.get("file_path", "") or ti.get("notebook_path", ""))
    print((ti.get("command", "") or "").replace("\n", " "))
except Exception:
    pass
' 2>/dev/null)

file_path=$(printf '%s' "$parsed" | sed -n '1p')
shell_command=$(printf '%s' "$parsed" | sed -n '2p')

# 파싱 실패 또는 대상이 없는 도구 호출은 통과 (fail-open)
[ -z "${file_path}" ] && [ -z "${shell_command}" ] && exit 0

branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || exit 0
case "$branch" in
  feature/ai-migration-*) feature="${branch#feature/ai-migration-}" ;;
  *) exit 0 ;;
esac

root=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
migration_docs="$root/docs/migration"

LIGHT_APPROVAL='^[[:space:]]*-[[:space:]]\[[xX]\][[:space:]]*위 계약대로 구현을 승인한다'
FULL_APPROVAL='^[[:space:]]*Implementation Permission:[[:space:]]*Granted'

has_approval() {
  # 1) 브랜치명과 정확히 일치하는 케이스 폴더를 먼저 본다.
  local case_dir="$migration_docs/$feature"
  if [ -d "$case_dir" ]; then
    grep -qrE "$LIGHT_APPROVAL" "$case_dir" 2>/dev/null && return 0
    grep -qrE "$FULL_APPROVAL" "$case_dir" 2>/dev/null && return 0
    return 1
  fi

  # 2) 폴더 명명이 브랜치명과 다르면 docs/migration 전체에서 승인 신호를 찾는다.
  #    격리 브랜치에서 한 케이스만 작업하는 전제이며, 승인된 케이스가 하나라도
  #    있으면 허용한다.
  grep -qrE "$LIGHT_APPROVAL" "$migration_docs" 2>/dev/null && return 0
  grep -qrE "$FULL_APPROVAL" "$migration_docs" 2>/dev/null && return 0
  return 1
}

has_approval && exit 0

is_writable_before_approval() {
  case "$1" in
    "$root/docs/migration/"* | "$root/reports/"* | "$root/.claude/"* | "$root/.agents/"*) return 0 ;;
  esac
  return 1
}

absolute_path() {
  case "$1" in
    /*) printf '%s' "$1" ;;
    *)  printf '%s' "$root/$1" ;;
  esac
}

block() {
  echo "BLOCKED by legacy-migration spec gate: 아직 구현이 승인되지 않았습니다 — Light 모드는 02_Spec.md의 구현 승인 체크박스, Full 모드는 03_Plan.md의 'Implementation Permission: Granted'가 필요합니다(docs/migration/ 하위 어디든 인식합니다). 승인 전에는 이관 문서(docs/migration/, reports/) 밖의 파일을 만들거나 수정할 수 없습니다. 셸 리다이렉트나 heredoc으로 우회하지 마세요 — 사용자에게 스펙 검토와 승인을 요청하고 멈추세요." >&2
  exit 2
}

# 편집 도구 경유 수정
if [ -n "${file_path}" ]; then
  is_writable_before_approval "$(absolute_path "$file_path")" || block
fi

# 셸 경유 파일 쓰기(리다이렉트/tee) — 편집 도구를 막고 셸로 우회하는 것을 차단한다.
# 빌드·테스트·git 등 일반 명령은 통과시킨다.
if [ -n "${shell_command}" ]; then
  targets=$(printf '%s' "$shell_command" \
    | grep -oE '(>>?[[:space:]]*|tee[[:space:]]+(-a[[:space:]]+)?)[^[:space:];|&)]+' \
    | sed -E 's/^(>>?[[:space:]]*|tee[[:space:]]+(-a[[:space:]]+)?)//')

  for target in $targets; do
    case "$target" in
      /dev/*) continue ;;
    esac
    is_writable_before_approval "$(absolute_path "$target")" || block
  done
fi

exit 0
