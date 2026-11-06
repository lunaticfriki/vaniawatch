import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/modules/watch/application/query/list_watches_query.dart';
import 'package:frontend/modules/watch/application/watch_read_service.dart';
import 'package:frontend/modules/watch/presentation/cubit/watch_list_cubit.dart';
import 'package:frontend/modules/watch/presentation/cubit/watch_list_state.dart';
import 'package:frontend/modules/watch/presentation/watch_list_skeleton.dart';
import 'package:frontend/modules/watch/presentation/watch_list_failure_view.dart';
import 'package:frontend/modules/watch/presentation/watch_list_view.dart';

class WatchListPage extends StatelessWidget {
  const WatchListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WatchListCubit(context.read<WatchReadService>())
            ..load(ListWatchesQuery.all()),
      child: const WatchListPageBody(),
    );
  }
}

class WatchListPageBody extends StatelessWidget {
  const WatchListPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchListCubit, WatchListState>(
      builder: (context, state) => switch (state) {
        WatchListLoading() => const WatchListSkeleton(),
        WatchListFailure() => WatchListFailureView(
          onRetry: () =>
              context.read<WatchListCubit>().load(ListWatchesQuery.all()),
        ),
        WatchListLoaded(:final watches) => WatchListView(watches: watches),
      },
    );
  }
}
