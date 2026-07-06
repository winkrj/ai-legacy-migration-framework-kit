#!/usr/bin/env node
// Codex 커스텀 프롬프트 설치기.
// codex/prompts/*.md를 ~/.codex/prompts/로 복사한다. 그 외에는 아무것도 건드리지 않는다.
import { copyFileSync, mkdirSync, readdirSync, existsSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";
import { homedir } from "node:os";

const src = join(dirname(fileURLToPath(import.meta.url)), "..", "codex", "prompts");
const dest = join(homedir(), ".codex", "prompts");

if (!existsSync(src)) {
  console.error(`prompts 폴더를 찾을 수 없습니다: ${src}`);
  process.exit(1);
}

mkdirSync(dest, { recursive: true });

const files = readdirSync(src).filter((f) => f.endsWith(".md"));
for (const f of files) {
  copyFileSync(join(src, f), join(dest, f));
  console.log(`installed  /${f.replace(/\.md$/, "")}  →  ${join(dest, f)}`);
}

console.log(`
완료. Codex 세션에서 사용:
  /migrate-conventions [참고-프로젝트-경로]   컨벤션 등록
  /migrate-start <기능명> <레거시경로>        분석 + 스펙 초안 (여기서 멈춤)
  /migrate-implement <기능명>                 스펙 승인 후 구현
  /migrate-validate <케이스명>                이관 문서 검사
  /migrate-full <기능명> <레거시경로>         결제·인증·PII·공유 코드용 Full 모드

권장: 타겟 프로젝트 루트에 kit의 agent/codex/AGENTS.md를 복사(또는 병합)하세요.`);
