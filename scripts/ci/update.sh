#!/usr/bin/env bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${SCRIPT_DIR}/../.."
TMP_DIR="${PROJECT_DIR}/tmp"
PACKAGE_JSON="${PROJECT_DIR}/package.json"

REPO_URL=https://github.com/github/copilot.vim.git
COMMIT_HASH=

rm -rf "${TMP_DIR}" && mkdir -p "${TMP_DIR}"
rm -rf "${PROJECT_DIR}/copilot" && mkdir -p "${PROJECT_DIR}/copilot"

if [[ ${COPILOT_VERSION} == "" ]]; then
    read -erp "Repository revision to be downloaded (such as 'v1.26.0', '3c3775fc38' or 'origin/main'): " repo_rev
else
    repo_rev="${COPILOT_VERSION}"
fi

if [[ -z ${repo_rev} ]]; then
    echo "[ERROR] No revision specified. Exiting..."
    exit 1
fi

if [[ ${repo_rev} =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    repo_rev="v${repo_rev}"
    echo "[INFO] Prepend \"v\" to the revision: ${repo_rev}"
fi
repo_rev_no_v=${repo_rev#"v"}

# download repository to the temporary directory
{
    pushd "${TMP_DIR}" || exit 1

    git init &&
        git remote add origin "${REPO_URL}" &&
        git fetch origin "${repo_rev}" --depth=1 &&
        git checkout -f FETCH_HEAD

    if [[ $? != "0" ]]; then
        echo "[ERROR] Failed to download the repository. Exiting..."
        exit 1
    fi

    COMMIT_HASH=$(git rev-parse HEAD)

    popd || exit
}

# delete unnecessary files
find "${TMP_DIR}" -name "*.map" -type f -delete

# update
mv "${TMP_DIR}/dist" "${PROJECT_DIR}/copilot/dist"
(
    echo "commit = ${COMMIT_HASH}"
) >"${PROJECT_DIR}/copilot/info.txt"

# update package.json
jj -v "${repo_rev_no_v}" -i "${PACKAGE_JSON}" -o "${PACKAGE_JSON}" "version"

# clean up
rm -rf "${TMP_DIR}"
