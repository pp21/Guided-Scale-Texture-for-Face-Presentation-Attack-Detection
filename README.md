# Guided scale texture for face presentation attack detection

Table of Contents
=================

- Introduction
- Usage
- Additional information
- Contact


Introduction
============

This source code provides a simple implementation of guided scale texture in face presentation attack detection. It includes guided scale local binary pattern (GS-LBP) and local guided binary pattern (LGBP). It is very easy to use and reproduce our work.

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
