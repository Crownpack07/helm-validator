# Helm Validator

A small shell utility for validating Helm charts in a directory across multiple environment-specific values files.

## Overview

This utility helps you run `helm lint` and/or `helm template` for all Helm charts in a given directory. It is designed for local validation of charts and values files before deployment.

It supports:

- scanning every subdirectory for `Chart.yaml`
- validating environment-specific `values.<env>.yaml` files
- running one or both modes: `template`, `lint`, or `both`

## Prerequisites

Before using this utility, make sure you have:

- macOS, Linux, or another POSIX-compatible shell environment
- `bash` or `zsh`
- [Helm](https://helm.sh) installed and available on your `PATH`

To verify Helm is installed:

```bash
helm version
```

## Install the utility

You can install the utility using the included installer script.

### Step 1: Clone the repository

```bash
git clone https://github.com/<your-user>/helm-validator.git
cd helm-validator
```

### Step 2: Run the installer

```bash
./install.sh
```

This script will:

- copy `validate-helm-charts.sh` to `~/.local/bin/validate-helm`
- make the script executable
- add `~/.local/bin` to your shell config if needed

After install, reload your shell:

```bash
source ~/.zshrc   # or ~/.bashrc or ~/.profile depending on your shell
```

Then run:

```bash
validate-helm
```

## Short-hand usage without installing

You can run the validator directly from the repository without installing it.

```bash
cd helm-validator
./validate-helm-charts.sh
```

You can also run the script from anywhere if you provide the repository path:

```bash
/path/to/helm-validator/validate-helm-charts.sh
```

## Usage

```bash
validate-helm [options] [directory]
```

When using the script directly:

```bash
./validate-helm-charts.sh [options] [directory]
```

### Options

- `-e, --envs` : comma-separated list of environments to validate
  - default: `dev,qa,uat,prd`
- `-m, --mode` : `template`, `lint`, or `both`
  - default: `template`
- `-h, --help` : show help information

### Directory

- Optional directory to validate
- Default: current working directory

## Examples

### Validate templates only for all default envs

```bash
validate-helm
```

### Validate both lint and template for all default envs

```bash
validate-helm -m both
```

### Validate only `dev` and `qa` values files

```bash
validate-helm -e dev,qa
```

### Validate a different directory

```bash
validate-helm ../charts
```

### Direct script execution without install

```bash
./validate-helm-charts.sh -m both -e dev,qa ../my-charts
```

## What the script does

For each chart directory in the target path, the script:

1. detects whether `Chart.yaml` exists
2. skips directories without a chart
3. checks for `values.<env>.yaml` files for each requested environment
4. runs the selected Helm command(s):
   - `helm template` for rendering templates
   - `helm lint` for chart linting

If any check fails, the script reports the error output and exits with a non-zero status.

## Output behavior

- `✅` indicates a passed validation
- `❌` indicates a failed validation
- `⚠️` indicates a missing values file for a specific environment
- The script prints a summary at the end

## Troubleshooting

- If the script cannot access the directory, verify the path and permissions.
- If `helm` is not found, install Helm and ensure it is on your `PATH`.
- If a values file is missing, add `values.<env>.yaml` to the chart directory or adjust the `--envs` list.

## Notes

- The installer writes to `~/.local/bin` and updates your shell config only if needed.
- If your shell is not `bash` or `zsh`, the installer falls back to `~/.profile`.
- You can customize the target directory and modes without modifying the script.

## License

This repository is licensed under the MIT License. See `LICENSE` for details.
