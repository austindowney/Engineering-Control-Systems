#!/usr/bin/env python3
# -*- coding: utf-8 -*-
   	
import IPython as IP
IP.get_ipython().run_line_magic('reset', '-sf')
#%% import modules and set default fonts and colors
   	
"""
Default plot formatting code for Austin Downey's series of open source notes/
books. This common header is used to set the fonts and format.

Header file last updated May 16, 2024
"""
  	
import numpy as np
import scipy as sp
import matplotlib.pyplot as plt
import matplotlib as mpl
   	
# set default fonts and plot colors
plt.rcParams.update({'text.usetex': True})
plt.rcParams.update({'image.cmap': 'viridis'})
plt.rcParams.update({'font.serif':['Times New Roman', 'Times', 'DejaVu Serif',
	'Bitstream Vera Serif', 'Computer Modern Roman', 'New Century Schoolbook',
	'Century Schoolbook L',  'Utopia', 'ITC Bookman', 'Bookman', 
	'Nimbus Roman No9 L', 'Palatino', 'Charter', 'serif']})
plt.rcParams.update({'font.family':'serif'})
plt.rcParams.update({'font.size': 10})
plt.rcParams.update({'mathtext.rm': 'serif'})
# I don't think I need this next line as its set to 'stixsans' above. 
plt.rcParams.update({'mathtext.fontset': 'custom'}) 
cc = plt.rcParams['axes.prop_cycle'].by_key()['color']
## End of plot formatting code

plt.close('all')


#%% plot the S space

t = np.linspace(-2,2,100)
x = np.zeros(t.shape[0])
for i in range(t.shape[0]):
    if t[i]>0:
        x[i] = t[i]
    

plt.figure(figsize=(3.5,2))
plt.plot(t,x)
plt.xlabel('t')
plt.ylabel('x(t)')
plt.xlim([-2,2])
plt.grid(True)
plt.tight_layout()


plt.savefig('ramp_function.jpg',dpi=300)






































