#!/usr/bin/python36
import os
import re
import datetime
from prettytable import PrettyTable
from pathlib import Path

x = PrettyTable()
x.field_names = ["PID", "TTY", "STAT", "TIME", "COMMAND"]
x.align["COMMAND"] = "l"
path = "/proc"
digits = re.compile("(^\d+)")
ticks_ps = os.sysconf(os.sysconf_names['SC_CLK_TCK'])

with os.scandir(path) as it:
    for entry in it:
        if entry.is_dir() and digits.match(entry.name):
            pid_proc = path + "/" + entry.name
            process_stat = open(pid_proc + "/stat", 'r')
            proc_cmdline = open(pid_proc + "/cmdline", 'r')
            lines = process_stat.read().split(' ')
            command = proc_cmdline.read().rstrip()
            if not command:
                command = lines[1].rstrip()
            tty_nr = int(lines[6])
            tty = "?"
            if tty_nr != 0:
                if str((Path(pid_proc + "/fd/1").resolve())).startswith("/dev"): # check string begins from /dev
                    tty = Path(pid_proc + "/fd/1").resolve()
            x.add_row([lines[0], tty, lines[2], str(datetime.timedelta(seconds=int((int(lines[13]) + int(lines[14]))/ticks_ps))), command])
            process_stat.close()
            proc_cmdline.close()
x.border = False
print(x)
