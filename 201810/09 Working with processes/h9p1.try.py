#!/usr/bin/python36
import os
import re
import datetime
from prettytable import PrettyTable
from pathlib import Path

x = PrettyTable()
x.field_names = ["PID", "TTY", "STAT", "TIME", "COMMAND"]
x.align["COMMAND"] = "l"
#print os.listdir('/proc')
path = "/proc"
digits = re.compile("(^\d+)")
ticks_ps = os.sysconf(os.sysconf_names['SC_CLK_TCK'])

with os.scandir(path) as it:
    for entry in it:
        if entry.is_dir() and digits.match(entry.name):
            pid_proc = path + "/" + entry.name
            process_stat = open(pid_proc + "/stat", 'r')
            proc_cmdline = open(pid_proc + "/cmdline", 'r')
            #proc_comm = open("/proc/" + entry.name + "/comm", 'r') #used from stat
            lines = process_stat.read().split(' ')
            #PID : lines[0]
            #STAT :lines[2]
            #TTY : lines[6]
            #TIME : lines[13] + lines[14]
            #COMM : line[1]
            #x.add_row([lines[0], lines[7], lines[2], 'user : ' + lines[13] + '; kernel : ' + lines[14], proc_cmdline.read()])
            #x.add_row([lines[0], lines[7], lines[2], int((int(lines[13])+int(lines[14]))/ticks_ps), proc_cmdline.read()])
            #x.add_row([lines[0], lines[7], lines[2], str(datetime.timedelta(seconds=int((int(lines[13]) + int(lines[14]))/ticks_ps))), proc_cmdline.read()])
            command = proc_cmdline.read().rstrip()
            if not command:
                #command = proc_comm.read().rstrip() #used from stat
                command = lines[1].rstrip()
            # if stdout fd (/proc/$pid/fd/1) contains tty show it if not show ? but more correct is to parse tty_nr
            #temp print(Path(pid_proc + "/fd/1").resolve())
            tty_nr = int(lines[6])
            tty = "?"
            if tty_nr != 0:
                if str((Path(pid_proc + "/fd/1").resolve())).startswith("/dev"): # check string begins from /dev
                    tty = Path(pid_proc + "/fd/1").resolve()
            x.add_row([lines[0], tty, lines[2], str(datetime.timedelta(seconds=int((int(lines[13]) + int(lines[14]))/ticks_ps))), command])
            #close
            process_stat.close()
            proc_cmdline.close()
            #proc_comm.close() #used from stat
x.border = False
print(x)
