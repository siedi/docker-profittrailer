FROM openjdk:8-jre-alpine

LABEL maintainer="https://github.com/siedi"

RUN apk add --no-cache curl \
    unzip \
    jq

RUN mkdir -p /opt && \
    URL=$(curl -s https://api.github.com/repos/taniman/profit-trailer/releases | jq -r '.[0].assets[0].browser_download_url') && \
    curl -Ls "$URL" > /opt/profittrailer.zip && \
    unzip -q /opt/profittrailer.zip -d /opt && \
    rm /opt/profittrailer.zip

EXPOSE 8081

ENV SERVER_TIMEZONEOFFSET +00:00
ENV SERVER_SITENAME ProfitTrailer
ENV SERVER_PASSWORD MyVeryOwnPassword
ENV TRADING_LOGHISTORY 8
ENV SPRING_PROFILES_ACTIVE prod

WORKDIR /opt/ProfitTrailer/

COPY application.template /opt/ProfitTrailer/
COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["java", "-jar", "ProfitTrailer.jar", "-XX:+UseConcMarkSweepGC", "-Xmx512m", "-Xms512m"]
