#!/usr/bin/env python3
"""Local, read-only telemetry. No network requests or third-party packages."""
import json
import pathlib
import shutil
import socket
import time

def read(path, default=""):
    try:
        return pathlib.Path(path).read_text().strip()
    except (OSError, ValueError):
        return default

def cpu():
    values = list(map(int, read('/proc/stat').splitlines()[0].split()[1:9]))
    return sum(values), values[3] + values[4]

def network():
    result = {}
    for row in read('/proc/net/dev').splitlines()[2:]:
        name, fields = row.split(':', 1)
        name = name.strip()
        # Count hardware links only (they have a device entry). Bridges and veth pairs repeat
        # packets already counted, or carry traffic that never leaves the machine.
        if name != 'lo' and pathlib.Path('/sys/class/net', name, 'device').exists():
            nums = fields.split()
            result[name] = (int(nums[0]), int(nums[8]))
    return result

def hwmon_temperatures():
    """CPU temperatures from hwmon, for CPUs (AMD Ryzen among them) with no CPU thermal zone."""
    temps = []
    for path in pathlib.Path('/sys/class/hwmon').glob('hwmon*'):
        if read(path / 'name') not in ('k10temp', 'zenpower', 'coretemp'):
            continue
        labels = {read(label): label.parent / label.name.replace('_label', '_input') for label in path.glob('temp*_label')}
        sensor = next((labels[name] for name in ('Tdie', 'Tctl', 'Package id 0') if name in labels), path / 'temp1_input')
        try:
            temps.append(int(read(sensor)) / 1000)
        except ValueError:
            pass
    return temps

previous_cpu, previous_net, previous_time = cpu(), network(), time.monotonic()
while True:
    theme = read(pathlib.Path.home() / '.local/state/omarchy/current/theme.name')
    if theme != 'jarvis':
        print(json.dumps({'theme': theme}), flush=True)
        time.sleep(2)
        previous_cpu, previous_net, previous_time = cpu(), network(), time.monotonic()
        continue
    now = time.monotonic()
    current_cpu, current_net = cpu(), network()
    delta = current_cpu[0] - previous_cpu[0]
    usage = 100 * (1 - (current_cpu[1] - previous_cpu[1]) / delta) if delta else 0
    mem = {line.split(':')[0]: int(line.split()[1]) for line in read('/proc/meminfo').splitlines()}
    disk = shutil.disk_usage(str(pathlib.Path.home()))
    active = [n for n in current_net if read('/sys/class/net/' + n + '/operstate') == 'up']
    rx = sum(max(0, current_net[n][0] - previous_net.get(n, current_net[n])[0]) for n in active) / max(.01, now - previous_time)
    tx = sum(max(0, current_net[n][1] - previous_net.get(n, current_net[n])[1]) for n in active) / max(.01, now - previous_time)
    battery = None
    for path in pathlib.Path('/sys/class/power_supply').glob('*'):
        # Scope "Device" marks a battery inside a peripheral, such as a wireless mouse or trackpad.
        if read(path / 'type') == 'Battery' and read(path / 'scope') != 'Device':
            battery = {'percent': int(read(path / 'capacity', '0')), 'status': read(path / 'status')}
            break
    temps = []
    for path in pathlib.Path('/sys/class/thermal').glob('thermal_zone*'):
        if read(path / 'type') in ('x86_pkg_temp', 'cpu-thermal'):
            try:
                temps.append(int(read(path / 'temp')) / 1000)
            except ValueError:
                pass
    if not temps:
        temps = hwmon_temperatures()
    data = dict(theme=theme, cpu=round(usage, 1), memory=round(100*(1-mem['MemAvailable']/mem['MemTotal']), 1),
                memoryUsed=round((mem['MemTotal']-mem['MemAvailable'])/1048576, 1), memoryTotal=round(mem['MemTotal']/1048576, 1),
                disk=round(100*disk.used/disk.total, 1), diskFree=round(disk.free/1073741824),
                rx=round(rx/1024, 1), tx=round(tx/1024, 1), interface=', '.join(active) or 'OFFLINE',
                battery=battery, temperature=round(max(temps)) if temps else None,
                uptime=int(float(read('/proc/uptime', '0').split()[0])), host=socket.gethostname())
    print(json.dumps(data), flush=True)
    previous_cpu, previous_net, previous_time = current_cpu, current_net, now
    time.sleep(2)
