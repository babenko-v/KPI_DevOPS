FROM alpine AS build
RUN apk add --no-cache build-base automake autoconf git pkgconfig glib-dev gtest-dev gtest cmake

WORKDIR /home/optima
RUN git clone --branch branchHTTPservMutli https://github.com/babenko-v/KPI_DevOPS.git
WORKDIR /home/optima/KPI_DevOPS


RUN autoconf

RUN ./configure

RUN cmake


FROM alpine
COPY --from=build /home/optima/KPI_DevOPS/myprogram /usr/local/bin/myprogram
ENTRYPOINT ["/usr/local/bin/myprogram"]
