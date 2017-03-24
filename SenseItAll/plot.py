import matplotlib.pyplot as plt

f=open("sensor.dat","r");

xdata=[]
ydata=[]

f.readline()
for line in f:
	#print line
	splt=line.split(",")
	xdata.append(splt[0])
	ydata.append(splt[2])
f.close()



plt.plot(xdata,ydata,"ro")
plt.axis([22000,23000,0,100])
plt.show()
