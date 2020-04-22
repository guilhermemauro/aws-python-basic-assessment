FROM alpine AS builder
# install latest version of graphviz, apk has only 2.38 verison
# get build-essential to build programs
RUN apk --update add gcc make g++ zlib-dev
RUN apk add --no-cache --update python3 python3-dev
RUN pip3 install --upgrade pip setuptools virtualenv
RUN apk --no-cache add freetype-dev

#create env to use in next stage and install dependencies
RUN python3 -m venv /tmp/venv
RUN /tmp/venv/bin/pip --no-cache-dir install -U wheel --user
RUN /tmp/venv/bin/pip install cython
RUN /tmp/venv/bin/pip install matplotlib graphviz

# download latest graphviz and unconpressing
RUN wget https://www2.graphviz.org/Packages/stable/portable_source/graphviz-2.44.0.tar.gz && \
    tar xvzf graphviz-2.44.0.tar.gz && \

# configure, build and install in tmp folder
cd graphviz-2.44.0 && \
    ./configure && \
    make && \
    make install DESTDIR=/tmp

# get cleaned alpine version to keep small container
FROM alpine:latest AS prod

# get graphviz from builder stage
COPY --from=builder /tmp/usr /usr
RUN mkdir /usr/.venv

# get venv from previous stage
COPY --from=builder /tmp/venv /usr/.venv

# install python, because venv using link and other matplotlib dependencies
RUN apk add --no-cache --update python3 freetype-dev g++

ENTRYPOINT ["/usr/.venv/bin/python3"]
