#!/bin/bash
# sh-elf toolchain (KOS kos-chain "stable" profile) + KOS for KOS_SUBARCH=naomi, in a cloud workspace
# that blocks the GNU mirrors: tarballs from archive.ubuntu.com, GCC prerequisites from the system.
set -e
apt-get install -y libgmp-dev libmpfr-dev libmpc-dev libisl-dev texinfo flex bison libelf-dev libjpeg-dev libpng-dev
U=http://archive.ubuntu.com/ubuntu/pool
C=/opt/toolchains/dc/kos/utils/kos-chain
cd $C
[ -f binutils-2.45.tar.xz ] || curl -sSfo binutils-2.45.tar.xz $U/main/b/binutils/binutils_2.45.orig.tar.xz
if [ ! -f gcc-15.2.0.tar.xz ]; then
  curl -sSfo gcc15.orig.tar.gz $U/main/g/gcc-15/gcc-15_15.2.0.orig.tar.gz
  tar xzf gcc15.orig.tar.gz --wildcards '*/gcc-15.2.0.tar.xz' --strip-components=1
  rm gcc15.orig.tar.gz
fi
if [ ! -f newlib-4.6.0.20260123.tar.gz ]; then
  curl -sSfo newlib.tar.xz $U/universe/n/newlib/newlib_4.6.0.20260123.orig.tar.xz
  mkdir -p nl && tar xJf newlib.tar.xz -C nl && d=$(ls nl) && mv nl/$d newlib-4.6.0.20260123 && tar czf newlib-4.6.0.20260123.tar.gz newlib-4.6.0.20260123 && rm -rf nl newlib.tar.xz newlib-4.6.0.20260123
fi
[ -f config.guess ] || { tar xJf gcc-15.2.0.tar.xz gcc-15.2.0/config.guess gcc-15.2.0/config.sub && cp gcc-15.2.0/config.guess gcc-15.2.0/config.sub . && rm -rf gcc-15.2.0; }
cp -n Makefile.dreamcast.cfg Makefile.cfg
sed -i 's/^makejobs=.*/makejobs=2/' Makefile.cfg
make binutils_ver=2.45 use_custom_dependencies=1 enable_objc=0 enable_objcpp=0
# KOS (Dreamcast tree for host utils) and a copy for NAOMI
cd /opt/toolchains/dc/kos
cp -n doc/environ.sh.sample environ.sh
# (the kernel builds before the utilities; with libjpeg-dev and libpng-dev the utilities build too)
source environ.sh && make -j2 && make -C utils/naomibintool
cd /opt/toolchains/dc
rm -rf kos-naomi && cp -a kos kos-naomi && cd kos-naomi
sed -i 's|^export KOS_BASE=.*|export KOS_BASE="/opt/toolchains/dc/kos-naomi"|; s|^export KOS_SUBARCH=.*|export KOS_SUBARCH="naomi"|' environ.sh
sed -i 's/^#export KOS_SUBARCH="naomi"/export KOS_SUBARCH="naomi"/' environ.sh; grep -q "^export KOS_SUBARCH=\"naomi\"" environ.sh
source environ.sh && make clean >/dev/null 2>&1; make -j2
make -C utils/naomibintool
echo TOOLCHAIN_DONE
