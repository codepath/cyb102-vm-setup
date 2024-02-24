#!/bin/bash
red='\033[0;31m'
green='\033[0;32m'
none='\033[0m'

echo "[UNIT 3 LAB] Starting script..."

# Check if the script needs to run
if command -v /usr/local/bin/snort >/dev/null 2>&1 ; then
    echo -e "${green}[UNIT 3 LAB]${none} Snort is already installed."
    exit 0
fi
echo "[UNIT 3 LAB] Installing Snort..."

# Set timezone to Eastern Time
sudo timedatectl set-timezone America/New_York

# Create a directory for snort source files
mkdir ~/snort_src
cd ~/snort_src

# Install Snort 3 prerequisites
sudo apt-get install -y build-essential autotools-dev libdumbnet-dev libluajit-5.1-dev libpcap-dev \
zlib1g-dev pkg-config libhwloc-dev cmake liblzma-dev openssl libssl-dev cpputest libsqlite3-dev \
libtool uuid-dev git autoconf bison flex libcmocka-dev libnetfilter-queue-dev libunwind-dev \
libmnl-dev ethtool libdaq-dev google-perftools libgoogle-perftools-dev

# Install safec for runtime bounds checks on certain legacy C-library calls
cd ~/snort_src
wget https://github.com/rurban/safeclib/releases/download/v02092020/libsafec-02092020.tar.gz
tar -xzvf libsafec-02092020.tar.gz
cd libsafec-02092020.0-g6d921f
./configure
make
sudo make install

# Install PCRE: Perl Compatible Regular Expressions
cd ~/snort_src/
wget https://sourceforge.net/projects/pcre/files/pcre/8.45/pcre-8.45.tar.gz
tar -xzvf pcre-8.45.tar.gz
cd pcre-8.45
./configure
make
sudo make install

# Install gperftools 2.9
cd ~/snort_src
wget https://github.com/gperftools/gperftools/releases/download/gperftools-2.15/gperftools-2.15.tar.gz
tar xzvf gperftools-2.15.tar.gz
cd gperftools-2.15
./configure
make
sudo make install

# Install Ragel
cd ~/snort_src
wget http://www.colm.net/files/ragel/ragel-6.10.tar.gz
tar -xzvf ragel-6.10.tar.gz
cd ragel-6.10
./configure
make
sudo make install

# Download the Boost C++ Libraries
cd ~/snort_src
wget https://boostorg.jfrog.io/artifactory/main/release/1.84.0/source/boost_1_84_0.tar.gz
tar -xvzf boost_1_84_0.tar.gz

# Install Hyperscan 5.4
cd ~/snort_src
wget https://github.com/intel/hyperscan/archive/refs/tags/v5.4.2.tar.gz
tar -xvzf v5.4.2.tar.gz
mkdir ~/snort_src/hyperscan-5.4.2-build
cd hyperscan-5.4.2-build/
cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DBOOST_ROOT=~/snort_src/boost_1_84_0/ ../hyperscan-5.4.2
make
sudo make install

# Install flatbuffers
cd ~/snort_src
wget https://github.com/google/flatbuffers/archive/refs/tags/v23.5.26.tar.gz -O flatbuffers-v23.5.26.tar.gz
tar -xzvf flatbuffers-v23.5.26.tar.gz
mkdir flatbuffers-build
cd flatbuffers-build
cmake ../flatbuffers-23.5.26
make
sudo make install

# Install Data Acquisition library (DAQ) from the Snort website
cd ~/snort_src
wget https://www.snort.org/downloads/snortplus/libdaq-3.0.14.tar.gz -O libdaq-3.0.14.tar.gz
tar -xzvf libdaq-3.0.14.tar.gz
cd libdaq-3.0.14
./bootstrap
./configure
make
sudo make install

# Update shared libraries
sudo ldconfig

# Download, compile, and install Snort 3
cd ~/snort_src
wget https://github.com/snort3/snort3/archive/refs/tags/3.1.81.0.tar.gz -O snort3-3.1.81.0.tar.gz
tar -xzvf snort3-3.1.81.0.tar.gz
cd snort3-3.1.81.0
./configure_cmake.sh --prefix=/usr/local --enable-tcmalloc
cd build
make
sudo make install

# Verify Snort installation
/usr/local/bin/snort -V

# Test Snort with the default configuration file
snort -c /usr/local/etc/snort/snort.lua

# Print output based on whether or not Wireshark is installed
if command -v /usr/local/bin/snort >/dev/null 2>&1 ; then
    echo -e "${green}[UNIT 3 LAB]${none} Snort installed successfully."
else
    echo -e "${red}[UNIT 3 LAB]${none} ERROR: Snort was not installed correctly!"
    exit 1
fi