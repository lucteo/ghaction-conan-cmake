FROM debian:buster

# install debian packages:
ENV DEBIAN_FRONTEND=noninteractive
RUN set -x -e; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        # build
        cmake pkg-config make gcc g++ \
        # conan
        python3 python3-pip python3-setuptools \
        # coverage report
        curl \
        # clang and tools
        clang clang-tidy clang-format \
        # used by clang-format
        git \
        # ctest -D ExperimentalMemCheck
        valgrind \
        # base system (su)
        util-linux
# instal conan from pip
RUN python3 -m pip install conan

# setup su for dep installation
RUN sed -i '/pam_rootok.so$/aauth sufficient pam_permit.so' /etc/pam.d/su

ADD entrypoint /usr/local/bin/entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint"]
