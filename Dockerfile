FROM alpine:latest AS build
RUN apk add --no-cache libstdc++ libc6-compat build-base make automake autoconf git pkgconfig glib-dev cmake glib-dev gtest-dev gtest libgcc perl

WORKDIR /home/build
RUN git clone --branch branchHTTPserver https://github.com/babenko-v/KPI_DevOPS.git
WORKDIR /home/build/KPI_DevOPS


RUN autoconf

RUN ./configure

RUN make



FROM alpine
RUN apk add --no-cache libstdc++ libc6-compat
COPY --from=build /home/build/KPI_DevOPS/myprogram /usr/local/bin/myprogram
ENTRYPOINT ["/usr/local/bin/myprogram", "--server"]
