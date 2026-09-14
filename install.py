#!/usr/bin/env python3
"""Install Jarvis into the current user's Omarchy configuration."""
import argparse
from datetime import datetime
import json
from pathlib import Path
import shutil
import subprocess
import sys
import time


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--no-activate', action='store_true', help='copy files only; do not change the running desktop')
    args = parser.parse_args()
    source = Path(__file__).resolve().parent
    home = Path.home()
    config = home / '.config/omarchy'
    theme = config / 'themes/jarvis'
    plugin = config / 'plugins/jase.jarvis'
    launcher = home / '.local/bin/jarvis'
    desktop = home / '.local/share/applications/jarvis.desktop'
    backup = home / '.local/state/jarvis/backups' / datetime.now().strftime('%Y%m%d-%H%M%S-%f')
    if not args.no_activate:
        for executable in ('omarchy', 'omarchy-shell', 'quickshell'):
            if not shutil.which(executable):
                parser.error(f'{executable} is required. Run this inside an Omarchy 4 Quickshell session.')
        subprocess.run(['omarchy-shell', 'shell', 'ping'], check=True, stdout=subprocess.DEVNULL)

    def save(path):
        if path.exists() or path.is_symlink():
            target = backup / path.relative_to(home)
            target.parent.mkdir(parents=True, exist_ok=True)
            if path.is_dir():
                shutil.copytree(path, target, symlinks=True)
            else:
                shutil.copy2(path, target, follow_symlinks=False)

    # A standard theme install may already have cloned this repository into theme.
    same_theme = source == theme.resolve()
    save(config / 'shell.json')
    save(home / '.local/state/omarchy/current/theme.name')
    for target in (plugin, launcher, desktop):
        save(target)
    if not same_theme:
        save(theme)
    print(f'Existing settings/files backed up under {backup}')
    if not same_theme:
        theme.mkdir(parents=True, exist_ok=True)
        for name in ('colors.toml', 'shell.toml'):
            shutil.copy2(source / name, theme / name)
        shutil.copytree(source / 'backgrounds', theme / 'backgrounds', dirs_exist_ok=True)
    shutil.copytree(source / 'hud', plugin, dirs_exist_ok=True)
    launcher.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(source / 'bin/jarvis', launcher)
    launcher.chmod(0o755)
    # Desktop Entry Exec quoting is separate from shell quoting.
    exec_path = str(launcher).replace('%', '%%')
    for character in ('\\', '"', '`', '$'):
        exec_path = exec_path.replace(character, '\\' + character)
    exec_path = exec_path.replace('\\', '\\\\')
    desktop.parent.mkdir(parents=True, exist_ok=True)
    desktop.write_text('[Desktop Entry]\nType=Application\nName=Jarvis Command Interface\n'
                       'Comment=Open the Jarvis desktop HUD and live system overview\n'
                       f'Exec="{exec_path}"\nIcon=utilities-system-monitor\nTerminal=false\n'
                       'Categories=System;Monitor;\nKeywords=Jarvis;HUD;CPU;Memory;Desktop;\n')
    if args.no_activate:
        print('Files installed. The running desktop was not changed.')
        return
    subprocess.run(['omarchy-shell', 'shell', 'rescanPlugins'], check=True)
    for _ in range(40):
        result = subprocess.run(['omarchy-shell', 'shell', 'listPlugins'], capture_output=True, text=True)
        try:
            if any(p['id'] == 'jase.jarvis' for p in json.loads(result.stdout)):
                break
        except (ValueError, KeyError, TypeError):
            pass
        time.sleep(0.25)
    else:
        raise RuntimeError('Omarchy did not discover the HUD. Files are installed; restart the shell and rerun this installer.')
    subprocess.run(['omarchy', 'plugin', 'enable', 'jase.jarvis'], check=True)
    subprocess.run(['omarchy', 'theme', 'set', 'jarvis'], check=True)
    subprocess.run(['omarchy', 'restart', 'shell'], check=True)
    print('Jarvis installed. Open "Jarvis Command Interface" from the application launcher.')


if __name__ == '__main__':
    try:
        main()
    except (OSError, RuntimeError, subprocess.CalledProcessError) as error:
        print(f'Installation stopped: {error}', file=sys.stderr)
        sys.exit(1)
