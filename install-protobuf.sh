set -ex

basename=protobuf-2.6.0
tarball=$basename.tar.bz2

wget https://protobuf.googlecode.com/svn/rc/$tarball
tar -xvf $tarball
cd $basename && ./configure --prefix=/usr && make && make install
