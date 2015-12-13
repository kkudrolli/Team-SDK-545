# Team-SDK-545

This is the repository for our capstone design project in 18-545: Advanced Digital Design at Carnegie Mellon University.

## Team Members
 - DongJoon Park
 - Sohil Shah
 - Kais Kudrolli

## Project Overview
We designed a system using a Xilinx Virtex 7 FPGA that can classify the handwritten digits 0-9 when they are written in different styles and with varying sloppiness. The FPGA implements an artificial neural network that performs classification/prediction in hardware. Training can be done in software and syntheized with the network or it can be done dynamically in hardware itself. The final system worked by pointing a camera at a digit written on a whiteboard. This image would be manipulated by a software stack and would then be transferred across UART to the FPGA. Here, prediction and training would occur. The resulting prediction would be displayed on an HDMI monitor along with confidence estimates. Our final demo worked without any major issues. The prediction accuracy varied with the amount of time the network was trained, and sometimes predictions were skewed due to changes in lighting or position of the camera.

## Repository Structure 
This project was developed using Xilinx Vivado. The Vivado project file (.xpr) is located at:
`hdmi_test/hdmi_test.xpr`
The top-level module is located at:
`hdmi_test/hdmi_test.srcs/sources_1/imports/gameboy/chipinterface.sv`
RTL module are located in:
`hdmi_test/hdmi_test.srcs/sources_1/imports/gameboy/`__
`hdmi_test/hdmi_test.srcs/sources_1/imports/src/`__
`hdmi_test/hdmi_test.srcs/sources_1/new/`__
`hdmi_test/rtl/src/`__
Software layer code is located in:
`sw/camera/`__
`sw/image/`__
`sw/uart/`

## Running the System
DISCLAIMER: This has only been tested using Python 2.7, Xilinx VC707 (Virtex 7) FPGA board, Xilinx Vivado, our 18-545 lab machines, and our webcam. So, no guarantees are provided that it will work if any of these components are changed. Use at your own risk.

1) Connect the webcam to the host machine, UART-to-USB cable between the host machine and FPGA board, and HDMI cable to the HDMI monitor.__
2) Install OpenCV 3.0.0 and Virtual COM Port drivers for CP210x Silicon Labs USB-to-UART bridge.__
3) Synthesize, implement, and program the bitstream for hdmi\_test.xpr.__
4) Open a terminal and change your directory to `sw/camera/`. Run `python video.py`.__
5) If all has gone well, a window should open with the camera feed. You should should the camera feed on the HDMI monitor, and prediction should occur.
