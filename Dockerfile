FROM adoptopenjdk/openjdk11:alpine

COPY ./target/TMF622-*.jar /app/TMF622.jar
COPY ./target/classes/OAT /app/OAT
COPY ./target/classes/common /app/common
COPY ./src/test/testCases /app/testCases
WORKDIR /app

# add user and use the user to run application
RUN addgroup demo && adduser -DH -G demo demo

# Chown all the files to the app user.
RUN chown -R demo:demo /app

USER demo

EXPOSE 8080/tcp

ENV OAT001.file.path=/app/OAT/blm-config-OAT001.xml
ENV mbms.cache.path.morder=/app/testCases/M1/mOrder/111,/app/testCases/M1/mOrder/AND,/app/testCases/M2/mOrder/6A6,/app/testCases/M2/mOrder/6A9,/app/testCases/M2/mOrder/11H,/app/testCases/M2/mOrder/11P
ENV mbms.cache.path.tmf620=/app/testCases/M1/NPM,/app/testCases/M2/NPM,/app/testCases/Extra/NPM
ENV mbms.cache.path.forder=/app/testCases/M2/fOrder
ENV TZ=Asia/Taipei
ENV JAVA_OPTS=""

ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS  -DORDER_SYS_CONFIG=/app/OAT  -jar  /app/TMF622.jar"]
