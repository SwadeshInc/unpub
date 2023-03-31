FROM dart:stable AS build

WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

COPY . .

RUN dart pub get --offline
RUN dart compile exe unpub/bin/unpub.dart -o bin/unpub

FROM scratch

ENV HOST 0.0.0.0
ENV PORT 4000
ENV DATABASE mongodb://localhost:27017/dart_pub
ENV PROXY

COPY --from=build /runtime/ /
COPY --from=build /app/bin/unpub /app/bin/

EXPOSE 80
CMD ["sh", "-c", "/app/bin/unpub --host $HOST --port $PORT --database $DATABASE --proxy-origin $PROXY"]
