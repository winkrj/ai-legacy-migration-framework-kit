#!/bin/bash
# 스펙 승인 게이트 (PreToolUse)
# 이관 브랜치(feature/ai-migration-*)에서 승인 전에는 docs/migration/, reports/
# 밖의 파일 수정을 차단한다. 승인 신호는 모드별로:
#   Light: 02_Spec.md의 구현 승인 체크박스 (- [x] 위 계약대로 구현을 승인한다)
#   Full : 03_Plan.md의 "Implementation Permission: Granted*" 라인
# 이관 브랜치가 아니면 아무것도 하지 않는다.
set -u

input=$(cat)

file_path=$(printf '%s' "$input" | python3 -c '
import json, sys
try:
    d = json.load(sys.stdin)
    print(d.get("tool_input", {}).get("file_path", "") or d.get("tool_input", {}).get("notebook_path", ""))
except Exception:
    pass
' 2>/dev/null)

# 파싱 실패 또는 파일 경로 없는 도구 호출은 통과 (fail-open)
[ -z "${file_path}" ] && exit 0

branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || exit 0
case "$branch" in
  feature/ai-migration-*) feature="${branch#feature/ai-migration-}" ;;
  *) exit 0 ;;
esac

root=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
spec="$root/docs/migration/$feature/02_Spec.md"
plan="$root/docs/migration/$feature/03_Plan.md"

# Light 모드: 사람이 체크한 승인 체크박스가 있으면 전부 허용
if [ -f "$spec" ] && grep -qE '^[[:space:]]*-[[:space:]]\[[xX]\][[:space:]]*위 계약대로 구현을 승인한다' "$spec"; then
  exit 0
fi

# Full 모드: 03_Plan.md에서 Implementation Permission이 Granted면 허용
if [ -f "$plan" ] && grep -qE '^[[:space:]]*Implementation Permission:[[:space:]]*Granted' "$plan"; then
  exit 0
fi

case "$file_path" in
  /*) abs="$file_path" ;;
  *)  abs="$root/$file_path" ;;
esac

# 승인 전에도 이관 문서, 리포트, Claude Code 설정은 작성 가능
case "$abs" in
  "$root/docs/migration/"* | "$root/reports/"* | "$root/.claude/"*) exit 0 ;;
esac

echo "BLOCKED by legacy-migration spec gate: 아직 구현이 승인되지 않았습니다 — Light 모드는 docs/migration/$feature/02_Spec.md의 구현 승인 체크박스, Full 모드는 docs/migration/$feature/03_Plan.md의 'Implementation Permission: Granted'가 필요합니다. 승인 전에는 이관 문서(docs/migration/, reports/) 밖의 파일을 수정할 수 없습니다. 사용자에게 스펙 검토와 승인을 요청하고 멈추세요." >&2
exit 2
