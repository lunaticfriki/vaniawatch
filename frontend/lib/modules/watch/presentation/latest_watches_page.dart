import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/modules/watch/application/query/list_watches_query.dart';
import 'package:frontend/modules/watch/application/watch_read_service.dart';
import 'package:frontend/modules/watch/presentation/cubit/watch_list_cubit.dart';
import 'package:frontend/modules/watch/presentation/cubit/watch_list_state.dart';
import 'package:frontend/modules/watch/presentation/latest_watches_view.dart';
import 'package:frontend/modules/watch/presentation/watch_list_skeleton.dart';
import 'package:frontend/modules/watch/presentation/watch_list_failure_view.dart';
import 'package:frontend/shared/presentation/app_routes.dart';
import 'package:go_router/go_router.dart';

class LatestWatchesPage extends StatelessWidget {
  const LatestWatchesPage({super.key});

  static const int count = 5;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WatchListCubit(context.read<WatchReadService>())
            ..load(ListWatchesQuery.latest(count)),
      child: LatestWatchesPageBody(
        onSeeAll: () => GoRouter.maybeOf(context)?.go(AppRoutes.watches),
      ),
    );
  }
}

class LatestWatchesPageBody extends StatelessWidget {
  const LatestWatchesPageBody({required this.onSeeAll, super.key});

  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchListCubit, WatchListState>(
      builder: (context, state) => switch (state) {
        WatchListLoading() => const WatchListSkeleton(
          count: LatestWatchesPage.count,
        ),
        WatchListFailure() => WatchListFailureView(
          onRetry: () => context.read<WatchListCubit>().load(
            ListWatchesQuery.latest(LatestWatchesPage.count),
          ),
        ),
        WatchListLoaded(:final watches) => LatestWatchesView(
          watches: watches,
          onSeeAll: onSeeAll,
        ),
      },
    );
  }
}
