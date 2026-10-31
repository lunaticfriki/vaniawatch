import 'package:backend/shared/http/request_user_middleware.dart';
import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) => handler.use(requestUserMiddleware());
