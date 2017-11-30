# Team-SDK-545

This is the repository for our capstone design project in 18-545: Advanced Digital Design at Carnegie Mellon University.

## Team Members
 - Kais Kudrolli
 - DongJoon Park
 - Sohil Shah

## Project Overview
We designed a system using a Xilinx Virtex 7 FPGA that can classify the handwritten digits 0-9 when they are written in different styles and with varying sloppiness. The FPGA implements an artificial neural network that performs classification/prediction in hardware. Training can be done in software and synthesized with the network, or it can be done dynamically in hardware itself. The final system worked by pointing a camera at a digit written on a whiteboard. This image would be manipulated by a software stack and would then be transferred across UART to the FPGA. Here, prediction and training would occur. The resulting prediction would be displayed on an HDMI monitor along with confidence estimates. Our final demo worked without any major issues. The prediction accuracy varied with the amount of time the network was trained, and sometimes predictions were skewed due to changes in lighting or position of the camera.

## Repository Structure 
This project was developed using Xilinx Vivado. The Vivado project file (.xpr) is located at: <br />
 - `hdmi_test/hdmi_test.xpr` <br />
The top-level module is located at: <br />
 - `hdmi_test/hdmi_test.srcs/sources_1/imports/gameboy/chipinterface.sv` <br />
RTL module are located in: <br />
 - `hdmi_test/hdmi_test.srcs/sources_1/imports/gameboy/`<br />
 - `hdmi_test/hdmi_test.srcs/sources_1/imports/src/`<br />
 - `hdmi_test/hdmi_test.srcs/sources_1/new/`<br />
 - `hdmi_test/rtl/src/`<br />
Software layer code is located in: <br />
 - `sw/camera/`<br />
 - `sw/image/`<br />
 - `sw/uart/`

## Running the System
DISCLAIMER: This has only been tested using Python 2.7, Xilinx VC707 (Virtex 7) FPGA board, Xilinx Vivado, our 18-545 lab machines, and our webcam. So, no guarantees are provided that it will work if any of these components are changed. Use at your own risk.

1) Connect the webcam to the host machine, UART-to-USB cable between the host machine and FPGA board, and HDMI cable to the HDMI monitor.<br />
2) Install OpenCV 3.0.0 and Virtual COM Port drivers for CP210x Silicon Labs USB-to-UART bridge.<br />
3) Synthesize, implement, and program the bitstream for hdmi\_test.xpr.<br />
4) Open a terminal and change your directory to `sw/camera/`. Run `python video.py`.<br />
5) If all has gone well, a window should open with the camera feed. You should see the camera feed on the HDMI monitor, and prediction should occur.

## Demo Videos and Images

Here are a few videos showing our neural network in action!<br />
[Predicting an 8](https://youtu.be/tFqGyZiZLp0)<br />
[Predicting a 3](https://youtu.be/yY6XIArAm80)<br />
[Predicting a 7 and 6](https://youtu.be/TedDdXtzL0g)<br />

Our system setup:<br />
![SystemSetup](https://user-images.githubusercontent.com/6314341/33359953-0f078a78-d497-11e7-85c4-20e810f2bc75.JPG)

Another view of the setup:<br />
![SystemSetup2](https://user-images.githubusercontent.com/6314341/33360078-b5046fea-d497-11e7-921d-62ba7e0fce1b.JPG)

System correctly predicting a 4:<br />
![Prediction4](https://user-images.githubusercontent.com/6314341/33360129-f1453778-d497-11e7-906b-f54d9e146b8a.JPG)

System correctly predicting a 3, even with the box drawn around it:<br />
![NoisyPrediction3](https://user-images.githubusercontent.com/6314341/33360159-2b4a787a-d498-11e7-85d0-a0ee91c31f55.JPG)
