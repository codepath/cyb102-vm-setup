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

echo -e "${yellow}WARNING: Installing Snort takes 30-60 minutes.${none}"
echo -e "${yellow}During that time, you will need to leave your machine on and connected to the internet.${none}"
read -p "Do you want to continue with the installation? (y/n) " -n 1 -r 
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Exiting the program. Goodbye!"
    exit 1
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
libmnl-dev ethtool

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
wget https://github.com/gperftools/gperftools/releases/download/gperftools-2.9.1/gperftools-2.9.1.tar.gz
tar xzvf gperftools-2.9.1.tar.gz
cd gperftools-2.9.1
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
wget https://boostorg.jfrog.io/artifactory/main/release/1.77.0/source/boost_1_77_0.tar.gz
tar -xvzf boost_1_77_0.tar.gz

# Install Hyperscan 5.4
cd ~/snort_src
wget https://github.com/intel/hyperscan/archive/refs/tags/v5.4.0.tar.gz
tar -xvzf v5.4.0.tar.gz
mkdir ~/snort_src/hyperscan-5.4.0-build
cd hyperscan-5.4.0-build/
cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DBOOST_ROOT=~/snort_src/boost_1_77_0/ ../hyperscan-5.4.0
make
sudo make install

# Install flatbuffers
cd ~/snort_src
wget https://github.com/google/flatbuffers/archive/refs/tags/v2.0.0.tar.gz -O flatbuffers-v2.0.0.tar.gz
tar -xzvf flatbuffers-v2.0.0.tar.gz
mkdir flatbuffers-build
cd flatbuffers-build
cmake ../flatbuffers-2.0.0
make
sudo make install

# Install Data Acquisition library (DAQ) from the Snort website
cd ~/snort_src
wget https://github.com/snort3/libdaq/archive/refs/tags/v3.0.5.tar.gz -O libdaq-3.0.5.tar.gz
tar -xzvf libdaq-3.0.5.tar.gz
cd libdaq-3.0.5
./bootstrap
./configure
make
sudo make install

# Update shared libraries
sudo ldconfig

# Download, compile, and install Snort 3
cd ~/snort_src
wget https://github.com/snort3/snort3/archive/refs/tags/3.1.17.0.tar.gz -O snort3-3.1.17.0.tar.gz
tar -xzvf snort3-3.1.17.0.tar.gz
cd snort3-3.1.17.0
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