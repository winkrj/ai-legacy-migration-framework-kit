#!/bin/bash
# 스펙 승인 게이트 (PreToolUse)
#
# 두 가지를 강제한다.
#  1) 이관 브랜치(feature/ai-migration-*)에서 승인 전에는 docs/migration/, reports/
#     밖의 파일 수정을 차단한다. 승인 신호는 모드별로:
#       Light: 02_Spec.md의 구현 승인 체크박스 (- [x] 위 계약대로 구현을 승인한다)
#       Full : 03_Plan.md의 "Implementation Permission: Granted*" 라인
#  2) 읽기 전용 서브에이전트 role(legacy_explorer / spec_gap_hunter /
#     improvement_scout / migration_reviewer)의 쓰기를 승인 여부와 무관하게 차단한다.
#     Codex 0.146.0에는 role 단위 도구 제한이 없어 이 훅이 유일한 강제 수단이다.
#
# 승인 탐색은 두 단계다. 케이스 폴더명이 브랜치명과 다른 경우(예: 브랜치
# feature/ai-migration-visitreview + 폴더 case-01-visit-review)에도 승인을
# 인식해야 한다 — 못 찾으면 승인 후에도 영구 차단되고, 그러면 에이전트가
# 셸 리다이렉트로 우회해 깨진 파일을 만든다.
set -u

# Codex app의 hook runner는 대화형 shell과 PATH가 다를 수 있다. 필수 명령을 찾지
# 못한 채 127로 무력화되지 않도록 macOS/Linux의 표준 경로를 명시하고 fail-closed한다.
PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin${PATH:+:$PATH}"
export PATH
for required_command in python3 git sed grep tr; do
  if ! command -v "$required_command" >/dev/null 2>&1; then
    echo "BLOCKED by legacy-migration spec gate: 필수 명령 '$required_command'을 찾지 못해 승인 상태를 안전하게 검사할 수 없습니다." >&2
    exit 2
  fi
done

input=$(cat)

parsed=$(printf '%s' "$input" | python3 -c '
import json, sys
try:
    d = json.load(sys.stdin)
    ti = d.get("tool_input", {}) or {}
    print(ti.get("file_path", "") or ti.get("notebook_path", ""))
    print((ti.get("command", "") or "").replace("\n", " "))
    print(d.get("tool_name", "") or "")
    # Codex 서브에이전트의 PreToolUse 입력에는 agent_type이 들어온다.
    print(d.get("agent_type", "") or "")
except Exception:
    pass
' 2>/dev/null)

file_path=$(printf '%s' "$parsed" | sed -n '1p')
shell_command=$(printf '%s' "$parsed" | sed -n '2p')
tool_name=$(printf '%s' "$parsed" | sed -n '3p')
agent_type=$(printf '%s' "$parsed" | sed -n '4p')

# 셸 명령에서 파일 쓰기 대상(리다이렉트·tee)을 뽑는다.
redirect_targets() {
  printf '%s' "$1" \
    | grep -oE '(>>?[[:space:]]*|tee[[:space:]]+(-a[[:space:]]+)?)[^[:space:];|&)]+' \
    | sed -E 's/^(>>?[[:space:]]*|tee[[:space:]]+(-a[[:space:]]+)?)//'
}

# 단순 파일 변경 명령의 목적지를 뽑는다. 셸 리다이렉션이 아닌 cp/mv/touch/sed -i
# 우회도 승인 게이트의 동일한 경로 정책을 적용한다.
mutation_targets() {
  printf '%s' "$1" | python3 -c '
import os, shlex, sys

try:
    lexer = shlex.shlex(sys.stdin.read(), posix=True, punctuation_chars=True)
    lexer.whitespace_split = True
    tokens = list(lexer)
except Exception:
    sys.exit(0)

segments, current = [], []
for token in tokens:
    if token in {";", "&&", "||", "|", "&"}:
        if current:
            segments.append(current)
            current = []
    else:
        current.append(token)
if current:
    segments.append(current)

for segment in segments:
    while segment and "=" in segment[0] and not segment[0].startswith(("/", "./")):
        segment = segment[1:]
    if not segment:
        continue
    command = os.path.basename(segment[0])
    args = segment[1:]
    positional = [arg for arg in args if not arg.startswith("-")]
    if command in {"cp", "mv", "install"} and positional:
        print(positional[-1])
    elif command == "touch":
        for target in positional:
            print(target)
    elif command == "sed" and any(arg == "-i" or arg.startswith("-i") for arg in args) and positional:
        print(positional[-1])
' 2>/dev/null
}

is_write_tool() {
  case "$(printf '%s' "$1" | tr 'A-Z' 'a-z')" in
    write | edit | multiedit | notebookedit | apply_patch | applypatch) return 0 ;;
  esac
  return 1
}

