
import time
import busio
from board import SCL, SDA
from adafruit_pca9685 import PCA9685
import numpy as np

FREQ = 60
NEUTRAL = 1500
MAX = 1900
MIN = 1200

i2c = busio.I2C(SCL, SDA)
pca = PCA9685(i2c)
pca.frequency = FREQ

print("1")

pca.channels[15].duty_cycle = int(0xFFFF*0.09)
time.sleep(5)

print("2")

for i in range(0xFFFF):
    print("3")
    pca.channels[15].duty_cycle = int(0xFFFF*0.105)
    time.sleep(10)
