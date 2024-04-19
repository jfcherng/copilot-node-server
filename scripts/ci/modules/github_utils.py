import json
import urllib.parse
import urllib.request

from packaging.version import InvalidVersion, Version


def get_latest_version_tag(repo: str) -> str | None:
    """Returns the latest version tag for a Github repository 'username/reponame'."""
    api_url = f"https://api.github.com/repos/{repo}/tags"
    with urllib.request.urlopen(api_url) as f:
        tags = json.load(f)

    versions: list[Version | None] = []
    for tag in tags:
        try:
            version = Version(tag["name"])
        except InvalidVersion:
            version = None
        versions.append(version)

    try:
        latest_version, latest_tag = max(zip(versions, tags))
    except ValueError:
        return None

    return latest_tag["name"] if latest_version else None
