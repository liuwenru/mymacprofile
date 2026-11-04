#!/usr/bin/env bash
# 记录并重装本机通过 `npx skills`（vercel-labs/skills）全局安装的 agent skills。
# 来源：~/.agents/.skill-lock.json，整理于 2026-11-03。
# 新增或删除 skill 后同步更新本文件；查看当前已装：npx -y skills ls -g
#
# 用法：
#   ./installskills.sh            # 依次安装下列全部 skills
#   ./installskills.sh --dry-run  # 只打印命令，不执行

set -eu

dry_run=0
case "${1:-}" in
--dry-run) dry_run=1 ;;
-h | --help)
  sed -n '2,9p' "${BASH_SOURCE[0]}"
  exit 0
  ;;
'') ;;
*)
  echo "错误：未知参数：$1" >&2
  exit 2
  ;;
esac

# 安装时选择的 agents（skills 本体放在 ~/.agents/skills，各 agent 目录软链接过去）
agents=(
  amp cline codex cursor droid fx gemini-cli github-copilot kilo
  kimi-code-cli opencode pi warp zed claude-code
)

agent_args=()
for a in "${agents[@]}"; do
  agent_args+=(-a "$a")
done

add() {
  local -a cmd=(npx -y skills add "$@" -g "${agent_args[@]}" -y)
  echo "+ ${cmd[*]}" >&2
  [[ "$dry_run" == 1 ]] || "${cmd[@]}"
}

# AntV 图表可视化
add antvis/chart-visualization-skills \
  --skill antv-g2-chart \
  --skill antv-g6-graph \
  --skill antv-gpt-vis \
  --skill antv-infographic \
  --skill antv-t8-ntv \
  --skill antv-x6-editor \
  --skill chart-visualization \
  --skill gpt-vis \
  --skill icon-retrieval

# Java heap dump / OOM 分析
add TencentBlueKing/bk-ci --skill java-heap-dump-triage

# 架构图、流程图等 HTML 图表（well-known 源）
add https://archify.si --skill archify

# ASCII 图对齐校验
add terrylica/cc-skills --skill ascii-diagram-validator

# 曾经安装、现已删除（锁文件中仍有记录），需要时取消注释：
# add firecrawl/skills --skill firecrawl
# add lightpanda-io/agent-skill --skill lightpanda
