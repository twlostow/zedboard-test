#!/usr/bin/python

from devmem import DevMem
import time

mem = DevMem(base_addr=0x40000000, length=0x10000,debug=0)

class GPIO:
    COR=0
    SOR=4
    DDR=8
    PSR=0xc

    def __init__(self, mem, addr):
	self.mem = mem
	self.addr = addr

    def direction(self, pin, is_out):
	ddr = self.mem.readl(self.addr + self.DDR)
	if(not is_out):
	    ddr |= (1<<pin);
	else:
	    ddr &= ~(1<<pin)
#	print("ddr %x" % ddr)
	self.mem.writel(ddr, self.addr + self.DDR)

    def set(self,pin,value):
	if(value):
	    self.mem.writel((1<<pin), self.addr + self.SOR)
	else:
	    self.mem.writel((1<<pin), self.addr + self.COR)

    def get(self,pin):
	return True if self.mem.readl(self.addr + self.PSR) & (1<<pin) else False


class BitBangedSPI:
    def __init__(self, gpio, cs_pin, sck_pin, data_pin):
	self.gpio=gpio
	self.cs_pin = cs_pin
	self.sck_pin=sck_pin
	self.data_pin=data_pin
	self.cs(1)
	self.sck(0)

    def cs(self, value):
	self.gpio.set(self.cs_pin,value)

    def sck(self, value):
	self.gpio.set(self.sck_pin,value)

    def set_sdata(self, value):
	self.gpio.direction(self.data_pin,1)
	self.gpio.set(self.data_pin,value)

    def get_sdata(self):
	self.gpio.direction(self.data_pin,0)
	time.sleep(0.001)
	return self.gpio.get(self.data_pin)

    def txrx(self, data, n_bits):
	self.sck(0)
	self.cs(0)
	rx_v = 0
	for i in range(0,n_bits):
	    rx_v <<= 1	
	    rx_v |= 1 if self.get_sdata() else 0

	    self.set_sdata(data & (1<<(n_bits-1-i)))


	    self.sck(1)
	    self.sck(0)

	self.cs(1)
	return rx_v


class Trigger:
    ADDR_TG_CSR                    =0x0
    TG_CSR_ENABLE =0x00000001
    TG_CSR_POLARITY =0x00000002
    TG_CSR_MASK_OFFSET =2
    TG_CSR_ARM =0x00000040
    TG_CSR_FORCE =0x00000080
    TG_CSR_TRIGGERED =0x00000100
    ADDR_TG_THR_LO                 =0x4
    ADDR_TG_THR_HI                 =0x8


    def __init__(self, mem, addr):
	self.mem = mem
	self.addr = addr
	self.cr = 0

    def configure(self, edge, threshold, hysteresis, mask):
	self.cr =  self.TG_CSR_ENABLE | (mask << self.TG_CSR_MASK_OFFSET)
	self.mem.writel(self.cr, self.addr + self.ADDR_TG_CSR)
    
#      acc.write(base_trig0 + `ADDR_TG_THR_LO, 2000);
#      acc.write(base_trig0 + `ADDR_TG_THR_HI, 2200);
#      acc.write(base_trig0 + `ADDR_TG_CSR, ( 1 <<`TG_CSR_MASK_OFFSET ) | `TG_CSR_ENABLE);
#      acc.write(base_trig0 + `ADDR_TG_CSR, ( 1 <<`TG_CSR_MASK_OFFSET ) | `TG_CSR_ENABLE | `TG_CSR_ARM);

	pass

    def force(self):
	self.mem.writel(self.cr | self.TG_CSR_FORCE, self.addr + self.ADDR_TG_CSR)
    

    def triggered(self):
	sr = self.mem.readl(self.addr + self.ADDR_TG_CSR)
	print("sr %x" % sr)
	return True if sr & self.TG_CSR_TRIGGERED else False

    def arm(self):
	pass

def sign_extend(value, bits):
    sign_bit = 1 << (bits - 1)
    return (value & (sign_bit - 1)) - (value & sign_bit)

