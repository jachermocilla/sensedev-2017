#!/usr/bin/env python

from datetime import datetime

import time
import sys
import tos

if '-h' in sys.argv:
    print "Usage:", sys.argv[0], "serial@/dev/ttyUSB0:115200"
    print "      ", sys.argv[0], "network@host:port"
    sys.exit()

am = tos.AM()

f = open("sensor.dat","w")
f.write("time,nodeid,temp\n")

while True:
    p = am.read()
    tmp=p.split()
    print tmp[1]
    f.write(time.strftime("%H%M%S")+","+tmp[0]+","+tmp[1]+"\n")
    f.flush()
f.close()
