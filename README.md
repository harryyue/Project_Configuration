# Introduction

This project contain the source code of Tiny4412 Board,such as uboot,kernel and
busybox.we can use the script BuildProject.sh to build all image of this project.
so... in other word,it's a store of Tiny4412 build management.

# How to build image
We use script BuildProject.sh to build the project.The usage as below:
		bash BuildProject.sh <target>
the target list:
 all 		---build all image,such as uboot,kernel and busybox.
 uboot 		---build uboot image.
 kernel 	---build kernel image.
 busybox 	---build busybox image.
 clean 		---remove all image.

---------------------------------------------------------------------------
Harry update it at Oct 15,2017
