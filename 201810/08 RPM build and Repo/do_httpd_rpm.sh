#!/bin/bash
cd ~
rpmdev-setuptree

# fix dependecies
curl https://archive.apache.org/dist/apr/apr-1.5.2.tar.bz2 > apr-1.5.2.tar.bz2
cp apr-1.5.2.tar.bz2 rpmbuild/SOURCES/
rpmbuild -tb rpmbuild/SOURCES/apr-1.5.2.tar.bz2
cd ~/rpmbuild/RPMS/x86_64/
sudo yum -y -q --disablerepo=* localinstall apr-1.5.2-1.x86_64.rpm apr-devel-1.5.2-1.x86_64.rpm

# create apache rpm
cd ~
curl http://mirror.linux-ia64.org/apache//httpd/httpd-2.4.37.tar.bz2 > httpd-2.4.37.tar.bz2
tar -xjf httpd-2.4.37.tar.bz2
cp httpd-2.4.37/httpd.spec rpmbuild/SPECS
cp httpd-2.4.37.tar.bz2 rpmbuild/SOURCES
sed -i '150a\ --enable-http2 \\' rpmbuild/SPECS/httpd.spec
sed -i '407a\ %{_libdir}/httpd/modules/mod_http2.so' rpmbuild/SPECS/httpd.spec
rpmbuild -bb rpmbuild/SPECS/httpd.spec
