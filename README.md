Install the following packages:

gcc
libx11-dev
libxt-dev
libtinfo-dev
clang
make
ack
parcellite - sync clipboard and select text on linux, consider submoduling
xclip
bison
ctags
go - gvm requires a go compiler to build?

on vmware systems:
open-vm-tools
open-vm-tools-desktop

to add a submodule:
git submodule add <url>

to update a submodule:
cd <submodule>; git pull; cd -
or
cd <submodule>; git checkout <tag>; cd -
