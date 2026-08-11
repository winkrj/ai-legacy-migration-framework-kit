#!/bin/bash
# 빌드·테스트 검증 게이트 (이관 대상 프로젝트에 복사해서 사용)
#
# 목적: "완료했다"를 주장이 아니라 실행 결과로 증명한다.
# 이 스크립트가 통과하지 않으면 작업은 완료가 아니다.
#
# 사용법
#   ./scripts/verify.sh                 구현 후 빌드 + 단위 테스트
#   ./scripts/verify.sh --baseline      이관 전 기준선 빌드 + 단위 테스트
#   ./scripts/verify.sh --integration   + 통합 테스트 (아래 INTEGRATION_CMD 설정 필요)
#
# 결과는 reports/verify-<타임스탬프>.txt 에 남고, 실패하면 비정상 종료한다.
# AI 에이전트는 완료 보고에 이 리포트 경로를 인용해야 한다.
#
# ── 프로젝트에 맞게 조정할 부분 ──────────────────────────────
# 빌드 도구는 아래에서 자동 탐지한다. 명령이 다르면 이 블록만 고친다.
# 통합 테스트는 프로젝트마다 방식이 달라 기본값이 없다 — 쓰려면 INTEGRATION_CMD를 채운다.
set -uo pipefail

cd "$(dirname "$0")/.." || exit 1
ROOT=$(pwd)

WITH_INTEGRATION=0
REPORT_KIND="verify"
for arg in "$@"; do
  case "$arg" in
    --integration) WITH_INTEGRATION=1 ;;
    --baseline) REPORT_KIND="baseline-verify" ;;
    -h|--help) sed -n '2,13p' "$0"; exit 0 ;;
    *) echo "알 수 없는 옵션: $arg" >&2; exit 2 ;;
  esac
done

# ── 빌드 도구 탐지 ────────────────────────────────────────
INTEGRATION_CMD=""   # 예: mvn -B test -P integration-test / ./gradlew integrationTest

if [ -f "$ROOT/gradlew" ]; then
  BUILD_CMD="./gradlew build -x test"
  TEST_CMD="./gradlew test"
elif [ -f "$ROOT/mvnw" ]; then
  BUILD_CMD="./mvnw -B install -DskipTests"
  TEST_CMD="./mvnw -B test"
elif [ -f "$ROOT/pom.xml" ]; then
  BUILD_CMD="mvn -B install -DskipTests"
  TEST_CMD="mvn -B test"
elif [ -f "$ROOT/package.json" ]; then
  BUILD_CMD="npm run build --if-present"
  TEST_CMD="npm test"
else
  echo "빌드 도구를 탐지하지 못했습니다. 이 스크립트의 탐지 블록에 프로젝트 명령을 직접 적으세요." >&2
  exit 3
fi

# JDK 버전을 고정해야 하는 프로젝트는 아래 주석을 풀고 버전을 지정한다.
# 개인 절대경로를 문서에 적어두면 다른 사람이 그대로 쓰지 못한다 — 탐지가 원칙이다.
# if command -v /usr/libexec/java_home >/dev/null 2>&1; then
#   export JAVA_HOME=$(/usr/libexec/java_home -v 21) || exit 3
# fi

STAMP=$(date +%Y%m%d-%H%M%S)
REPORT="$ROOT/reports/$REPORT_KIND-$STAMP.txt"
mkdir -p "$ROOT/reports"

{
  echo "verify 실행 결과"
  echo "종류: $([ "$REPORT_KIND" = baseline-verify ] && echo baseline || echo migration)"
  echo "시각: $(date '+%Y-%m-%d %H:%M:%S')"
  echo "통합 테스트 포함: $([ "$WITH_INTEGRATION" = 1 ] && echo yes || echo no)"
  echo "git: $(git rev-parse --abbrev-ref HEAD 2>/dev/null) $(git rev-parse --short HEAD 2>/dev/null)"
  echo "----"
} > "$REPORT"

FAILED=0

run_step() { # run_step <이름> <명령 문자열>
  local name="$1" cmd="$2"
  echo "▶ $name"
  {
    echo ""
    echo "== $name"
    echo "\$ $cmd"
  } >> "$REPORT"
  # shellcheck disable=SC2086
  eval "$cmd" >> "$REPORT" 2>&1
  local code=$?
  echo "exit=$code" >> "$REPORT"
  if [ "$code" -ne 0 ]; then
    echo "  실패 (exit=$code)"
    FAILED=1
  else
    echo "  통과"
  fi
}

run_step "빌드" "$BUILD_CMD"

# 빌드가 깨졌으면 테스트는 의미가 없다.
if [ "$FAILED" -eq 0 ]; then
  run_step "단위 테스트" "$TEST_CMD"

  if [ "$WITH_INTEGRATION" = 1 ] && [ "$FAILED" -eq 0 ]; then
    if [ -z "$INTEGRATION_CMD" ]; then
      echo "  건너뜀 — INTEGRATION_CMD가 비어 있습니다"
      echo "" >> "$REPORT"
      echo "== 통합 테스트: 건너뜀 (INTEGRATION_CMD 미설정)" >> "$REPORT"
      FAILED=1
    else
      run_step "통합 테스트" "$INTEGRATION_CMD"
    fi
  fi
fi

{
  echo ""
  echo "----"
  echo "결과: $([ "$FAILED" -eq 0 ] && echo PASS || echo FAIL)"
} >> "$REPORT"

echo ""
echo "리포트: ${REPORT#"$ROOT"/}"
if [ "$FAILED" -eq 0 ]; then
  echo "결과: PASS"
  exit 0
fi
echo "결과: FAIL — 리포트에서 실패 구간을 확인하세요."
exit 1
