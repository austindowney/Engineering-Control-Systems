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





































