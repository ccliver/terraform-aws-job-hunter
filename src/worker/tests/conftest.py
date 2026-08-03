"""Worker-package pytest configuration.

worker/handler.py has no config defaults of its own (12-factor: config lives
in the environment) — LOCATION/WORK_TYPE/BUILTIN_LOCATION/BUILTIN_WORK_TYPE/
TITLE_KEYWORDS/EXCLUDE_TITLE_KEYWORDS/ENABLE_CLEARANCE_FILTER are required env
vars, normally supplied by Terraform (see variables.tf for the real
defaults). Set at module level, matching the same values, so the existing
test suite exercises realistic baseline behavior without every test setting
them individually; tests that need a different value still use
monkeypatch.setenv to override.
"""

import os

os.environ["LOCATION"] = ""
os.environ["WORK_TYPE"] = "remote"
os.environ["BUILTIN_LOCATION"] = ""
os.environ["BUILTIN_WORK_TYPE"] = "remote"
os.environ["TITLE_KEYWORDS"] = "platform,sre,site reliability,devops,cloud engineer,infrastructure,staff engineer"
os.environ["EXCLUDE_TITLE_KEYWORDS"] = "manager,director"
os.environ["ENABLE_CLEARANCE_FILTER"] = "true"
