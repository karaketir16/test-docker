# Start with Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set environment variables to avoid interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Update and install required dependencies
RUN apt-get update && apt-get install -y \
    autoconf \
    automake \
    autotools-dev \
    curl \
    python3 \
    python3-pip \
    libmpc-dev \
    libmpfr-dev \
    libgmp-dev \
    gawk \
    build-essential \
    bison \
    flex \
    texinfo \
    gperf \
    libtool \
    patchutils \
    bc \
    zlib1g-dev \
    libexpat-dev \
    ninja-build \
    git \
    cmake \
    libglib2.0-dev \
    && rm -rf /var/lib/apt/lists/*  # Clean up apt cache to reduce image size

# Clone the riscv-gnu-toolchain repository
RUN git clone https://github.com/riscv/riscv-gnu-toolchain /riscv-gnu-toolchain

# Build the toolchain
WORKDIR /riscv-gnu-toolchain
RUN ./configure --prefix=/opt/riscv --enable-multilib && \
    make -j$(nproc) newlib linux build-sim SIM=qemu && \
    make install && \
    rm -rf /riscv-gnu-toolchain # Clean up to reduce image size

# Set the PATH environment variable to include the RISC-V toolchain
ENV PATH=/opt/riscv/bin:$PATH

# Set the working directory (optional)
WORKDIR /workspace

# Set the default command to run (you can override this when running the container)
CMD ["bash"]
