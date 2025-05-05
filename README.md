# Area Tracing: A Regional Channel Impulse Response Modeling Method

Introduction
===
This paper proposes an innovative area-based tracing method named Area Tracing (AT), updated from the classical image method. The basic principle is easy to understand, that any two nearby FOPs will be most likely affected by the same wave sources. In other word, the calculation of Ray Tracing (RT) method for these two FOPs will lead to the same equivalent wave source. Then, instead of issue two RT calculation, it will be a better choice to calculate the affected area of each equivalent wave source.
In detail, the proposed AT method introduces a novel shadow testing algorithm to find the coverage area of each multipath signal. The shadow testing is performed by emitting rays to the edges of reflectors and analyzing the obstruction relationship with other reflectors. It includes shadow testing for Line-Of-Sight (LOS) and Non-Line-Of-Sight (NLOS) and can be used to process coverage areas of any order of reflected signals.
![](https://github.com/dhjioasjdmakjdap/AreaTracing/raw/main/Fig/Fig0.eps)
