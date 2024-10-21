The SteadyState folder contains all the code to create the steady-state grids. 

A poorly named experiment called testtesttest created the initial white-noise grid that was used for both the CHILD Voronoi experiments and the Landlab Voronoi experiments. The initial near-flat but slightly noisy grid can be recreated from the output using the testtesttest.inputs input file.

The inputs used for the steady-state experiments with dt = 250 years and dt = 2,500 years are in the input files dtp25_U1em4.inputs and dt2p5_U1em4.inputs, respectively. There are two other input files in the folder. Those were used to test the longer time steps. Those experiments were unstable and were not presented, but we included the input files in case the reader would like to see the output to recreate the instability. (Note that all of these experiments require the outputs from the testtesttest experiment.)

In the folder Transient there are two input files for each of the transient experiments. 

For the 250 year time step transient experiments, dtp25_U1em4IU5em4.in can be used first, and then the output from that experiment is used to run dtp25_U1em4IU5em4r1.in. The transient experiment was broken into two parts because it was initially run for too short of a time.

For the 2,500 year time step transient experiments, dt2p5_U1em4IU5em4.in can be used first, and then the output from that experiment is used to run dt2p5_U1em4IU5em4r1.in.