class Buffer:
    ADDR_ACQ_CSR                   = 0x0
    ACQ_CSR_START = 0x00000001
    ACQ_CSR_READY = 0x00000002
    ADDR_ACQ_SIZE         	= 0x4
    ADDR_ACQ_PRETRIGGER          = 0x8
    ADDR_ACQ_TRIG_POS              = 0xc
    ADDR_ACQ_ADDR                  = 0x10
    ADDR_ACQ_DATA                  = 0x14

    def __init__(self, mem, addr):
	self.mem = mem
	self.addr = addr
	self.size = self.mem.readl(self.addr + self.ADDR_ACQ_SIZE);
	self.pretrigger=0
	print("Buffer has %d samples" % self.size)

    def set_pretrigger(self, pretrigger):
	self.pretrigger = pretrigger

    def start(self):
	self.mem.writel(self.pretrigger, self.addr + self.ADDR_ACQ_PRETRIGGER)
	self.mem.writel(self.ACQ_CSR_START, self.addr + self.ADDR_ACQ_CSR)

    def ready(self):
	return True if self.mem.readl(self.addr + self.ADDR_ACQ_CSR) & self.ACQ_CSR_READY else False


    def read(self):
        trig_pos = self.mem.readl(self.addr + self.ADDR_ACQ_TRIG_POS);

	print("trigger pos : %d" % trig_pos)

	samples=[]
	for i in range(0,self.size):
	    addr = i - self.pretrigger + trig_pos;
    
    	    self.mem.writel(addr, self.addr + self.ADDR_ACQ_ADDR);
	    d = self.mem.readl(self.addr + self.ADDR_ACQ_DATA)
	    if i < 10:
		print("%x"%d)  

	    samples.append((i-self.pretrigger, sign_extend(d,16)))
	return samples

class AD9253:
    def __init__(self, spi):
	self.spi = spi

    def write_reg(self, reg, value):
	value = 0x000000 | (reg << 8) | (value & 0xff)
#	print("V %x" % value)
	return spi.txrx(value, 24)

    def read_reg(self, reg):
	value = 0x800000 | (reg << 8) 
#	print("Vr %x" % value)
	return spi.txrx(value, 24) 

#init the ADC (SDR mode)
gpio0=GPIO(mem,0)
spi=BitBangedSPI(gpio0, 5,6,7) # assign GPIO pins to the SPI interface (check adc_core.vhd)
adc=AD9253(spi)

adc.write_reg(0x00, 0x18) # set SPI config

print("ID:  %x" % adc.read_reg(0x1))

PIN_RESET_SERDES=10
PIN_RESET_CLOCK=11
PIN_RESET_CORE=12
PIN_LED0=0
PIN_LED1=4

adc.write_reg(0x8, 0x3) # reset the ADC
adc.write_reg(0x8, 0x0) # un-reset

adc.write_reg(0x21, 0x30) # set byte/DDR mode
adc.write_reg(0x19, 0x00) # set test bit pattern
adc.write_reg(0x1a, 0x00)
adc.write_reg(0x1b, 0xff)
adc.write_reg(0x1c, 0xff)
adc.write_reg(0x0d, 0x00) # disable test bit pattern
#adc.write_reg(0x0d, 0x48) # enable test bit pattern (alternate mode)

adc.write_reg(0x14, 0x1) # don't invert output
adc.write_reg(0x15, 0x00) # no additional output temrination
adc.write_reg(0x16, 0x02) # output clock phase adjust


#turn on the LEDs
gpio0.set(PIN_LED0, 1)
gpio0.set(PIN_LED1, 1)

#first, reset the serdes's clock distribution

gpio0.set(PIN_RESET_CLOCK, 0)
gpio0.set(PIN_RESET_CLOCK, 1)


#then, once the clock is ready, reset the serdes
gpio0.set(PIN_RESET_SERDES, 0)
gpio0.set(PIN_RESET_SERDES, 1)

# now, reset the ADC core (the part clocked by the ADC clock)
gpio0.set(PIN_RESET_CORE, 1)
gpio0.set(PIN_RESET_CORE, 0)


time.sleep(1)

# create Trigger unit & buffer unit instances (channel 0)
buf0 = Buffer(mem, 0x2000)
trig0 = Trigger(mem, 0x1000)

# prepare buffer for acquisition
buf0.start()

# configure the trigger
trig0.configure(0,0,0,0xf)
# manually force trigger
trig0.force()

while not trig0.triggered():
    time.sleep(0.01)

while not buf0.ready():
    time.sleep(0.01)

print("Got it!")

data = buf0.read()

time.sleep(1)
import matplotlib.pyplot as plt
import numpy as np

print(zip(*data))

plt.plot(*zip(*data))
plt.ylabel('ADC Data')
plt.show()

