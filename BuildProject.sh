#/bin/bash
#

TOPDIR=`pwd`
OUTDIR="$TOPDIR/out"
UBOOT_SRC="$TOPDIR/uboot"
KERNEL_SRC="$TOPDIR/kernel"
BUSYBOX_SRC="$TOPDIR/busybox"

FLAG=0
RED="\033[31;1m"
GREEN="\033[32;1m"
RESET="\033[0m"

introduction()
{
	echo ""
	echo "###############   Tiny4412  Image Build Introduction    ###############"
	echo "###  Author:    Harry"
	echo "###  Email:     harryyue123@163.com"
	echo "###  Version:   V1.0"
	echo "###  Create:    2017-10-15"
	echo "###  Update:    2017-10-15"
	usage
	echo "#######################################################################"
	echo ""
}

usage()
{
	echo "###  Usage:"
	echo "### 			bash  $0  <target>"
	echo "###  taget list:"
	echo "###     all 				---build all image,such as uboot,kernel and busybox."
	echo "###     uboot 			---build uboot image."
	echo "###     kernel 			---build kernel image."
	echo "###     busybox 			---build busybox image."
	echo "###     clean 			---remove all image."
}

#check if the numeber of input is right 
if [ $# != 1 ]
then
	echo -e $RED"[ERROR]The input's number isn't 1."$RESET
	usage
	exit 1
fi

#check if the image output does exsit.
test -d $OUTDIR || mkdir -p $OUTDIR

introduction
#Target:clean
if [ $1 = "clean" ]
then
	echo -e $GREEN"bash $0 $1"$RESET
	cd $OUTDIR && rm -rf *
	cd $UBOOT_SRC && make clean
	cd $KERNEL_SRC && make clean
	cd $BUSYBOX_SRC && make clean
	exit 0
fi

#Target:uboot or all
if [ $1 = "uboot" -o $1 = "all" ]
then
	echo -e $GREEN"bash $0 uboot"$RESET
	(test -d $UBOOT_SRC && cd $UBOOT_SRC) || (echo -e $RED"[ERROR]Fail to access the $UBOOT_SRC"$RESET;exit 1)
	test $? = 0 || exit 1
	make || (echo -e $RED"ERROR Fail to build uboot"$RESET;exit 1)
	test $? = 0 || exit 1
	test -d sd_fuse/tiny4412 && cd sd_fuse/tiny4412 || (echo -e $RED"[ERROR]Fail to access the $UBOOT_SRC/sd_fuse/tiny4412"$RESET;exit 1)
	test $? = 0 || exit 1
	bash sd_fusing_part1.sh || (echo -e $RED"[ERROR]Fail to create the bootloader image."$RESET;exit 1)
	test $? = 0 || exit 1
	cp bootloader.img out
	FLAG=1
fi

#Target:kernel or all
if [ $1 = "kernel" -o $1 = "all" ]
then
	echo -e $GREEN"bash $0 kernel"$RESET
	(test -d $KERNEL_SRC && cd $KERNEL_SRC) || (echo -e $RED"[ERROR]Fail to access the $KERNEL_SRC"$RESET ; exit 1)
	test $? = 0 || exit 1
#	make || (echo -e $RED"ERROR Fail to build kernel"$RESET;exit 1)
	test $? = 0 || exit 1
	FLAG=1
fi

#Target:busybox or all
if [ $1 = "busybox" -o $1 = "all" ]
then
	echo -e $GREEN"bash $0 busybox"$RESET
	(test -d $BUSYBOX_SRC && cd $BUSYBOX_SRC) || (echo -e $RED"[ERROR]Fail to access the $BUSYBOX_SRC"$RESET;exit 1)
	test $? = 0 || exit 1
#	make || (echo -e $RED"ERROR Fail to build busybox"$RESET;exit 1)
	test $? = 0 || exit 1
	FLAG=1
fi

#check if the target is invalid
if [ $FLAG = 0 ]
then
	echo -e $RED"[ERROR]The target is invaild."$RESET
	usage
	exit 1
fi

echo -e $GREEN"Finish."$RESET
exit 0
