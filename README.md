# Area Tracing: A Regional Channel Impulse Response Modeling Method

Introduction
===
This paper proposes an innovative area-based tracing method named Area Tracing (AT), updated from the classical image method. The basic principle is easy to understand, that any two nearby FOPs will be most likely affected by the same wave sources. In other word, the calculation of Ray Tracing (RT) method for these two FOPs will lead to the same equivalent wave source. Then, instead of issue two RT calculation, it will be a better choice to calculate the affected area of each equivalent wave source.
In detail, the proposed AT method introduces a novel shadow testing algorithm to find the coverage area of each multipath signal. The shadow testing is performed by emitting rays to the edges of reflectors and analyzing the obstruction relationship with other reflectors. It includes shadow testing for Line-Of-Sight (LOS) and Non-Line-Of-Sight (NLOS) and can be used to process coverage areas of any order of reflected signals.
<img width="1563" alt="36c1f5fe0dc5842f3803bdf95ae2dde" src="https://github.com/user-attachments/assets/fbe23f51-d0b9-4812-8d44-8781e6ec31c1" />


Channel Impulse Response Map (CIRM)
===
We constructe a CIRM within the range of 0-400 ns as shown below. The figure illustrates the variation of the CIR amplitude over time.
![animation - 副本](https://github.com/user-attachments/assets/1eb195eb-28db-4470-b845-6378030d1ec4)
Although we don't  consider dynamic scenarios in the article, some readers might be concerned about the changes in dynamic scenarios. Therefore, we rendered a map of the number of multipaths in a specific scenario when the transmitter changes. As you can see from the map, when the transmitter continuously changes in space, the number of multipaths also continuously changes in space.
https://github.com/user-attachments/assets/3ab90bcf-5183-4f6e-9783-fe6f8d2e0eb1




Usage method
===
If you want to use the simple and complex scenarios provided in the paper, you only need to run the Main.m function in the Matlab code. The file provides the data for the simple and complex scenarios. If you want to use the data from OpenstreetMap, first download the data of the region you are interested in using GetOsm.py in the Python folder, and then use the provided Blender to convert the Osm data into the Mat format data and Stl format data required by the code. ImageMethod.m and SBRMethod.m are used to obtain channel Impulse Response (CIR) by using these two methods.

If you only use the AT method, there is no need to change the internal code of Matlab. If you use the image method and the SBR method, two parts of the built-in code of matlab need to be changed. First, in line 631 of the raytrace.m function, the built-in raytracing in MATLAB filters out some rays based on relative path loss. However, we are concerned with the received rays, so this part of the code needs to be commented out. Secondly, in line 657 of the rx_rtChan() function in MATLAB, the calculated CIR is normalized and output. But in our paper, we use absolute path loss, so there is no need for normalization.
<img width="809" alt="Modify1" src="https://github.com/user-attachments/assets/39a2258a-0a15-428f-9bf0-61db77a6fe1f" />
<img width="714" alt="Modify2" src="https://github.com/user-attachments/assets/506a4550-8d57-4e35-a0fe-0d76a066bf34" />

Citation
===
Please cite our paper when you use this code.

Contact
===
Please contact zhangzeyang23@mails.ucas.ac.cn if you have any question about this work.







