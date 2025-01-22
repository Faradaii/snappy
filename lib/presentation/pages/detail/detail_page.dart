import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snappy/domain/entities/story_entity.dart';
import 'package:snappy/presentation/bloc/detail_story/detail_story_bloc.dart';

import '../../../common/localizations/common.dart';
import '../../../common/utils/date_util.dart';

class DetailPage extends StatelessWidget {
  final String storyId;

  const DetailPage({super.key, required this.storyId});

  @override
  Widget build(BuildContext context) {
    context.read<DetailStoryBloc>().add(GetDetailStoryEvent(storyId));
    return BlocBuilder<DetailStoryBloc, DetailStoryState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.story,
                style: Theme.of(context).textTheme.titleLarge),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                context.pop();
              },
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: state is DetailStorySuccessState
                  ? _buildDetailStory(context, state.detailStory)
                  : state is DetailStoryErrorState
                      ? Center(child: Text(state.message!))
                      : const Center(child: CircularProgressIndicator()),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailStory(BuildContext context, Story detailStory) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTopPart(detailStory: detailStory, context: context),
          _buildBottomPart(detailStory: detailStory, context: context),
        ],
      ),
    );
  }

  Widget _buildTopPart({
    required Story detailStory,
    required BuildContext context,
  }) {
    return Row(
      spacing: 10,
      children: [
        Image.network(
          "https://avatar.iran.liara.run/username?username=${detailStory.name}",
          fit: BoxFit.cover,
          width: 50,
          height: 50,
          alignment: Alignment.topCenter,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              detailStory.name,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              DateUtil.timeAgoSinceDate(context, detailStory.createdAt),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }

  _buildBottomPart({
    required Story detailStory,
    required BuildContext context,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Text(
          detailStory.description,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: Image.network(
            detailStory.photoUrl,
            fit: BoxFit.fitWidth,
            width: double.infinity,
            alignment: Alignment.topCenter,
          ),
        ),
        Text(DateUtil.dateTimeToString(context, detailStory.createdAt)),
      ],
    );
  }
}
