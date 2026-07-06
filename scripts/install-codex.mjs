#!/usr/bin/env node
// Codex marketplace와 legacy-migration 플러그인을 한 번에 설치한다.
import { spawnSync } from "node:child_process";

const MARKETPLACE_SOURCE = "winkrj/ai-legacy-migration-framework-kit";
const MARKETPLACE_NAME = "legacy-migration-kit";
const PLUGIN = `legacy-migration@${MARKETPLACE_NAME}`;
const dryRun = process.argv.includes("--dry-run");

function run(args, { allowFailure = false } = {}) {
  console.log(`codex ${args.join(" ")}`);
  if (dryRun) return;

  const result = spawnSync("codex", args, { stdio: "inherit" });
  if (result.error?.code === "ENOENT") {
    console.error("Codex CLI를 찾을 수 없습니다. Codex CLI를 설치한 뒤 다시 실행하세요.");
    process.exit(1);
  }
  if (result.status !== 0 && !allowFailure) process.exit(result.status ?? 1);
}

// 기존 marketplace 등록은 실패할 수 있으므로 add 후 upgrade로 수렴시킨다.
run(["plugin", "marketplace", "add", MARKETPLACE_SOURCE], { allowFailure: true });
run(["plugin", "marketplace", "upgrade", MARKETPLACE_NAME], { allowFailure: true });
run(["plugin", "add", PLUGIN]);

console.log(`
설치 완료: ${PLUGIN}
새 Codex thread를 열고 "legacy-migration 플러그인으로 이 기능 이관을 시작해줘"라고 요청하세요.
플러그인 훅은 최초 사용 시 내용을 검토하고 신뢰해야 활성화됩니다.`);
