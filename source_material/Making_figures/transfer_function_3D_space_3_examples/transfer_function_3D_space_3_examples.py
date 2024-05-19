# -*- coding: utf-8 -*-
"""
Basic plotting code for Open Controls and Open Vibrations. 

Austin Downey
"""

#%% import modules
try:
    from IPython import get_ipython
    get_ipython().magic('clear')
    get_ipython().magic('reset -f')
except:
    pass

import matplotlib.pyplot as plt
import matplotlib as mpl
from mpl_toolkits.mplot3d import Axes3D
import os as os
import numpy as np
import scipy as sp
from scipy.interpolate import griddata
from matplotlib import cm
import time
import subprocess
import pickle
import scipy.io as sio
import sympy as sym
from matplotlib import cm
import re as re
from scipy import signal
from scipy import fft
import json as json
from mpl_toolkits import mplot3d
import mpl_toolkits.mplot3d as mp3d


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
plt.rcParams.update({'mathtext.fontset': 'custom'}) # I don't think I need this as its set to 'stixsans' above.

cc = plt.rcParams['axes.prop_cycle'].by_key()['color']


plt.close('all')







#%% Plot the poles and zeros for s-1

X = np.arange(0.5, 1.5, 0.01)
Y = np.arange(-0.5, 0.5, 0.01)
X, Y = np.meshgrid(X, Y)

s = X + Y*1j
Z = np.abs(s-1)

fig, ax = plt.subplots(subplot_kw={"projection": "3d"})

# Plot the surface.
surf = ax.plot_surface(X, Y, Z, cmap=cm.viridis,linewidth=0, antialiased=False)#,vmax = 10)

# Customize the z axis.
#ax.set_zlim(-0.5, 10)
ax.set_xlabel('real s')
ax.set_ylabel('imaginary s')
ax.set_zlabel('$|1/(s-1)|$',rotation=90)
ax.view_init(22, 60)
plt.savefig('a.pdf')



#%% Plot the poles and zeros for 1/(s-1)

X = np.arange(0.5, 1.5, 0.01)
Y = np.arange(-0.5, 0.5, 0.01)
X, Y = np.meshgrid(X, Y)

s = X + Y*1j
Z = np.abs(1/(s-1))

fig, ax = plt.subplots(subplot_kw={"projection": "3d"})

# Plot the surface.
surf = ax.plot_surface(X, Y, Z, cmap=cm.viridis,linewidth=0, antialiased=False,vmax = 10)

# Customize the z axis.
ax.set_zlim(-0.5, 10)
ax.set_xlabel('real s')
ax.set_ylabel('imaginary s')
ax.set_zlabel('$1/(s-1)$',rotation=90)
ax.view_init(38, 60)
plt.savefig('b.pdf')



#%% Plot the poles and zeros for (-20s+20)/(s+2)

X = np.arange(-10.5, 10.5, 0.01)
Y = np.arange(-10.5, 10.5, 0.01)
X, Y = np.meshgrid(X, Y)

s = X + Y*1j
Z = np.abs((-20*s+20)/(s+2))

fig, ax = plt.subplots(subplot_kw={"projection": "3d"})

# Plot the surface.
surf = ax.plot_surface(X, Y, Z, cmap=cm.viridis,linewidth=0, antialiased=False,vmax = 60)#,vmax = 10)

# Customize the z axis.
ax.set_zlim(-0.5, 80)
ax.set_xlabel('real s')
ax.set_ylabel('imaginary s')
ax.set_zlabel('$|(-20s+20)/(s+2)|$',rotation=90)
ax.view_init(7, 66)
plt.savefig('c.pdf')














