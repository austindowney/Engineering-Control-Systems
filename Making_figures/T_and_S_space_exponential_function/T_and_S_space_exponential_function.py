#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Nov 15 16:05:28 2019
@author: austin
"""

import IPython as IP
IP.get_ipython().magic('reset -sf')

import numpy as np
import matplotlib.pyplot as plt
import sklearn as sk
from sklearn import datasets
#from sklearn.linear_model import LinearRegression

# set default fonts and plot colors
plt.rcParams.update({'image.cmap': 'viridis'})
cc = plt.rcParams['axes.prop_cycle'].by_key()['color']
plt.rcParams.update({'font.serif':['Times New Roman', 'Times', 'DejaVu Serif',
 'Bitstream Vera Serif', 'Computer Modern Roman', 'New Century Schoolbook',
 'Century Schoolbook L',  'Utopia', 'ITC Bookman', 'Bookman', 
 'Nimbus Roman No9 L', 'Palatino', 'Charter', 'serif']})
plt.rcParams.update({'font.family':'serif'})
plt.rcParams.update({'font.size': 10})
plt.rcParams.update({'mathtext.rm': 'serif'})
plt.rcParams.update({'mathtext.fontset': 'custom'})
plt.close('all')

plt.close('all')


#%% plot the S space
p_0 = 5

t = np.linspace(0,1,100)

x = np.exp(p_0*t)

plt.figure(figsize=(6.5,2))
plt.subplot(121)
plt.plot(t,x)
plt.xlabel('t\n (a)')
plt.ylabel('x(t)')
plt.xlim([np.min(t),np.max(t)])
plt.grid(True)
plt.tight_layout()


s = np.linspace(-5,15,100)

F_s = 1/(s-p_0)


plt.subplot(122)
plt.plot(s,F_s)
plt.xlabel('s\n (b)')
plt.ylabel('F(s)')
plt.xlim([np.min(s),np.max(s)])
plt.grid(True)
plt.tight_layout()
plt.savefig('T_and_S_space_exponential_function',dpi=300)






































