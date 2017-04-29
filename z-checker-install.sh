#!/bin/bash

rootDir=`pwd`

NODE_URL=https://nodejs.org/dist/v6.10.2/node-v6.10.2.tar.gz
NODE_SRC_DIR=$rootDir/node-v6.10.2
NODE_DIR=$rootDir/node-v6.10.2-install

#---------- download gnuplot ----------------
git clone https://github.com/gnuplot/gnuplot.git
cd gnuplot
./prepare
./configure --prefix=$rootDir/gnuplot/gnuplot-install
make
make install
echo "export PATH=$rootDir/gnuplot/gnuplot-install/bin:$PATH" >> ~/.bashrc
source ~/.bashrc

#---------- download Z-checker --------------
cd $rootDir
git clone https://github.com/CODARcode/Z-checker.git
cd Z-checker
./configure --prefix=$rootDir/Z-checker/zc-install
make
make install
cp ../zc-patches/test-generateGNUPlot.sh ./examples/

#---------- download ZFP and set the configuration -----------
cd $rootDir

git clone https://github.com/LLNL/zfp.git
cd zfp
make

cd -
cp zfp-patches/zfp-zc.c zfp/utils
cp zfp-patches/*.sh zfp/utils

cd zfp/utils/
patch -p0 < ../../zfp-patches/Makefile-zc.patch
make

#---------- download SZ and set the configuration -----------
cd $rootDir
git clone https://github.com/disheng222/SZ

cd SZ/sz/src
patch -p1 < ../../../sz-patches/sz-src-hacc.patch

cd ../..
./configure --prefix=$rootDir/SZ/sz-install
make
make install

cd example
patch -p0 < ../../sz-patches/Makefile-zc.bk.patch
make -f Makefile.bk
cp ../../Z-checker/examples/zc.config .
patch -p0 < ../../zc-patches/zc-probe.config.patch

cp ../../sz-patches/sz-zc-ratedistortion.sh .
cp ../../sz-patches/testfloat_CompDecomp.sh .


# download and install node.js
cd $rootDir
curl -O $NODE_URL
tar zxf node-v6.10.2.tar.gz
cd $NODE_SRC_DIR
./configure --prefix=$NODE_DIR
make
make install

# download z-checker-web
cd $rootDir
git clone https://github.com/CODARcode/z-checker-web
cd z-checker-web
$NODE_DIR/bin/npm install
cd $rootDir
