#!/bin/bash
#########################################################
# build glibc 2.2.7 RPM for Centmin Mod CentOS 7 systems
# written by George Liu (eva2000) https://centminmod.com
#########################################################
# variables
#############
DT=$(date +"%d%m%y-%H%M%S")
VER='0.1'

DIR_TMP='/svr-setup'
BUILTRPM='y'
DISTTAG='el7'
RPMSAVE_PATH="$DIR_TMP"
GLIBC_VER='2.2.7'
      
DESTDIR=/opt/glibc
HOME_GLIBC=/home/build_glibc
GLIBCPREFIX=/usr
#########################################################
# functions
#############

glibc_install() {
if [[ -f /opt/rh/devtoolset-7/root/usr/bin/gcc && -f /opt/rh/devtoolset-7/root/usr/bin/g++ ]]; then 
  source /opt/rh/devtoolset-7/enable

  if [ ! -f /usr/local/bin/fpm ]; then
    yum -y install ruby-devel gcc make rpm-build rubygems
    gem install --no-ri --no-rdoc fpm
  fi
  
  if [ -f /usr/bin/xz ]; then
    FPMCOMPRESS_OPT='--rpm-compression xz'
  else
    FPMCOMPRESS_OPT='--rpm-compression gzip'
  fi
  
  mkdir -p $HOME_GLIBC/src
  cd $HOME_GLIBC/src
  rm -rf glibc
  git clone --depth=1 git://sourceware.org/git/glibc.git
  rm -rf $HOME_GLIBC/build/glibc
  mkdir -p $HOME_GLIBC/build/glibc
  cd $HOME_GLIBC/build/glibc
  $HOME_GLIBC/src/glibc/configure --prefix=$GLIBCPREFIX
  make -j$(nproc)
  mkdir -p ${HOME_GLIBC}/build/glibc${GLIBCPREFIX}/etc
  touch ${HOME_GLIBC}/build/glibc${GLIBCPREFIX}/etc/ld.so.conf
  make install DESTDIR=${DESTDIR}
  
  git clone --depth=1 git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
  cd linux
  make headers_install INSTALL_HDR_PATH="${DESTDIR}${GLIBCPREFIX}"
  if [ -f /opt/rh/devtoolset-7/root/usr/lib/gcc/x86_64-redhat-linux/7/libgcc_s.so ]; then
    ln -s /opt/rh/devtoolset-7/root/usr/lib/gcc/x86_64-redhat-linux/7/libgcc_s.so "${DESTDIR}/lib64/libgcc_s.so.1"
    ls -lah "${DESTDIR}/lib64/"
  else
    cp /lib64/libgcc* "${DESTDIR}/lib64/"
    ls -lah "${DESTDIR}/lib64/"
  fi
  cd ../
  rm -rf linux
  
  LDDBIN=$(find /opt/glibc/ -type f -name "ldd*")
  LDPATH=$(find /opt/glibc/ -type f -name "ld-*")
  echo $LDDBIN
  echo "$LDDBIN --version"
  $LDDBIN --version
  echo "$LDPATH"
  
  echo -e "* $(date +"%a %b %d %Y") George Liu <centminmod.com> $GLIBC_VER\n - glibc $GLIBC_VER for centminmod.com LEMP stack installs" > "glibc-custom-${GLIBC_VER}-changelog"
  time fpm -f -s dir -t rpm -n glibc-custom -v $GLIBC_VER $FPMCOMPRESS_OPT --rpm-changelog "glibc-custom-${GLIBC_VER}-changelog" --rpm-summary "glibc-custom-${GLIBC_VER} for centminmod.com LEMP stack installs" --rpm-dist ${DISTTAG}  -m "<centminmod.com>" --description "glibc-custom-${GLIBC_VER} for centminmod.com LEMP stacks" --url https://centminmod.com --rpm-autoreqprov --prefix ${DESTDIR} -p $DIR_TMP -C ${DESTDIR}
  
  echo
  ls -lah "${DIR_TMP}/glibc-custom-${GLIBC_VER}-1.${DISTTAG}.x86_64.rpm"
  
  echo
  rpm -qp --provides "${DIR_TMP}/glibc-custom-${GLIBC_VER}-1.${DISTTAG}.x86_64.rpm"
  
  echo
  echo "yum localinstall "${DIR_TMP}/glibc-custom-${GLIBC_VER}-1.${DISTTAG}.x86_64.rpm""
  # yum localinstall "${DIR_TMP}/glibc-custom-${GLIBC_VER}-1.${DISTTAG}.x86_64.rpm"
  
  echo
else
  echo
  echo "error: devtoolset-7 missing"
  echo
  exit 1
fi
}

#########################################################
case $1 in
  install )
  glibc_install
    ;;
  pattern )
    ;;
  pattern )
    ;;
  pattern )
    ;;
  pattern )
    ;;
  * )
    echo
    echo "Usage:"
    echo
    echo "$0 {install}"
    echo
    ;;
esac
exit
