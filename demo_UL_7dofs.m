%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              UPPER LIMB FORWARD KINEMATICS                              %
%-------------------------------------------------------------------------%
% Author:      Marta Gandolla                                             %
% Description: Foward kinematics which calculates the EE (wrist) position %
%              from articular angles of a 7DOF upper limb model           %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc

%% Add path to `my-matlab-robotics-toolbox`
addpath(".\my-matlab-robotics-toolbox\")

%% Upper-limb model DH parameters
% q1 - Shoulder adb/add
% q2 - Shoulder f/e
% q3 - Humeral rotation
% q4 - Elbow f/e
% q5 - Wrist deviation
% q6 - Wrist f/e
% q7 - Forearm pron/sup

global N_DOFS;
N_DOFS = 7;
ul = 20;
ll = 25;
% Denavit-Hartenberg parameters
% Reference:
% https://users.cs.duke.edu/~brd/Teaching/Bio/asmb/current/Papers/chap3-forward-kinematics.pdf
theta = [0 pi/2 0 -pi/2 0 pi/2 0];
alpha = [pi/2 pi/2 -pi/2 -pi/2 pi/2 pi/2 0];
offset = [0 0 0 0 0 0 0];
a = [0 0 0 ll 0 0 0];
d = [0 0 ul 0 0 0 0];
type = ['r' 'r' 'r' 'r' 'r' 'r' 'r'];
base = [0; 0; 0];
% Joint limits (optional)
%ub = [deg2rad(90) deg2rad(90) 360 deg2rad(150) 360 360 360];
%lb = [deg2rad(-90) deg2rad(-90) -360 0 0 0 0];

% Create the robot
UpperArm = cgr_create(theta, d, a, alpha, offset, type, base); %, ub, lb);
% Bring the robot in the rest state
q0 = [0 0 0 0 0 0 0];
UpperArm = cgr_self_update(UpperArm, q0);
% Visualize the robot
g = ncgr_graphic();
plot_options = {[1 1 1], ...    % view vector
                1, ...          % axis scale 
                [-30 100], ...   % x-axis range
                [-50 100], ...   % y-axis range
                [-30 100], ...   % z-axis range
                };
g = ncgr_plot(g, UpperArm, plot_options{:});
title('Rest pose')

%% Move the robotic arm
% Define DOF names
dof_names = ["shoulder abdo/adduction", ...
             "shoulder flexo/extension", ...
             "humeral rotation", ...
             "elbow flexo/extension", ...
             "wrist deviation", ...
             "wrist flexo/extension", ...
             "forearm prono/supination"];
% Open a new figure
g_test = ncgr_graphic();
for i = 1 : N_DOFS
    % Open a new figure and plot the robot
    %g_test = ncgr_graphic();
    pause(2);
    g_test = ncgr_plot(g_test, UpperArm, plot_options{:});
    title(strcat('q_', num2str(i), {' '}, dof_names(i)));
    % Move the robot to a different configuration
    q = zeros(N_DOFS);
    q(i) = deg2rad(90);
    UpperArm = cgr_self_update(UpperArm, q);
    % Visualize the movement
    g_test = ncgr_plot(g_test, UpperArm, plot_options{:});
end
% [R, p_des] = cgr_fkine_ee(UpperArm, q);
% [R2, p_des2] = cgr_fkine_ee(UpperArm, q2);
% [p_des p_des2]
% [R R2]

