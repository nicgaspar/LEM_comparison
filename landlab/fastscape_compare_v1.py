#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jan 19 07:45:24 2019

@author: barnhark
"""


# run with landlab v2.4.2.dev0

# import modules
import os

import matplotlib as mpl
import matplotlib.pylab as plt
import numpy as np
import pandas as pd
from landlab import HexModelGrid, RasterModelGrid, VoronoiDelaunayGrid, imshow_grid
from landlab.components import (
    ChannelProfiler,
    ChiFinder,
    FastscapeEroder,
    FlowAccumulator,
)
from landlab.core.utils import argsort_points_by_x_then_y
from landlab.io import read_esri_ascii, write_esri_ascii

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

# %%
# define a function to help save output
def make_output_for_saving(grid, z):
    ch = ChiFinder(grid, min_drainage_area=1.0)
    ch.calculate_chi()

    cp = ChannelProfiler(grid)
    cp.run_one_step()

    temp = {
        "z": z.copy(),
        "a": grid.at_node["drainage_area"].copy(),
        "s": grid.at_node["topographic__steepest_slope"].copy(),
        "x": grid.at_node["channel__chi_index"].copy(),
        "channel_nodes": cp.profile_structure.copy(),
        "distance_upstream": cp.distances_upstream.copy(),
    }
    return temp


#%% read in noise files

# raster from Adam
noise_file_path_raster = "../data/NoiseGrid.txt"
noise_raster_grid, raster_noise = read_esri_ascii(noise_file_path_raster)


# voronoi noise from Nicole/Child
noise_file_path_voronoi = "../data/initial_noise_grid_40401nodes.points"

arr = np.loadtxt(noise_file_path_voronoi)
xvor = arr[:, 0]
yvor = arr[:, 1]
zvor_noise = arr[:, 2]
bcvor = arr[:, 3]

# need to sort so that landlab doesn't rearrange.
yvor_rounded = np.round(yvor, decimals=6)
sorted_nodes = argsort_points_by_x_then_y((xvor, yvor_rounded))
xvor = xvor[sorted_nodes]
yvor = yvor[sorted_nodes]
bcvor = bcvor[sorted_nodes]
zvor_noise = zvor_noise[sorted_nodes]


# # voronoi steady from Nicole/Child
steady_file_path_voronoi = "../data/steady_state_grid_40401nodes.points"

arr2 = np.loadtxt(steady_file_path_voronoi)
xvor2 = arr2[:,0]
yvor2 = arr2[:,1]
zvor_steady = arr2[:,2]
bcvor2 = arr2[:,3]

yvor2_rounded = np.round(yvor2, decimals=6)
sorted_nodes2 = argsort_points_by_x_then_y((xvor2, yvor2_rounded))
xvor2 = xvor2[sorted_nodes2]
yvor2 = yvor2[sorted_nodes2]
bcvor2 = bcvor2[sorted_nodes2]
zvor_steady = zvor_steady[sorted_nodes2]

# double check that the voronoi grids are equivalent. (this will fail if they are not)
np.testing.assert_array_equal(xvor, xvor2)
np.testing.assert_array_equal(yvor, yvor2)
np.testing.assert_array_equal(bcvor, bcvor2)
np.testing.assert_array_equal(sorted_nodes, sorted_nodes2)

#%%

_GRIDS = {
    "raster": [RasterModelGrid, {"shape": (nr, nc), "xy_spacing": dx}],
    "hex": [HexModelGrid, {"shape": (nr, nc), "spacing": dx, "node_layout": "rect"},],
    "voronoi": [VoronoiDelaunayGrid, {"x": xvor, "y": yvor}],
}

if not os.path.exists('output'):
    os.mkdir('output')
dts = [250, 2500, 25000, 100000]

zmaxes = []
zdiff_maxes = []

run_steady = True
run_transients = True
for grid_name in ["voronoi", "raster", "hex"]:

    for dt in dts:

        # PART 1: CREATE STEADY GRIDS, IF DT == 250
        if run_steady:
            if True:#dt == 250:

                maxdiff = []
                maxdiff_relief = []
                maxdiff_perc = []

                time = []

                output_file = "output/landlab_{}_dt{}yr_steady.txt".format(grid_name, dt)

                if not os.path.exists(output_file):
                    print("steady", grid_name, dt)
                    GridConstructor = _GRIDS[grid_name][0]
                    grid_kwargs = _GRIDS[grid_name][1]

                    # Initial run to steady state
                    # create grid and add noise to core nodes.
                    grid = GridConstructor(**grid_kwargs)

                    z = grid.add_zeros("node", "topographic__elevation")

                    if grid_name == "raster":
                        # use noise grid from Adam's data file.
                        plotting_nodes = grid.core_nodes

                        # use noise from data file for rasters.
                        z += raster_noise

                    if grid_name == "hex":
                        # select core nodes not adjacent to boundaries for slope-area plotting
                        plotting_nodes = grid.core_nodes

                        # for hex, use randomly generated noise
                        np.random.seed(
                            42
                        )  # this is the only random noise I'm generating.
                        z[grid.core_nodes] += np.random.rand(grid.core_nodes.size)

                    if grid_name == "voronoi":
                        z += zvor_noise
                        is_core = bcvor == 0
                        is_open_boundary = bcvor == 2

                        grid.status_at_node[is_core] = grid.BC_NODE_IS_CORE
                        grid.status_at_node[
                            is_open_boundary
                        ] = grid.BC_NODE_IS_FIXED_VALUE

                        z[is_open_boundary] = 0

                        plotting_nodes = grid.core_nodes

                    #imshow_grid(
                    #    grid,
                    #    z,
                    #    cmap="terrain",
                    #    show_elements=True,
                    #    color_for_closed="red",
                    #)
                    # imshow_grid(grid, grid.status_at_node, cmap='terrain', show_elements=True, color_for_closed='red')

                    # create flow accumulator and fastscape eroder
                    if grid_name == "raster":
                        fa = FlowAccumulator(grid, flow_director="D8")
                    else:
                        fa = FlowAccumulator(grid)
                    fs = FastscapeEroder(grid, K_sp=K)

                    num_ts = 0
                    while dt * num_ts < max_steady_total_time:

                        # copy z
                        z_old = z.copy()

                        # uplift
                        z[grid.core_nodes] += U1 * dt

                        # route
                        fa.run_one_step()

                        # erode
                        fs.run_one_step(dt)

                        # increment number of ts
                        num_ts += 1

                        # assess steady state
                        zdiff = np.abs(z[grid.core_nodes] - z_old[grid.core_nodes])
                        percent_change = zdiff / z[grid.core_nodes]

                        if np.all(percent_change < ss_thresh):
                            not_at_ss = False

                        if dt * num_ts >= max_steady_total_time:
                            not_at_ss = True
                            print("ending steady at time=100MA")

                        if num_ts % 100 == 0:
                            print(num_ts, np.max(percent_change), dt * num_ts/max_steady_total_time)

                        # record state
                        maxdiff_perc.append(np.max(percent_change))
                        maxdiff.append(np.max(zdiff))
                        maxdiff_relief.append(
                            np.abs(
                                np.max(z[grid.core_nodes])
                                - np.max(z_old[grid.core_nodes])
                            )
                        )
                        time.append(dt * num_ts)

                    df = pd.DataFrame(
                        {
                            "time": time,
                            "maxdiff": maxdiff,
                            "maxdiff_perc": maxdiff_perc,
                            "maxdiff_relief": maxdiff_relief,
                        }
                    )
                    df.to_csv("landlab_{}_dt{}yr_steady_evolution.csv".format(grid_name, dt))

                    plt.figure(dpi=300)
                    plt.semilogy(
                        df.time / 1e6,
                        maxdiff_perc,
                        label="Maximum percentage local topography change [-]",
                    )
                    plt.semilogy(
                        df.time / 1e6, maxdiff_relief, label="Maximum relief change [m]"
                    )
                    plt.semilogy(
                        df.time / 1e6,
                        maxdiff,
                        label="Maximum local topography change [m]",
                    )
                    plt.xlabel("Time, 1e6 yr")
                    plt.ylabel("Metric")
                    plt.legend()
                    plt.savefig("landlab_{}_dt{}yr_steady_evolution.pdf".format(grid_name, dt))

                    # save z
                    if grid_name == "raster":
                        write_esri_ascii(
                            output_file,
                            grid,
                            names=["topographic__elevation"],
                            clobber=True,
                        )
                    else:
                        df = pd.DataFrame(
                            {
                                "x": grid.x_of_node,
                                "y": grid.y_of_node,
                                "z": z,
                                "bc": grid.status_at_node,
                            }
                        )
                        df.to_csv(output_file)
                    plt.close("all")
                    # create a datastructure to save info.
                    # save = {}
                    # re-route in order to re-update slope-area calculations
                    # fa.run_one_step()

                    # save["set_up"] = make_output_for_saving(grid, z)

                    del grid, z

        if run_transients:
            # Part 2: transient runs.

            GridConstructor = _GRIDS[grid_name][0]
            grid_kwargs = _GRIDS[grid_name][1]

            # set up grid
            grid = GridConstructor(**grid_kwargs)
            z = grid.add_zeros("node", "topographic__elevation")

            if grid_name == "voronoi":
                steady_output_file = "../data/steady_state_grid_40401nodes.points"
               
            else:
                steady_output_file = "output/landlab_{}_dt{}yr_steady.txt".format(grid_name, 250)
        
        
            # initialize topography with end of steady runs.
            if grid_name == "raster":
                zinit_raster_grid, zinit = read_esri_ascii(steady_output_file)
            elif grid_name == "hex":
                df = pd.read_csv(steady_output_file)
                zinit = df.z.values

            else:# grid_name == "voronoi":
                
                zinit = zvor_steady
                is_core = bcvor == 0
                is_open_boundary = bcvor == 2

                grid.status_at_node[is_core] = grid.BC_NODE_IS_CORE
                grid.status_at_node[
                    is_open_boundary
                ] = grid.BC_NODE_IS_FIXED_VALUE

                z[is_open_boundary] = 0

                plotting_nodes = grid.core_nodes

            z[:] += zinit

            # save topography figure
            plt.figure(dpi=300)
            imshow_grid(
                grid,
                z,
                cmap="terrain",
                limits=(0, 300),
                colorbar_label="Elevation, [m]",
                plot_name=(
                    "Topography after "
                    + str(int(max_steady_total_time/250))
                    + " "
                    + str(int(250))
                    + " year time steps"
                ),
                output="landlab_{}_dt{}yr_steady_end_of_run.png".format(grid_name, 250),
            )

            # create flow accumulator and fastscape eroder
            fa = FlowAccumulator(grid)
            fs = FastscapeEroder(grid, K_sp=K)

            # determine number of timesteps
            num_ts = int(total_time_transient / dt)

            for i in range(num_ts + 1):

                # uplift
                z[grid.core_nodes] += U2 * dt

                # route
                fa.run_one_step()

                # erode
                fs.run_one_step(dt)

                current_time = dt * i

                if current_time % transient_output_write == 0:
                    print(grid_name, dt, "transient", current_time)
                    
                    out_folder = "landlab_{}_dt{}yr_transient".format(grid_name, dt)
                    if not os.path.exists(out_folder):
                        os.mkdir(out_folder)
                        
                    out_file =  "landlab_{}_dt{}yr_transient/topo_transient_{}_{}_dt_at_{}yr.png".format(grid_name, dt, grid_name, dt, int(current_time))
                    # make two plots
                    plt.figure(dpi=300)
                    imshow_grid(
                        grid,
                        z,
                        limits=(0, 1000),
                        cmap="terrain",
                        colorbar_label="Elevation, [m]",
                        plot_name="Topography after "
                        + str(i)
                        + " "
                        + str(dt)
                        + " year time steps, " + str(int(current_time)) + "yr",
                        output=out_file
                    )
                    out_file =  "landlab_{}_dt{}yr_transient/diff_transient_{}_{}_dt_at_{}yr.png".format(grid_name, dt, grid_name, dt, int(current_time))

                    plt.figure(dpi=300)
                    imshow_grid(
                        grid,
                        z - zinit,
                        limits=(0, 1000),
                        cmap="viridis",
                        colorbar_label="Difference, [m]",
                        plot_name="Difference from Initial after "
                        + str(i)
                        + " "
                        + str(dt)
                        + " year time steps, " + str(int(current_time)) + "yr",
                        output=out_file)
                    plt.close("all")


                    out_folder = "output/landlab_{}_dt{}yr_transient".format(grid_name, dt)
                    if not os.path.exists(out_folder):
                        os.mkdir(out_folder)


                    output_file = "output/landlab_{}_dt{}yr_transient/landlab_{}_dt{}yr_transient_at_{}yr.txt".format(grid_name, dt, grid_name, dt, int(current_time))

                    if grid_name == "raster":
                        write_esri_ascii(
                            output_file,
                            grid,
                            names=["topographic__elevation"],
                            clobber=True,
                        )
                    else:
                        df = pd.DataFrame(
                            {
                                "x": grid.x_of_node,
                                "y": grid.y_of_node,
                                "z": z,
                                "bc": grid.status_at_node,
                            }
                        )
                        df.to_csv(output_file)

            zmaxes.append(np.max(z))
            zdiff_maxes.append(np.max(z - zinit))

            del grid, z

print(max(zmaxes))
print(max(zdiff_maxes))