# --- 1) 읽기 전용 서브에이전트 role 강제 (승인 여부와 무관) ---
case "$(printf '%s' "$agent_type" | tr 'A-Z-' 'a-z_')" in
  legacy_explorer | spec_gap_hunter | improvement_scout | migration_reviewer)
    block_readonly() {
      echo "BLOCKED by legacy-migration spec gate: '${agent_type}'은 읽기 전용 서브에이전트입니다. 파일을 만들거나 고칠 수 없습니다 — 발견한 내용을 인용과 함께 보고하고 종료하세요. 수정은 부모 에이전트가 승인 절차를 거쳐 수행합니다." >&2
      exit 2
    }

    is_write_tool "$tool_name" && block_readonly

    if [ -n "${shell_command}" ]; then
      # 파일을 바꾸는 명령
      if printf '%s' "$shell_command" | grep -qE '(^|[;&|][[:space:]]*)(rm|mv|cp|touch)[[:space:]]|sed[[:space:]]+-i|git[[:space:]]+(apply|commit|checkout|restore|reset)'; then
        block_readonly
      fi
      # 리다이렉트·tee (임시 경로는 허용)
      for target in $(redirect_targets "$shell_command"); do
        case "$target" in
          /tmp/* | /dev/* | /var/folders/*) continue ;;
        esac
        block_readonly
      done
    fi
    exit 0
    ;;
esac

# --- 2) 스펙 승인 게이트 ---

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

  # 2) 폴더 명명이 다르면 정규화한 branch feature가 포함된 케이스 하나만 찾는다.
  #    예: visitreview ↔ case-01-visit-review. 무관한 과거 케이스의 승인으로
  #    현재 branch 잠금이 풀리지 않게 전체 디렉터리의 임의 승인은 인정하지 않는다.
  local feature_key candidate case_key matched=0 approved=0
  feature_key=$(printf '%s' "$feature" | tr '[:upper:]' '[:lower:]' | tr -cd '[:alnum:]')
  for candidate in "$migration_docs"/*; do
    [ -d "$candidate" ] || continue
    case_key=$(basename "$candidate" | tr '[:upper:]' '[:lower:]' | tr -cd '[:alnum:]')
    case "$case_key" in
      *"$feature_key"*)
        matched=$((matched+1))
        if grep -qrE "$LIGHT_APPROVAL" "$candidate" 2>/dev/null || \
           grep -qrE "$FULL_APPROVAL" "$candidate" 2>/dev/null; then
          approved=$((approved+1))
        fi
        ;;
    esac
  done
  [ "$matched" -eq 1 ] && [ "$approved" -eq 1 ]
}

has_approval && exit 0

is_writable_before_approval() {
  case "$1" in
    "$root/docs/migration/"* | "$root/reports/"* | "$root/.claude/"* | "$root/.codex/"* | "$root/.agents/"*) return 0 ;;
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
  echo "BLOCKED by legacy-migration spec gate: 아직 현재 이관 케이스의 구현이 승인되지 않았습니다 — Light는 02_Spec.md 승인 체크박스, Full은 03_Plan.md의 'Implementation Permission: Granted'가 필요합니다. 승인 전에는 이관 문서(docs/migration/, reports/) 밖의 파일을 만들거나 수정할 수 없습니다. 다른 케이스의 승인이나 셸 쓰기로 우회하지 말고 사용자에게 현재 스펙 검토와 승인을 요청하세요." >&2
  exit 2
}

# 편집 도구 경유 수정
if [ -n "${file_path}" ]; then
  is_writable_before_approval "$(absolute_path "$file_path")" || block
fi

# 셸 경유 파일 쓰기(리다이렉트/tee) — 편집 도구를 막고 셸로 우회하는 것을 차단한다.
# 빌드·테스트·git 등 일반 명령은 통과시킨다.
if [ -n "${shell_command}" ]; then
  for target in $(redirect_targets "$shell_command"); do
    case "$target" in
      /dev/*) continue ;;
    esac
    is_writable_before_approval "$(absolute_path "$target")" || block
  done
  for target in $(mutation_targets "$shell_command"); do
    is_writable_before_approval "$(absolute_path "$target")" || block
  done
fi

exit 0
