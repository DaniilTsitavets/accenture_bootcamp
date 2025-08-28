#!/usr/bin/env bash
set -euo pipefail

# ----- Values rendered by Terraform -----
GH_OWNER="${GH_OWNER}"
GH_REPO="${GH_REPO}"
GH_LABELS="${GH_LABELS}"
REGION="${REGION}"
SSM_PARAM_NAME="${SSM_PARAM_NAME}"
NAME_PREFIX="${NAME_PREFIX}"
EPHEMERAL="${EPHEMERAL}"

# ----- Derived at runtime (keep double-$) -----
GH_URL="https://github.com/${GH_OWNER}/${GH_REPO}"
API="https://api.github.com"
RUNNER_DIR="/opt/actions-runner"

# IMDSv2 token
TOKEN=$(curl -sS -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" || true)

# If REGION not set or empty, read from IMDSv2
if [ -z "${REGION}" ] || [ "${REGION}" = "null" ]; then
  REGION=$(curl -sS -H "X-aws-ec2-metadata-token: $${TOKEN}" \
    http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
fi

# Get instance-id via IMDSv2
IID=$(curl -sS -H "X-aws-ec2-metadata-token: $${TOKEN}" \
  http://169.254.169.254/latest/meta-data/instance-id || true)
RUNNER_NAME="${NAME_PREFIX}-$${IID}"

# Packages (Amazon Linux 2023)
dnf -y update || true
dnf -y install tar gzip curl jq git icu libicu libunwind lttng-ust krb5-libs zlib openssl-libs --allowerasing || true

export LANG=C.UTF-8

# Read PAT from SSM Parameter Store (SecureString)
GH_PAT=$(aws ssm get-parameter \
  --name "${SSM_PARAM_NAME}" \
  --with-decryption \
  --region "${REGION}" \
  --query 'Parameter.Value' \
  --output text)

# Registration token (short-lived)
REG_TOKEN=$(curl -fsSL -X POST \
  -H "Authorization: token $${GH_PAT}" \
  -H "Accept: application/vnd.github+json" \
  "$${API}/repos/${GH_OWNER}/${GH_REPO}/actions/runners/registration-token" \
  | jq -r .token)

# Latest runner version
VER=$(curl -fsSL "$${API}/repos/actions/runner/releases/latest" \
  | jq -r .tag_name | sed 's/^v//')

# Install & configure runner
mkdir -p "$${RUNNER_DIR}"
cd "$${RUNNER_DIR}"

curl -fsSL -o "actions-runner-linux-x64-$${VER}.tar.gz" \
  "https://github.com/actions/runner/releases/download/v$${VER}/actions-runner-linux-x64-$${VER}.tar.gz"
tar xzf "actions-runner-linux-x64-$${VER}.tar.gz"

if [ -f ./bin/installdependencies.sh ]; then
  ./bin/installdependencies.sh || true
fi

export RUNNER_ALLOW_RUNASROOT=1

if [ "${EPHEMERAL}" = "true" ]; then
  ./config.sh --unattended --replace \
    --url "$${GH_URL}" \
    --token "$${REG_TOKEN}" \
    --name "$${RUNNER_NAME}" \
    --labels "${GH_LABELS}" \
    --ephemeral
else
  ./config.sh --unattended --replace \
    --url "$${GH_URL}" \
    --token "$${REG_TOKEN}" \
    --name "$${RUNNER_NAME}" \
    --labels "${GH_LABELS}"
fi

./svc.sh install
./svc.sh start