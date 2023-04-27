#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov 16 06:41:27 2022

@author: krbarnhart
"""
import glob
import os

import cmocean
import matplotlib as mpl
import matplotlib.pylab as plt
import numpy as np
import pandas as pd
from landlab import (HexModelGrid, RasterModelGrid, VoronoiDelaunayGrid,
                     imshow_grid)
from landlab.components import (ChannelProfiler, ChiFinder, FastscapeEroder,
                                FlowAccumulator)
from landlab.core.utils import argsort_points_by_x_then_y
from landlab.io import read_esri_ascii, write_esri_ascii
from matplotlib import cm
from matplotlib.lines import Line2D

mpl.rcParams["pdf.fonttype"] = 42

# %% set constants

K = 5e-6  # 1/yr
U1 = 1e-4  # m/yr
U2 = 5e-4  # m/yr

ss_thresh = 1e-8  # m
dx = 100  # m
nr = 200
nc = 200

total_time_transient = 50000000  # yr (for transient simulations)
transient_output_write = 100000
max_steady_total_time = 100000000  # 100 MA


total_time_transient = 50000000  # yr (for transient simulations)
transient_output_write = 100000
U1 = 1e-4  # m/yr
U2 = 5e-4  # m/yr

num_ts = int(total_time_transient / transient_output_write) + 1

output_timesteps = np.arange(0, num_ts) * transient_output_write


_TIME_COLORS = {
    "250": "#e6ab02",
    "2500": "#e7298a",
    "25000": "#7570b3",
    "100000": "#1b9e77",
}
#%% Figures 1 and 2

files = {
    "a. TTLEM: Explicit": dict(
        panel=0, filepath="ttlem_outputs/steady_state/exp_250_ss.txt"
    ),
    "b. TTLEM: Implicit": dict(
        panel=1, filepath="ttlem_outputs/steady_state/imp_250_ss.txt"
    ),
    "c. TTLEM: TVD_FVM": dict(
        panel=2, filepath="ttlem_outputs/steady_state/edge_250_ss.txt"
    ),
    "d. Landlab: Implicit": dict(
        panel=3, filepath="data/landlab_raster_dt250yr_steady.txt"
    ),
}


fig1, axes1 = plt.subplots(nrows=3, ncols=2, height_ratios=[1, 1, 0.3], figsize=(6, 6))
fig2, axes2 = plt.subplots(nrows=3, ncols=2, height_ratios=[1, 1, 0.3], figsize=(6, 6))

for key, value in files.items():
    file = value["filepath"]
    mg, z = read_esri_ascii(file, name="topographic__elevation")
    ax1 = axes1.flat[value["panel"]]
    ax2 = axes2.flat[value["panel"]]

    fa = FlowAccumulator(mg, flow_director="D8")
    fa.run_one_step()

    cp = ChannelProfiler(mg)
    cp.run_one_step()

    da = mg.at_node["drainage_area"]
    s = mg.at_node["topographic__steepest_slope"]

    theory_da = np.array([mg.area_of_cell.min(), da.max()])
    theory_slope = U1 / K * theory_da**-0.5

    ax2.loglog(theory_da, theory_slope, "#66a61e")

    ax2.loglog(da, s, "o", mfc="white", mec="k", ms=0.3, alpha=0.1)

    plt.sca(ax1)
    imshow_grid(mg, z, cmap="terrain", limits=(0, 170), allow_colorbar=False)
    ax1.set_title(key)
    ax1.set_xlabel("X (m)")
    ax1.set_ylabel("Y (m)")

    ax2.set_title(key)
    ax2.set_xlabel("Drainage Area (m$^2$)")
    ax2.set_ylabel("Slope (-)")
    for outlet_id, outlet_struct in cp.data_structure.items():
        for (top_id, bottom_id), segment_struct in outlet_struct.items():
            ids = segment_struct["ids"]
            ax1.plot(mg.x_of_node[ids], mg.y_of_node[ids], "k")

            ax2.loglog(da[ids], s[ids], ".", mec="k", mew=0.3, mfc="#d95f02")


cmap = plt.get_cmap("terrain")
norm = mpl.colors.Normalize(vmin=0.0, vmax=170)
sm = cm.ScalarMappable(norm=norm, cmap=cmap)

for ax1 in axes1.flat[-2:]:
    ax1.axis("off")

for ax2 in axes2.flat[-2:]:
    ax2.axis("off")

plt.colorbar(
    sm,
    ax=axes1.flat[-1],
    shrink=0.9,
    orientation="horizontal",
    anchor=(0.5, 0.9),
    label="Elevation [m]",
)


custom_lines1 = [Line2D([0], [0], color="k", lw=1)]
axes1.flat[-2].legend(custom_lines1, ["Longest channel"])

custom_lines2 = [
    Line2D([0], [0], color="#66a61e"),
    Line2D([0], [0], marker="o", color="w", mfc="white", mec="k", ms=0.3, alpha=1),
    Line2D([0], [0], marker=".", color="w", mec="k", mew=0.3, mfc="#d95f02"),
]
axes2.flat[-2].legend(
    custom_lines2, ["$S = (U/K) A^{-m}$", "Entire domain", "Longest channel"]
)


fig1.tight_layout()
fig1.savefig("Figure_1_steady.png", dpi=300)


fig2.tight_layout()
fig2.savefig("Figure_2_slopea_area.png", dpi=300)

#%% Figures s1

files = {
    "a. Topography, TTLEM: Explicit": dict(
        panel=0, filepath="ttlem_outputs/steady_state/exp_250_ss.txt"
    ),
    "b. Difference, TTLEM: Implicit": dict(
        panel=1, filepath="ttlem_outputs/steady_state/imp_250_ss.txt"
    ),
    "c. Difference, TTLEM: TVD_FVM": dict(
        panel=2, filepath="ttlem_outputs/steady_state/edge_250_ss.txt"
    ),
    "d. Difference, Landlab: Implicit": dict(
        panel=3, filepath="landlab/output/landlab_raster_dt250yr_steady.txt"
    ),
}

mg, z_base = read_esri_ascii("ttlem_outputs/steady_state/exp_250_ss.txt", name="topographic__elevation")

fig1, axes1 = plt.subplots(nrows=3, ncols=2, height_ratios=[1, 1, 0.3], figsize=(6, 6))

for key, value in files.items():
    file = value["filepath"]
    mg, z = read_esri_ascii(file, name="topographic__elevation")
    ax1 = axes1.flat[value["panel"]]
    ax2 = axes2.flat[value["panel"]]

    fa = FlowAccumulator(mg, flow_director="D8")
    fa.run_one_step()

    cp = ChannelProfiler(mg)
    cp.run_one_step()

    da = mg.at_node["drainage_area"]
    s = mg.at_node["topographic__steepest_slope"]

    theory_da = np.array([mg.area_of_cell.min(), da.max()])
    theory_slope = U1 / K * theory_da**-0.5

    plt.sca(ax1)
    
    dif =z - z_base
    print(dif.max(), dif.min())
    if value["panel"]==0:
        
        imshow_grid(mg, z, cmap="terrain", limits=(0, 170), allow_colorbar=True)
    else:
        imshow_grid(mg, z - z_base, cmap="PuOr_r", limits=(-115, 115), allow_colorbar=False)

    ax1.set_title(key)
    ax1.set_xlabel("X (m)")
    ax1.set_ylabel("Y (m)")

    for outlet_id, outlet_struct in cp.data_structure.items():
        for (top_id, bottom_id), segment_struct in outlet_struct.items():
            ids = segment_struct["ids"]
            ax1.plot(mg.x_of_node[ids], mg.y_of_node[ids], "k")


cmap = plt.get_cmap("PuOr_r")
norm = mpl.colors.Normalize(vmin=-115, vmax=115)
sm = cm.ScalarMappable(norm=norm, cmap=cmap)

for ax1 in axes1.flat[-2:]:
    ax1.axis("off")


plt.colorbar(
    sm,
    ax=axes1.flat[-1],
    shrink=0.9,
    orientation="horizontal",
    anchor=(0.5, 0.9),
    label="Difference [m]",
)
custom_lines1 = [Line2D([0], [0], color="k", lw=1)]
axes1.flat[-2].legend(custom_lines1, ["Longest channel"])


fig1.tight_layout()
fig1.savefig("Figure_s1_steady.png", dpi=300)


#%% Figure 3

files = {
    "a. CHILD: 250 yr": dict(
        panel=0,
        filepath="child/outputs/child_final_grids_for_figures/child_steadystate_dt250_40401nodes.points",
        color=_TIME_COLORS["250"],
        time="250 yr",
    ),
    "b. CHILD: 2.5 kyr": dict(
        panel=1,
        filepath="child/outputs/child_final_grids_for_figures/child_steadystate_dt2500_40401nodes.points",
        color=_TIME_COLORS["2500"],
        time="2.5 kyr",
    ),
    "c. CHILD: 25 kyr": dict(
        panel=2,
        filepath="child/outputs/child_final_grids_for_figures/child_steadystate_dt25000_40401nodes.points",
        color=_TIME_COLORS["25000"],
        time="25 kyr",
    ),
    "d. CHILD: 100 kyr": dict(
        panel=3,
        filepath="child/outputs/child_final_grids_for_figures/child_steadystate_dt100000_40401nodes.points",
        color=_TIME_COLORS["100000"],
        time="100 kyr",
    ),
}


fig3, axes3 = plt.subplots(nrows=3, ncols=2, height_ratios=[1, 1, 1], figsize=(6, 8))

sa_ax3 = axes3.flat[-2]
for key, value in files.items():
    file = value["filepath"]
    if "child" in file:

        arr = np.loadtxt(file)
        xvor = arr[:, 0]
        yvor = arr[:, 1]
        zvor = arr[:, 2]
        bcvor = arr[:, 3]

        yvor_rounded = np.round(yvor, decimals=6)
        sorted_nodes = argsort_points_by_x_then_y((xvor, yvor_rounded))
        xvor_sorted = xvor[sorted_nodes]
        yvor_sorted = yvor[sorted_nodes]
        bcvor_sorted = bcvor[sorted_nodes]
        zvor_sorted = zvor[sorted_nodes]

        mg = VoronoiDelaunayGrid(x=xvor_sorted, y=yvor_sorted)

        z = mg.add_zeros("node", "topographic__elevation")

        z += zvor_sorted
        is_core = bcvor_sorted == 0
        is_open_boundary = bcvor_sorted == 2

        mg.status_at_node[is_core] = mg.BC_NODE_IS_CORE
        mg.status_at_node[is_open_boundary] = mg.BC_NODE_IS_FIXED_VALUE

        z[is_open_boundary] = 0
        fd = "D4"
        df = "DepressionFinderAndRouter"
    else:
        mg, z = read_esri_ascii(file, name="topographic__elevation")
        fd = "D8"
        df = None

    ax3 = axes3.flat[value["panel"]]

    fa = FlowAccumulator(mg, flow_director=fd, depression_finder=df)
    fa.run_one_step()

    da = mg.at_node["drainage_area"]
    s = mg.at_node["topographic__steepest_slope"]

    if "child" in file:
        max_da = da[mg.status_at_node == mg.BC_NODE_IS_CORE].max()
        da_ind = np.where(da == max_da)[0][0]
        cp = ChannelProfiler(mg, outlet_nodes=[da_ind])
    else:
        cp = ChannelProfiler(mg)
    cp.run_one_step()

    plt.sca(ax3)
    imshow_grid(mg, z, cmap="terrain", limits=(0, 170), allow_colorbar=False)
    ax3.set_title(key)
    ax3.set_xlabel("X (m)")
    ax3.set_ylabel("Y (m)")

    for outlet_id, outlet_struct in cp.data_structure.items():
        for (top_id, bottom_id), segment_struct in outlet_struct.items():
            ids = segment_struct["ids"]
            ax3.plot(mg.x_of_node[ids], mg.y_of_node[ids], "k")
            (l,) = sa_ax3.loglog(
                da[ids],
                s[ids],
                '.',
                color=value["color"],
                label=value["time"],
                zorder=6,
                linewidth=0.5,
            )


cmap = plt.get_cmap("terrain")
norm = mpl.colors.Normalize(vmin=0.0, vmax=170)
sm = cm.ScalarMappable(norm=norm, cmap=cmap)

for ax3 in axes3.flat[-1:]:
    ax3.axis("off")

plt.colorbar(
    sm,
    ax=axes3.flat[-1],
    shrink=0.9,
    orientation="horizontal",
    anchor=(0.5, 0.9),
    label="Elevation [m]",
)


sa_ax3.set_xlabel("Drainage Area (m$^2$)")
sa_ax3.set_ylabel("Slope (-)")
sa_ax3.set_title("e. Slope-Area Plot")

custom_lines1 = [Line2D([0], [0], color="k", lw=1)]
axes3.flat[-1].legend(custom_lines1, ["Longest channel"], loc="center")

theory_da = np.array([mg.area_of_cell.min(), max_da])
theory_slope = U1 / K * theory_da**-0.5
sa_ax3.loglog(
    theory_da, theory_slope, "k", label=r"$S = (U/K) A^{-m/n}$", zorder=4, linewidth=1
)
sa_ax3.legend(bbox_to_anchor=(0, -0.3), loc='upper left', ncols=2)


fig3.tight_layout()
fig3.savefig("Figure_3A_steady_Child.png", dpi=300)

#%% Figure 3


files = {
    "a. Landlab: 250 yr": dict(
        panel=0,
        filepath="landlab/output/landlab_voronoi_dt250yr_steady.txt",
        color=_TIME_COLORS["250"],
        time="250 yr",
    ),
    "b. Landlab: 2.5 kyr": dict(
        panel=1,
        filepath="landlab/output/landlab_voronoi_dt2500yr_steady.txt",
        color=_TIME_COLORS["2500"],
        time="2.5 kyr",
    ),
    "c. Landlab: 25 kyr": dict(
        panel=2,
        filepath="landlab/output/landlab_voronoi_dt25000yr_steady.txt",
        color=_TIME_COLORS["25000"],
        time="25 kyr",
    ),
    "d. Landlab: 100 kyr": dict(
        panel=3,
        filepath="landlab/output/landlab_voronoi_dt100000yr_steady.txt",
        color=_TIME_COLORS["100000"],
        time="100 kyr",
    ),
}


fig3, axes3 = plt.subplots(nrows=3, ncols=2, height_ratios=[1, 1, 1], figsize=(6, 8))

sa_ax3 = axes3.flat[-2]
for key, value in files.items():
    file = value["filepath"]
    if "voronoi" in file:
        
        df = pd.read_csv(file)
        zinit = df.z.values
        yvor=df.y.values
        xvor=df.x.values
        bcvor=df.bc.values

        yvor_rounded = np.round(yvor, decimals=6)
        sorted_nodes = argsort_points_by_x_then_y((xvor, yvor_rounded))
        xvor_sorted = xvor[sorted_nodes]
        yvor_sorted = yvor[sorted_nodes]
        bcvor_sorted = bcvor[sorted_nodes]
        zvor_sorted = zvor[sorted_nodes]

        mg = VoronoiDelaunayGrid(x=xvor_sorted, y=yvor_sorted)

        z = mg.add_zeros("node", "topographic__elevation")

        z += zinit
        is_core = bcvor_sorted == 0
        is_open_boundary = bcvor_sorted == 1

        mg.status_at_node[is_core] = mg.BC_NODE_IS_CORE
        mg.status_at_node[is_open_boundary] = mg.BC_NODE_IS_FIXED_VALUE

        z[is_open_boundary] = 0
        fd = "D4"
        df = "DepressionFinderAndRouter"
    else:
        mg, z = read_esri_ascii(file, name="topographic__elevation")
        fd = "D8"
        df = None

    ax3 = axes3.flat[value["panel"]]

    fa = FlowAccumulator(mg, flow_director=fd, depression_finder=df)
    fa.run_one_step()

    da = mg.at_node["drainage_area"]
    s = mg.at_node["topographic__steepest_slope"]

    if "voronoi" in file:
        max_da = da[mg.status_at_node == mg.BC_NODE_IS_CORE].max()
        da_ind = np.where(da == max_da)[0][0]
        cp = ChannelProfiler(mg, outlet_nodes=[da_ind])
    else:
        cp = ChannelProfiler(mg)
    cp.run_one_step()

    plt.sca(ax3)
    imshow_grid(mg, z, cmap="terrain", limits=(0, 170), allow_colorbar=False)
    ax3.set_title(key)
    ax3.set_xlabel("X (m)")
    ax3.set_ylabel("Y (m)")

    for outlet_id, outlet_struct in cp.data_structure.items():
        for (top_id, bottom_id), segment_struct in outlet_struct.items():
            ids = segment_struct["ids"]
            ax3.plot(mg.x_of_node[ids], mg.y_of_node[ids], "k")
            (l,) = sa_ax3.loglog(
                da[ids],
                s[ids],
                '.',
                color=value["color"],
                label=value["time"],
                zorder=6,
                linewidth=0.5,
            )


cmap = plt.get_cmap("terrain")
norm = mpl.colors.Normalize(vmin=0.0, vmax=170)
sm = cm.ScalarMappable(norm=norm, cmap=cmap)

for ax3 in axes3.flat[-1:]:
    ax3.axis("off")

plt.colorbar(
    sm,
    ax=axes3.flat[-1],
    shrink=0.9,
    orientation="horizontal",
    anchor=(0.5, 0.9),
    label="Elevation [m]",
)


sa_ax3.set_xlabel("Drainage Area (m$^2$)")
sa_ax3.set_ylabel("Slope (-)")
sa_ax3.set_title("e. Slope-Area Plot")

custom_lines1 = [Line2D([0], [0], color="k", lw=1)]
axes3.flat[-1].legend(custom_lines1, ["Longest channel"], loc="center")

theory_da = np.array([mg.area_of_cell.min(), max_da])
theory_slope = U1 / K * theory_da**-0.5
sa_ax3.loglog(
    theory_da, theory_slope, "k", label=r"$S = (U/K) A^{-m/n}$", zorder=4, linewidth=1
)
sa_ax3.legend(bbox_to_anchor=(0, -0.3), loc='upper left', ncols=2)


fig3.tight_layout()
fig3.savefig("Figure_3A_steady_landlab.png", dpi=300)

#%%
ttlem_files = glob.glob("ttlem_outputs/steady_state/*.txt")

fig4, axes4 = plt.subplots(nrows=2, ncols=2, height_ratios=[1, 1], figsize=(6, 6))


names = dict(
    edge=dict(name="c. TTLEM: TVD_FVM", panel=2),
    imp=dict(name="b. TTLEM: Implicit", panel=1),
    exp=dict(name="a. TTLEM: Explicit", panel=0),
)

_TIME_COLORS = {
    "250": "#e6ab02",
    "2500": "#e7298a",
    "25000": "#7570b3",
    "100000": "#1b9e77",
}

for file in ttlem_files:
    basename = os.path.basename(file)
    alg, time, _ = basename.split("_")

    panel = names[alg]["panel"]
    title = names[alg]["name"]
    color = _TIME_COLORS[str(time)]

    ax4 = axes4.flat[panel]

    mg, z = read_esri_ascii(file, name="topographic__elevation")
    fa = FlowAccumulator(mg, flow_director="D8")
    fa.run_one_step()

    cp = ChannelProfiler(mg)
    cp.run_one_step()

    da = mg.at_node["drainage_area"]
    s = mg.at_node["topographic__steepest_slope"]

    theory_da = np.array([mg.area_of_cell.min(), da.max()])
    theory_slope = U1 / K * theory_da**-0.5

    ax4.loglog(theory_da, theory_slope, "k", zorder=4)

    ax4.set_title(title)
    ax4.set_xlabel("Drainage Area (m$^2$)")
    ax4.set_ylabel("Slope (-)")
    for outlet_id, outlet_struct in cp.data_structure.items():
        for (top_id, bottom_id), segment_struct in outlet_struct.items():
            ids = segment_struct["ids"]

            ax4.loglog(
                da[ids],
                s[ids],
                ".",
                color=color,
                label=value["time"],
                zorder=6,
                linewidth=0.5,
            )


for ax4 in axes4.flat[-1:]:
    ax4.axis("off")


custom_lines1 = [
    Line2D([0], [0], marker=".", color="white", mfc=_TIME_COLORS["250"], lw=1),
    Line2D([0], [0], marker=".", color="white", mfc=_TIME_COLORS["2500"], lw=1),
    Line2D([0], [0], marker=".", color="white", mfc=_TIME_COLORS["2500"], lw=1),
    Line2D([0], [0], marker=".", color="white", mfc=_TIME_COLORS["100000"], lw=1),
]
axes4.flat[-1].legend(custom_lines1, ["250 yr", "2.5 kyr", "25 kyr", "100 kyr"])


fig4.tight_layout()
fig4.savefig("Figure_3B_steady_TTLEM.png", dpi=300)

