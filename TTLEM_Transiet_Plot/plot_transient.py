#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar 23 13:31:50 2023

@author: aforte
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt


theta=0.5
n=1
K=5e-6
ui=1e-4
uf=5e-4

ksni=(ui/K)**(1/n)
ksnf=(uf/K)**(1/n)

A=np.logspace(5,8,100)
C=np.linspace(0,6.5,100)
t=200000


edge_prefix=['EDGE250t','EDGE2500t','EDGE25000t','EDGE100000t']
exp_prefix=['EXP250t','EXP2500t','EXP25000t','EXP100000t']
fs_prefix=['FS250t','FS2500t','FS25000t','FS100000t']

f1=plt.figure(figsize=(8,9),dpi=250)


ax1=f1.add_subplot(3,3,1)
ax1.set_xlabel('Distance (km)')
ax1.set_ylabel('Elevation (m)')
ax1.set_title('Implicit')
ax1.invert_xaxis()

ax2=f1.add_subplot(3,3,2)
ax2.set_xlabel('Distance (km)')
# ax2.set_ylabel('Elevation (m)')
ax2.set_title('TVD_FVM')
ax2.invert_xaxis() 

ax3=f1.add_subplot(3,3,3)
ax3.set_xlabel('Distance (km)')
# ax3.set_ylabel('Elevation (m)')  
ax3.set_title('Explicit')
ax3.invert_xaxis()

ax4=f1.add_subplot(3,3,4)
ax4.set_xlabel(r'$\chi$ (m)')
ax4.set_ylabel('Elevation (m)') 
ax4.invert_xaxis()
ax4.plot(C,ksnf*C,c='k',linewidth=1,linestyle=':',zorder=0)
ax4.plot(C,ksni*C + (uf-ui)*t,c='k',linewidth=1,zorder=0)
ax4.set_ylim((0,225))

ax5=f1.add_subplot(3,3,5)
ax5.set_xlabel(r'$\chi$ (m)')
# ax5.set_ylabel('Elevation (m)') 
ax5.invert_xaxis()
ax5.plot(C,ksnf*C,c='k',linewidth=1,linestyle=':',zorder=0)
ax5.plot(C,ksni*C + (uf-ui)*t,c='k',linewidth=1,zorder=0)
ax5.set_ylim((0,225))

ax6=f1.add_subplot(3,3,6)
ax6.set_xlabel(r'$\chi$ (m)')
# ax6.set_ylabel('Elevation (m)')
ax6.invert_xaxis()
ax6.plot(C,ksnf*C,c='k',linewidth=1,linestyle=':',zorder=0)
ax6.plot(C,ksni*C + (uf-ui)*t,c='k',linewidth=1,zorder=0)
ax6.set_ylim((0,225))

ax7=f1.add_subplot(3,3,7)
ax7.set_xlabel(r'Area (m$^{2}$)')
ax7.set_ylabel('Slope (-)') 
ax7.set_xscale('log')
ax7.set_yscale('log')  
ax7.set_ylim((10**-3,1)) 
ax7.plot(A,ksni*A**(-theta),c='k',linewidth=1,zorder=0)
ax7.plot(A,ksnf*A**(-theta),c='k',linestyle=':',linewidth=1,zorder=0) 

ax8=f1.add_subplot(3,3,8)
ax8.set_xlabel(r'Area (m$^{2}$)')
# ax8.set_ylabel('Slope (-)') 
ax8.set_xscale('log')
ax8.set_yscale('log')  
ax8.set_ylim((10**-3,1))
ax8.plot(A,ksni*A**(-theta),c='k',linewidth=1,zorder=0)
ax8.plot(A,ksnf*A**(-theta),c='k',linestyle=':',linewidth=1,zorder=0)

ax9=f1.add_subplot(3,3,9)
ax9.set_xlabel(r'Area (m$^{2}$)')
# ax9.set_ylabel('Slope (-)') 
ax9.set_xscale('log')
ax9.set_yscale('log')
ax9.set_ylim((10**-3,1))
ax9.plot(A,ksni*A**(-theta),c='k',linewidth=1,zorder=0)
ax9.plot(A,ksnf*A**(-theta),c='k',linestyle=':',linewidth=1,zorder=0)

# Set colors
col=['#e6ab02','#e7298a','#7570b3','#1b9e77']
leg=['250 yr','2.5 kyr','25 kyr','100 kyr']


for i in range(4):
    fs_dec_df=pd.read_csv('transient_streams/'+fs_prefix[i]+'_dec.csv')
    fs_sa_df=pd.read_csv('transient_streams/'+fs_prefix[i]+'_sa.csv')
    edge_dec_df=pd.read_csv('transient_streams/'+edge_prefix[i]+'_dec.csv')
    edge_sa_df=pd.read_csv('transient_streams/'+edge_prefix[i]+'_sa.csv')         
    exp_dec_df=pd.read_csv('transient_streams/'+exp_prefix[i]+'_dec.csv')
    exp_sa_df=pd.read_csv('transient_streams/'+exp_prefix[i]+'_sa.csv')  
 
    ax1.plot(fs_dec_df['dist']/1000,fs_dec_df['elev'],c=col[i],linewidth=1,label=leg[i])
    ax2.plot(edge_dec_df['dist']/1000,edge_dec_df['elev'],c=col[i],linewidth=1)
    ax3.plot(exp_dec_df['dist']/1000,exp_dec_df['elev'],c=col[i],linewidth=1)
    
    ax4.plot(fs_dec_df['chi'],fs_dec_df['elev'],c=col[i],linewidth=1,zorder=1)
    ax5.plot(edge_dec_df['chi'],edge_dec_df['elev'],c=col[i],linewidth=1,zorder=1)
    ax6.plot(exp_dec_df['chi'],exp_dec_df['elev'],c=col[i],linewidth=1,zorder=1)

    ax7.scatter(fs_sa_df['ar'],fs_sa_df['gr'],c=col[i],s=5,zorder=1)
    ax8.scatter(edge_sa_df['ar'],edge_sa_df['gr'],c=col[i],s=5,zorder=1) 
    ax9.scatter(exp_sa_df['ar'],exp_sa_df['gr'],c=col[i],s=5,zorder=1) 

    
ax1.legend(loc='best')
plt.tight_layout()
f1.savefig('ttlem_transient_figure.png',dpi="figure")









          