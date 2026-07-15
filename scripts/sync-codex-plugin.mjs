#!/usr/bin/env node
// 루트(정본)의 이식 가능한 자산을 Codex 플러그인 패키지(plugins/legacy-migration/)로 동기화한다.
// 목적: 루트와 Codex 사본의 drift 방지 + prompts 누락 해소.
//
// Codex 전용 파일은 건드리지 않는다:
//   - skills/legacy-migration/SKILL.md, skills/legacy-migration/references/*  (Codex 변형)
//   - hooks/hooks.json  (${PLUGIN_ROOT} + statusMessage, Codex 변형)
//   - .codex-plugin/plugin.json
import { spawnSync } from "node:child_process";
import { cpSync, existsSync, mkdirSync, rmSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const codex = join(root, "plugins", "legacy-migration");
const dryRun = process.argv.includes("--dry-run");
// --check: 아무것도 쓰지 않고 루트와 Codex 사본의 drift만 검사한다 (CI용). drift 시 exit 1.
const checkOnly = process.argv.includes("--check");

// 디렉터리는 mirror(대상 삭제 후 복사)로 stale 파일까지 정리한다.
const dirSyncs = ["templates", "prompts"];
// 파일은 덮어쓰기. Codex 전용 변형이 아닌 것만.
const fileSyncs = ["guides/walkthrough-full-mode.md", "hooks/spec-gate.sh"];

function syncDir(rel) {
  const src = join(root, rel);
  const dest = join(codex, rel);
  if (!existsSync(src)) {
    console.warn(`skip (소스 없음): ${rel}`);
    return;
  }
  console.log(`dir   ${rel}  ->  plugins/legacy-migration/${rel}`);
  if (dryRun) return;
  rmSync(dest, { recursive: true, force: true });
  cpSync(src, dest, { recursive: true });
}

function syncFile(rel) {
  const src = join(root, rel);
  const dest = join(codex, rel);
  if (!existsSync(src)) {
    console.warn(`skip (소스 없음): ${rel}`);
    return;
  }
  console.log(`file  ${rel}  ->  plugins/legacy-migration/${rel}`);
  if (dryRun) return;
  mkdirSync(dirname(dest), { recursive: true });
  cpSync(src, dest);
}

function checkDrift(rel) {
  const src = join(root, rel);
  const dest = join(codex, rel);
  if (!existsSync(src)) return true;
  const result = spawnSync("diff", ["-rq", src, dest], { encoding: "utf8" });
  if (result.status !== 0) {
    console.error(`DRIFT: ${rel}\n${result.stdout || ""}`);
    return false;
  }
  return true;
}

if (!existsSync(codex)) {
  console.error(`Codex 플러그인 디렉터리가 없습니다: ${codex}`);
  process.exit(1);
}

if (checkOnly) {
  const clean = [...dirSyncs, ...fileSyncs].map(checkDrift).every(Boolean);
  if (!clean) {
    console.error(
      "\n루트와 Codex 사본이 어긋났습니다. `npm run sync-codex`를 실행해 동기화하세요.",
    );
    process.exit(1);
  }
  console.log("drift 없음 — 루트와 Codex 사본이 일치합니다.");
  process.exit(0);
}

for (const rel of dirSyncs) syncDir(rel);
for (const rel of fileSyncs) syncFile(rel);

console.log(
  `\n동기화 완료${dryRun ? " (dry-run)" : ""}. ` +
    "Codex 전용 파일(SKILL.md / references / hooks.json / .codex-plugin)은 유지됩니다.",
);
