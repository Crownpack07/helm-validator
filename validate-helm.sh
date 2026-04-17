#!/usr/bin/env bash

set -u

# Defaults
ENVS=("dev" "qa" "uat" "prd")
MODE="template"   # template | lint | both
TARGET_DIR="$(pwd)"

print_help() {
  echo "Usage: validate-helm [options] [directory]"
  echo ""
  echo "Options:"
  echo "  -e, --envs       Comma-separated envs (default: dev,qa,uat,prd)"
  echo "  -m, --mode       template | lint | both (default: template)"
  echo "  -h, --help       Show this help"
  echo ""
  echo "Examples:"
  echo "  validate-helm"
  echo "  validate-helm -m both"
  echo "  validate-helm -e dev,qa"
  echo "  validate-helm ../other-dir"
}

# Parse args
while [[ $# -gt 0 ]]; do
  case $1 in
    -e|--envs)
      IFS=',' read -r -a ENVS <<< "$2"
      shift 2
      ;;
    -m|--mode)
      MODE="$2"
      shift 2
      ;;
    -h|--help)
      print_help
      exit 0
      ;;
    *)
      TARGET_DIR="$1"
      shift
      ;;
  esac
done

cd "$TARGET_DIR" || {
  echo "❌ Failed to access directory: $TARGET_DIR"
  exit 1
}

echo "🔍 Running Helm validation in: $(pwd)"
echo "Mode: $MODE"
echo "Envs: ${ENVS[*]}"
echo ""

FAILED=0

for dir in */ ; do
  [ -d "$dir" ] || continue

  CHART_PATH="${dir%/}"

  if [ ! -f "$CHART_PATH/Chart.yaml" ]; then
    echo "⏭️  Skipping $CHART_PATH (no Chart.yaml)"
    continue
  fi

  echo "📦 Chart: $CHART_PATH"

  for env in "${ENVS[@]}"; do
    VALUES_FILE="$CHART_PATH/values.$env.yaml"

    if [ ! -f "$VALUES_FILE" ]; then
      echo "   ⚠️  Missing values.$env.yaml"
      continue
    fi

    echo "   🔧 Env: $env"

    run_check() {
      local label="$1"
      shift

      OUTPUT=$("$@" 2>&1)
      EXIT_CODE=$?

      if [ $EXIT_CODE -ne 0 ]; then
        echo "   ❌ $label FAILED"
        echo "$OUTPUT" | sed 's/^/      /'
        FAILED=1
      else
        echo "   ✅ $label passed"
      fi
    }

    case "$MODE" in
      template)
        run_check "template" helm template "./$CHART_PATH" -f "$VALUES_FILE"
        ;;
      lint)
        run_check "lint" helm lint "./$CHART_PATH" -f "$VALUES_FILE"
        ;;
      both)
        run_check "lint" helm lint "./$CHART_PATH" -f "$VALUES_FILE"
        run_check "template" helm template "./$CHART_PATH" -f "$VALUES_FILE"
        ;;
      *)
        echo "❌ Invalid mode: $MODE"
        exit 1
        ;;
    esac
  done

  echo ""
done

echo "----------------------------------------"

if [ $FAILED -ne 0 ]; then
  echo "❌ Validation failed"
  exit 1
else
  echo "✅ All validations passed"
  exit 0
fi