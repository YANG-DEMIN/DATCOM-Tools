# DATCOM-Tools
Based on the 1976 USAF STABILITY AND CONTROL DIGITAL DATCOM PROGRAM, the tool is designed to provide a simpler AND more convenient form input with 3d mapping AND aerodynamic characteristics output.

1.1 INTRODUCTION

Based on the 1976 USAF stability and control digital Datcom program, this tool is developed to provide a more concise and convenient shape input mode, and has the functions of three-dimensional drawing and aerodynamic characteristic output.



1.2 installation and environment configuration

1、 The code is based on the Datcom program provided by holy cow company. First download its installation package (both windows and Linux). http://www.holycows.net/datcom/buy.html

2、 Install to the location you want. Be careful not to have a Chinese path

3、 Test whether Datcom can operate normally. Copy the citation. In the examples folder DCM files into the bin folder, and double-click citation dcm。 If citation. Appears in the bin folder 1.ac、Citation. 2.ac、Citation. Out and other documents, indicating the normal operation of the program. If an error is reported saying "error located in file: city. DCM", you need to change the environment variables as follows:

（1.1） Press the windows key + R. Enter "systempropertiesadvanced. Exe";

（1.2） Click the environment variable box;

（1.3） Change the environment variable of datcomroot, delete the leading and trailing double quotes, save and exit;

（1.4） In the Datcom \ bin directory on the desktop, edit Datcom Bat file, delete the double quotation marks on lines 14, 15 and 16;

Set PREDAT_ PROGRAM="predat"

Set DATCOM_ PROGRAM="digdat"

Set DATCOM_ MODELER_ PROGRAM =“DATCOM -modeler”

4、 Retest and the program should respond normally

5、 Copy the bin folder of this program, replace the bin folder under the original installation path, and edit Datcom Line 13 of the bat file

Set PATHofDATCOM=C:\Users\ydm\Datcom

Change the path to the user's actual installation path

6、 Open MATLAB and run citation_ myself. M file and observe the output. If there is no error, the installation is successful.



1.3 instructions for use

The following is the citation_ myself. M file as an example, operation instructions:

1． All input information is stored in the form of structure

In MATLAB functions, the functions are divided into blocks based on namelists, namely fltcon / options / syncs / body / wing / flags / ailerons / horizon tail / vertical tail / vertical fin / Twin Vertical / elevator. For specific information, please refer to code notes and Datcom manual.

Typical profile documents are:

type file

Normal layout aircraft citation_ myself. m

Duck layout UAV canard. m

Tandem wing UAV (spring knife) switchblade. m

cruise missile normal. dcm



2． 3D drawing function

datcom3d_ UAV function can draw fuselage, wing, vertical tail, flat tail, flap, aileron and elevator.



3． Data output function

In the example function, multiple structures can be defined by changing one or more parameters to express aircraft with different configurations and compare their aerodynamic characteristics. The following shows the influence of changing the longitudinal position of the wing on the aerodynamic characteristics. It can be seen that the longitudinal position of the wing has little effect on the lift, but will greatly affect the longitudinal stability.



1.4 advanced functions

The extraction functions of aerodynamic characteristics in the example functions are Matlab's own function Datcom import. Although this function extracts all important information from the output file, it has the problem of long running time. If large-scale aerodynamic characteristic calculation (such as evolutionary algorithm) is required, it will greatly waste computing resources and time. Therefore, this Toolbox provides the function of reading specific information. The function name is read_fit. M, which can be used with ga_switchblade. M. when using, copy the read_fit. M function to the corresponding output folder to quickly read relevant information.