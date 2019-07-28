---
layout: post
title: "RuntimeError: CUDA error: unknown error"
subtitle: ""
date: 2019-07-28
author: "Sinputer"
catalog: true
tags: 
    - Debug
    - Machine Learning
    - Deep Learning
    - Solution
    - Pytorch
---
## 报错描述

最近我在Windows命令行环境中执行含有gpu运算的深度学习任务中时，一直会报下面的错误：

RuntimeError: CUDA error: unknown error

具体是在`torch._C._cuda_init()`这一步发生错误。

## 过程与收获

只搜索`RuntimeError: CUDA error: unknown error`是很难找到正确的解决方案的。谷歌和百度的前面的搜索结果大部分都认为是cuda没安好或者版本与Pytorch不匹配。使用`nvidia-smi`命令发现 cuda version 为10.2
但使用 conda list 命令发现和 cuda version 不一样。为`cudatoolkit   10.0.130`。我认为这俩不是指同一个东西，但以为俩版本可能需要一致，于是兴冲冲装了一个`cuda 10.0`，然后再次运行gpu运算，还是报同样的错误。一运行`nvidia-smi`，发现`cuda version`还是显示 10.2。又把Pytorch使用`
conda install pytorch torchvision cudatoolkit=10.0 -c pytorch`重装了一下，还是不行。我迷惑了，查了一下才发现这俩版本确实不是指同一个东西。

conda list 出来的`cudatoolkit 10.0.130`和在命令行执行`nvcc -V`都是指`cuda runtime API`的版本，但`nvidia-smi`显示的`CUDA Version`是指`cuda driver API`的版本。两者并没有太大的联系，不需要一致。而通常机器学习框架如TensorFlow、Pytorch要求的cuda 版本指的都是`runtime`的版本。

## 解决方案 Solution

所以上面这一通操作下来问题并没有得到解决。我就耐着性子看谷歌的其他结果，偶然发现了一个github closed的issue提出的在使用Pytorch的代码文件中，在`import torch`语句后一句加入（插入）`torch.cuda.current_device()`，问题解决了。注意要在后一句加上这句，虽然在稍微后面一点加可能也work，但我没测试过。

## 参考

solution: https://github.com/pytorch/pytorch/issues/21114

cuda version: https://stackoverflow.com/questions/53422407/different-cuda-versions-shown-by-nvcc-and-nvidia-smi

不work的解决方案（可能适用于其他情况）: https://github.com/pytorch/pytorch/issues/18999 