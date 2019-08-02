---
layout: post
title: "Capsule Neural Network (CapsNet)"
subtitle: "理解CapsNet与Dynamic Routing Between Capsules论文"
date: 2017-12-19
author: "Sinputer"
catalog: true
mathjax: true
tags: 
    - Deep Learning
    - Machine Learning
    - Paper Reading
---
# Capsule Neural Network (CapsNet)

## 什么是Capsule

在论文 [*Dynamic Routing Between Capsules*](https://arxiv.org/abs/1710.09829) 中，Geoffrey Hinton 介绍 Capsule 为：
> Capsule 是一组神经元，其输入输出向量**表示**特定实体类型的**实例化参数**（即特定物体、概念实体等出现的概率与某些属性）。

我们使用**输入输出向量的长度表征实体存在的概率，向量的方向表示实例化参数（即实体的某些属性）**。同一层级的 capsule 通过变换矩阵对更高级别的 capsule 的实例化参数进行预测。当多个预测一致时（本论文使用动态路由使预测一致），更高级别的 capsule 将变得活跃。

## CapsNet的结构

### Squashing

$$\mathbf{v}_{j}=\frac{\left\|\mathbf{s}_{j}\right\|^{2}}{1+\left\|\mathbf{s}_{j}\right\|^{2}} \frac{\mathbf{s}_{j}}{\left\|\mathbf{s}_{j}\right\|}$$

其中 $v_j$ 为 Capsule j 的输出向量，$s_j$ 为上一层所有 Capsule 输出到当前层 Capsule j 的向量加权和，简单说 $s_j$ 就为 Capsule j 的输入向量。
该非线性函数可以分为两部分，前一部分是输入向量 $s_j$ 的缩放尺度，第二部分是输入向量 $s_j$ 的单位向量，该非线性函数既保留了输入向量的方向，又将输入向量的长度压缩到区间 [0,1) 内。

两个作用：

- 将向量的长度控制在 0~1 之间，用来表示某个实体的概率
- 作为 CapsNet 的非线性激活函数

### Routing

$$\hat{u}_{j \vert i}=W_{i j} u_{i}$$

向量 $\hat{u}_{j \vert i}$ 是向量 $u_i$ 的线性组合。

向量 $W_{i j}$ 可以理解为控制 i 层到 j 层的传递强度（向量型的权重）。使得前一层的输出以不同强度传递到下一层。

$$s_{j}=\sum_{i} c_{i j} \hat{u}_{j \vert i}$$

通过对 $\hat{u}_{j \vert i}$ 
的加权 $c_{i j}$ 、求和运算得到 $s_j$ （第 j 层的输入向量）。

**耦合系数（coupling coefficients）$c_{i j}$**由动态 Routing 过程迭代地更新与确定。上层和下层级所有 Capsule 间的耦合系数和为 1 。
它由*routing softmax*决定，且 softmax 函数中的 logits $b_{i j}$ 初始化为 0。更新公式为

$$c_{i j}=\frac{\exp \left(b_{i j}\right)}{\sum_{k} \exp \left(b_{i k}\right)}$$

$b_{i j}$ 依赖于两个 Capsule 的位置与类型，但不依赖于当前的输入图像。我们可以通过测量后面层级中每一个 Capsule j 的当前输出 $v_j$ 和 前面层级 Capsule i 的预测向量间的一致性，
然后借助该测量的一致性迭代地更新耦合系数。
本论文简单地通过内积度量这种一致性，
即 $a_{i j}=\mathbf{v}_{j} \cdot \hat{\mathbf{u}}_{j \vert i}$ ，这一部分也就涉及到使用 Routing 更新耦合系数。
我们会计算 $v_j$ 与 $\hat{u}_{j \vert i}$ 的乘积并将它与原来的 $b_{i j}$ 相加而更新 $b_{i j}$，
然后利用 softmax($b_{i j}$) 更新 $c_{i j}$ 而进一步修正了后一层的 Capsule 输入 $s_j$ 。
当输出新的 $v_j$ 后又可以迭代地更新 $c_{i j}$，
这样我们不需要反向传播而直接通过计算输入与输出的一致性更新参数。

#### 流程

![routing](/img/in-post/capsnet-01.png)
> 对于所有在 l 层的 Capsule i 和在 l+1 层的 Capsule j，先初始化 $b_{i j}$ 等于零。然后迭代 r 次，每次先根据 $b_i$ 计算 $c_i$，然后在利用 $c_{i j}$ 与 $\hat{u}_{j \vert i}$ 计算 $s_j$ 与 $v_j$ 。利用计算出来的 $v_j$ 更新 $b_{i j}$ 以进入下一个迭代循环更新 $c_{i j}$ 。该 Routing 算法十分容易收敛，基本上通过 3 次迭代就能有不错的效果。

### Capsule层级结构

![Capsule stucture](/img/in-post/capsnet-02.png)

## CapsNet的优势

### CNN 的缺陷

- 权值共享机制使得CNN在提取特征时忽略了特征在图片的位置。*例如人的眼睛和嘴互换位置，CNN 依然会认为她是人类。*

- 像素级的感受野使得 CNN 过于在于局部的特征信息
- 池化操作使得 CNN 丧失了各特征之间的位置信息

### CapsNet 做的改进

- CapsNet **建立了对对象的坐标系** —— 向量
- CapsNet 更倾向于表示 (Representation) 一个对象，而不仅仅满足于识别它

#### 两个重要的概念

- 不变性 (Invariance)

指不随变换变化。CNN 十分追求Invariance，如 Pooling ，提高了“识别率”。但也使得它丧失了一些能力，例如对位置信息的感知。

![img](/img/in-post/capsnet-03.jfif)

- 同变性 (Equivariance)

即等变映射。对象可能在经过旋转、平移、缩放后，依然具有识别、表示它的能力。
![img](/img/in-post/capsnet-04.jfif)

Capsule 更加追求 Equivariance 。

## Ref

<https://www.zhihu.com/question/67287444/answer/251241736>  
<https://www.jiqizhixin.com/articles/2017-11-05>  
srcPaper *Dynamic Routing Between Capsules* : <https://arxiv.org/abs/1710.09829>  
srcCode ：<https://github.com/naturomics/CapsNet-Tensorflow>
