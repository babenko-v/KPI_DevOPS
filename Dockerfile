FROM alpine:latest AS build
RUN apk add --no-cache build-base make automake=1.16.5-r0 perl autoconf git pkgconfig glib-dev cmake libstdc++ libgcc

WORKDIR /home/build
RUN git clone --branch branchHTTPserver https://github.com/babenko-v/KPI_DevOPS.git
WORKDIR /home/build/KPI_DevOPS


RUN autoconf

RUN ./configure

RUN make


FROM alpine
COPY --from=build /home/build/KPI_DevOPS/myprogram /usr/local/bin/myprogram
ENTRYPOINT ["/usr/local/bin/myprogram"]
