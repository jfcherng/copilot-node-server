import json
import os
import sys
from pathlib import Path
from typing import Any

from packaging.version import Version

PROJECT_ROOT = Path(__file__).parents[2]

# add directory of this script to sys.path
sys.path.append(str(Path(__file__).parent))

from modules.github_utils import get_latest_version_tag  # noqa: E402


def load_json(file: str | Path) -> Any:
    with open(file) as f:
        return json.load(f)


def main() -> None:
    package_json = load_json(PROJECT_ROOT / "package.json")
    v_our = Version(package_json["version"])
    print(f"Our version: {v_our}")

    if not (latest_tag := get_latest_version_tag("github/copilot.vim")):
        return

    v_their = Version(latest_tag)
    print(f"Their version: {v_their}")

    with open(os.environ["GITHUB_OUTPUT"], "a") as fh:
        print(f"REQUIRES_UPDATE={int(v_their > v_our)}", file=fh)
        print(f"LATEST_TAG={latest_tag}", file=fh)
        print(f"BRANCH_NAME={latest_tag}", file=fh)


if __name__ == "__main__":
    main()
