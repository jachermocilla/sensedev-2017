import serial
ser = serial.Serial('/dev/ttyUSB0', 115200)

while True:
    data = ser.readline()
    if data:
        print(data)
ser.close()
