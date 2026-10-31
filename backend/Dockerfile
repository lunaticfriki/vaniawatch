FROM dart:stable AS build

RUN dart pub global activate dart_frog_cli

WORKDIR /app
COPY core/pubspec.yaml core/
COPY backend/pubspec.yaml backend/pubspec.lock backend/
RUN cd backend && dart pub get

COPY core core
COPY backend backend

WORKDIR /app/backend
RUN dart pub get --offline \
  && dart pub global run dart_frog_cli:dart_frog build

WORKDIR /app/backend/build
RUN dart pub get && dart compile exe bin/server.dart -o bin/server

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/backend/build/bin/server /app/bin/server

ENV PORT=8080
EXPOSE 8080
CMD ["/app/bin/server"]
