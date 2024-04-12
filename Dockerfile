FROM Maven as build
WOKRDIR /app
COPY . .
RUN mvn install

FROM openjdk:11.0
WORKDIR /app
COPY --=build /app/targer/Uber.jar /app/
EXPOSE 9090
CMD ["java","jar","Uber.jar"]