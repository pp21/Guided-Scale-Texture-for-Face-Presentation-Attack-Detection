# Guided scale texture for face presentation attack detection (aka face anti-spoofing or spoofing detection)
## Peng, F., Qin, L., Long, M. Face presentation attack detection using guided scale texture. Multimedia Tools and Applications, DOI: 10.1007/s11042-017-4780-0, 2017

----------------------------------------------------------
---Implementation of guided scale texture in face presentation attack detection---
----------------------------------------------------------


Table of Contents
=================

- Introduction
- Usage
- Additional information
- Contact


Introduction
============

This source code provides a simple implementation of guided scale texture in face presentation attack detection.
It includes guided scale local binary pattern (GS-LBP) and local guided binary pattern (LGBP).
It is very easy to use and reproduce our work.


Usage
=====

The two core functions of this implementation

a) For guided scale local binary pattern (GS-LBP)

Example:

q = guidedfilter(I, I, r, eps);	 % guided scale conversion
J = lbp(q); % for image-based GS-LBP
J_blk = lbp_blk(q, lbp_r, lbp_p, mappingtype, mode, rowstep, colstep);	% for block-based GS-LBP
	
This example returns the GS-LBP of the input image. Other parameters are described in lbp_blk, lbp and guidedfilter.

b) For local guided  binary pattern (LGBP)

Example:

lgbprst = lgbp(I, IG, lbp_r, lbp_p, mappingtype, wr, eps, mode);	% for image-based LGBP
lgbp_blk_rst = lgbp_blk(I, IG, lbp_r, lbp_p, mappingtype, wr, eps, mode, rowstep, colstep);	% for block-based LGBP

This example returns the LGBP of the input image. Other parameters are described in lgbp and lgbp_blk.


Additional information
======================

The implementation of LBP is licensed to Timo Ojala, Matti Pietikainen, and Topi Maenpaa,

The implementation of guided image filtering is licensed to Kaiming He, Jian Sun, and Xiaoou Tang

The implementation of guided scale texture is licensed to Fei Peng, Le Qin, and Min Long, 
College of Computer Science and Electronic Engineering, Hunan University, Changsha, China.
College of Computer and Communication Engineering, Changsha University of Science and Technology, Changsha, China.


Contact
============

For any question, please contact Prof. Fei Peng <eepengf@gmail.com> and Le Qin <qinle@hnu.edu.cn>.

Please kindly cite our paper as follow when you use it. Thank you.

Please cited as: Peng, F., Qin, L., Long, M. Face presentation attack detection using guided scale texture. Multimedia Tools and Applications, DOI: 10.1007/s11042-017-4780-0, 2017
