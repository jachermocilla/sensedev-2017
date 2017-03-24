#!/usr/bin/env python

from datetime import datetime

import sys
import tos

if '-h' in sys.argv:
    print "Usage:", sys.argv[0], "serial@/dev/ttyUSB0:115200"
    print "      ", sys.argv[0], "network@host:port"
    sys.exit()

am = tos.AM()

f = open("sensor.dat","w")

while True:
    p = am.read()
    if p:
        print p
	f.write(p)

f.close()
