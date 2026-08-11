#!/usr/bin/env python3
"""Build the package-safe single-file mod entry from tested source modules."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def module_body(relative_path: str, first_line: str | None = None, return_line: str | None = None) -> str:
    text = (ROOT / relative_path).read_text(encoding="utf-8")
    if first_line:
        text = text.replace(first_line + "\n", "", 1)
    if return_line:
        text = text.replace("\n" + return_line + "\n", "\n")
    return text.rstrip()


parts = [
    module_body("lib/battle_hud.lua", first_line='local BattleHud = require("lib.battle_hud")', return_line="return BattleHud"),
    module_body("lib/entry.lua"),
]

output = "-- Generated self-contained release entry: installed mods do not extend Lua package.path.\n\n"
output += "\n\n".join(parts) + "\n"
(ROOT / "main.lua").write_text(output, encoding="utf-8")
print(f"Bundled main.lua ({len(output.splitlines())} lines)")
