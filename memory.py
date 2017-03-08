#!/usr/bin/python
import os
import time

def __getMemory():
  memlist = []
  for i in os.popen("free").read().split(" "):
    if i != "":
      memlist.append(i)
  memory =  100*float(memlist[7])/float(memlist[6])
  return memory

def __grabCPUdata():
  with open('/proc/stat', 'r') as file:
    firstline = file.readline()
  data = firstline.split(" ")
  data.remove("")
  return int(data[1]),int(data[2]),int(data[3]),int(data[4])


def __getCPU():
  a, b, c, previdle = __grabCPUdata()
  prevtotal = a+b+c+previdle
  time.sleep(0.5)
  a, b, c, idle = __grabCPUdata()
  total = a+b+c+idle
  total = int(total)
  prevtotal = int(prevtotal)
  idle = int(idle)
  cpu = (100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) )
  return cpu


memory = int(__getMemory())
cpu = int(__getCPU())

memcolor = ""
cpucolor = ""
if memory < 30:
  memcolor = "lightgreen"
elif memory < 70:
  memcolor = "yellow"
elif memory < 100:
  memcolor = "pink"

if cpu < 30:
  cpucolor = "lightgreen"
elif cpu < 70:
  cpucolor = "yellow"
elif cpu < 100:
  cpucolor = "pink"
print "<span foreground='lightblue'>RAM</span> <span foreground='"+memcolor+"'>"+str(memory)+"%</span> <span foreground='lightblue'>CPU</span> <span foreground='"+cpucolor+"'>"+str(cpu)+"%</span>"
