
require_feature "COLLISION_DETECTION"
#require_feature "VIRTUAL_SITES_RELATIVE"

#require_max_nodes_per_side {1 1 1}

set particle 5
cellsystem domain_decomposition -no_verlet_list
set box_length 70
setmd box_l $box_length $box_length $box_length
set pidlist [list]
set fl [open test.vtf a]
set filei 0

part	0	pos	52.3291076981	59.7254451593	55.7715230173	type 	0
part	1	pos	52.2949329079	43.8602665998	60.5464468424	type 	0
part	2	pos	54.3043655289	58.8605291013	69.9263224539	type 	0
part	3	pos	51.862535793	60.3580519235	56.4408629227	type 	0
part	4	pos	36.8211570592	59.249454862	59.0752841021	type 	0

writevsf $fl

#--------------------------------------------------------------------------#
# PART-2---> DEFINE THE MODELS AND CONSTANTS OF EQUATIONS
#--------------------------------------------------------------------------#
set min [analyze mindist 0 0]
puts "THE FIRST MINIMUM DISTANCE : $min"
setmd time_step 0.01
setmd skin 1
#------------------LANGEVIN THERMOSTAT--------------------#
set temp 0.667
set gamma 1
thermostat langevin $temp $gamma
#---------------lENNARD JONES POTENTIAL-------------------#
set eps 1.0
set sigma 1.0
set rcut 2.5

inter 0 0 lennard-jones $eps $sigma $rcut auto
#---------------TABULATED POTENTIAL-------------------#
#inter 0 0 tabulated "potential.tab"
#---------------BONDED POTENTIALS-------------------#
inter 1 angle 200 [PI]
inter 0 harmonic 959.6 1.0
#---------------BOUNDARY_CONDITIONS-----------------------#
#...Periodic boundary cond. Later, this may be changed....#
setmd periodic 1 1 1
#------------------COLLISION------------------------------#
on_collision bind_three_particles 1.4 0 1
puts [on_collision]
#--------------------PARTICLE CONTROL----------------------#

for {set i 0} {$i <$particle} {incr i} {
    lappend pidlist $i
    vtfpid $i
}

#---------------PARTICLE MOTION---------------------------#


set n_cycle 2
set n_steps 1

set fileid 0
set i 0
while { $i<$n_cycle } {   

     writevcf $fl pids $pidlist

     integrate $n_steps

incr i
}

   # CLOSE MAIN LOOP


exit

