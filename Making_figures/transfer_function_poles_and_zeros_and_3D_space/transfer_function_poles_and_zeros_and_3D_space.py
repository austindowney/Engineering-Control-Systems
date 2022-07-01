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
from mpl_toolkits.mplot3d import axes3d
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


#%% 3D plot


xx = np.arange(-3, 5, 0.08)
yy = np.arange(-10, 10, 0.08)
X, Y = np.meshgrid(xx, yy)

s = X + Y*1j
Z = np.abs(((s+2)*(s-3))/(s**2+4*s+20))
Z[Z>3.6]='NaN'

X_1, Y_1 = np.mgrid[-1:1:30j, -1:1:30j]
Z_1 = np.sin(np.pi*X_1)*np.sin(np.pi*Y_1)


fig = plt.figure()
ax = fig.add_subplot(111, projection="3d")
ax.set_zlim(-0.1, 2.1)
ax.set_xlabel('real s')
ax.set_ylabel('imaginary s')
ax.set_zlabel('$|(s+2)*(s-3)/(s^2+4s+20)|$',rotation=90)
ax.view_init(26, -33)
ax.plot_surface(X, Y, Z, cmap="viridis", lw=0.5, rstride=1, cstride=1,vmax = 2)
ax.contour(X, Y, Z, 50, linewidths=0.5, cmap="viridis", linestyles="solid", offset=-0.1,vmax = 2)

plt.savefig('a.pdf')


from sympy.abc import s
from sympy.physics.control.lti import TransferFunction
from sympy.physics.control.control_plots import pole_zero_plot

plt.figure()
tf1 = TransferFunction((s+2)*(s-3), s**2+4*s+20, s)
pole_zero_plot(tf1)   


plt.savefig('b.pdf')

