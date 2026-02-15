FROM debian:trixie-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    USER=build \
    ANDROID_BUILD_TOP=/home/build/lineageos

# Install dependencies
RUN apt-get update && apt-get install -y \
    bc \
    bison \
    build-essential \
    ccache \
    curl \
    flex \
    g++-multilib \
    gcc-multilib \
    git \
    git-lfs \
    gnupg \
    gperf \
    imagemagick \
    lib32ncurses-dev \
    lib32readline-dev \
    lib32z1-dev \
    libelf-dev \
    liblz4-dev \
    libncurses6 \
    libsdl1.2-dev \
    libssl-dev \
    libxml2 \
    libxml2-utils \
    lzop \
    pngcrush \
    rsync \
    schedtool \
    squashfs-tools \
    xsltproc \
    zip \
    zlib1g-dev \
    openjdk-21-jdk \
    python3 \
    python3-pip \
    repo \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create build user
RUN useradd -m -s /bin/bash ${USER} && \
    echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Configure git and repo
USER ${USER}
WORKDIR /home/${USER}

RUN git config --global user.email "builder@lineageos.local" && \
    git config --global user.name "LineageOS Builder" && \
    git config --global color.ui false

# Initialize LineageOS repository
RUN mkdir -p ${ANDROID_BUILD_TOP} && \
    cd ${ANDROID_BUILD_TOP} && \
    repo init -u https://github.com/LineageOS/android.git -b lineage-21.0 --git-lfs && \
    repo sync -c -j$(nproc) --force-sync --no-clone-bundle --no-tags

# Set up build environment
WORKDIR ${ANDROID_BUILD_TOP}

# Build command (commented out - uncomment and run manually)
# RUN source build/envsetup.sh && \
#     breakfast d2x && \
#     brunch d2x

CMD ["/bin/bash"]
