import 'package:backend/shared/http/error_middleware.dart';
import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) => handler.use(errorMiddleware());
