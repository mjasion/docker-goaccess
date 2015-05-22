FROM ubuntu:latest

RUN   echo "Europe/Warsaw" > /etc/timezone && \
      dpkg-reconfigure --frontend noninteractive tzdata
RUN apt-get update && apt-get install -y wget && apt-get clean

RUN echo "deb http://deb.goaccess.io $(lsb_release -cs) main" | tee -a /etc/apt/sources.list
RUN wget -O - http://deb.goaccess.io/gnugpg.key | apt-key add -
RUN apt-get update && apt-get install -y goaccess && apt-get clean

RUN echo '' >> /etc/goaccess.conf && \
    echo 'time-format %H:%M:%S' >> /etc/goaccess.conf && \
    echo 'date-format %d/%b/%Y' >> /etc/goaccess.conf && \
    echo 'log-format %h %^[%d:%t %^] "%r" %s %b "%R" "%u"' >> /etc/goaccess.conf
