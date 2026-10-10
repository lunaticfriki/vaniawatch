FROM dart:stable

WORKDIR /workspace
COPY core/ ./core/
WORKDIR /workspace/core

CMD ["sh", "-c", "dart pub get && dart analyze . && dart run test catalog/entities/__tests__/watch.entity_test.dart auth/value_objects/__tests__/email_address.value_object_test.dart auth/entities/__tests__/user.entity_test.dart"]