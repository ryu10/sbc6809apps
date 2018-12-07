#!/usr/local/bin/python3
#!/usr/bin/python

# Trig3d.py
# 3D Trigonometry Demo from the 80's PC!

import math

def print_ch(a):
	print(chr(a), end="")

def tek_cls():
	c = [0x1b, 0x0c, 0x0d, 0x0a]
	for char in c:
		print_ch(char)

def tek_color(x):
	print_ch(0x1b)
	print_ch(0x5b)
	print_ch(0x33)
	print_ch(int(0x30+x))
	print_ch(0x6d)

def tek_dot(x,y):
	print_ch(0x1d)
	print_ch(0x20+(int(y)>>5 & 0x1f))
	print_ch(0x60+(int(y) & 0x1f))
	print_ch(0x20+(int(x)>>5 & 0x1f))
	print_ch(0x40+(int(x) & 0x1f))
	print_ch(0x20+(int(y)>>5 & 0x1f))
	print_ch(0x60+(int(y) & 0x1f))
	print_ch(0x20+(int(x)>>5 & 0x1f))
	print_ch(0x40+(int(x) & 0x1f))

def plot_xy():	 # sub 900
	x = v*3.5+30
	y = 600-w*3.5
	tek_dot(x,y)

tek_cls()
# tek_color(2)
d = [[-1 for y in range(256)] for x in range(2)]
for l in range(0,256):
	d[0][l] = -1
	d[1][l] = -1
# pi = 3.14
for y in range(-180,181,4):
	for x in range(-180,181,4):
		r = math.pi/180*math.sqrt(x*x+y*y)
		z = 100*math.cos(r)-30*math.cos(3*r)
		v = int(116+x/2+(16-y/2)/2)
		w = int((130-y/2-z)/2)
		if(not((v<0)or(v>255))): #120
			if(d[0][v]==-1): # 130->500
				if(v==0 or d[0][v-1]==-1 or d[1][v+1]==-1): # 500/510/520->600
					d[0][v] = w
					d[1][v] = w
					plot_xy()
				else: #530
					d[0][v] = int((d[0][v-1]+d[0][v+1])/2)
					d[1][v] = int((d[1][v-1]+d[1][v+1])/2)
					plot_xy()
			elif(w<=d[0][v]): #140->700
				plot_xy()
				d[0][v] = w
				if(d[1][v]==-1):
					d[1][v] = w
			elif(w>=d[1][v]): #150->800
				plot_xy()
				d[1][v] = w
				if(d[0][v]==-1):
					d[0][v] = w
