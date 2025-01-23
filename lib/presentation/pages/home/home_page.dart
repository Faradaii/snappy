import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snappy/domain/entities/story_entity.dart';
import 'package:snappy/presentation/bloc/stories/story_bloc.dart';
import 'package:snappy/presentation/widgets/flag_language.dart';
import 'package:snappy/presentation/widgets/rotating_widget.dart';

import '../../../common/localizations/common.dart';
import '../../../common/utils/date_util.dart';
import '../../../common/utils/image_network_util.dart';
import '../../../config/route/router.dart';
import '../../bloc/shared_preferences/shared_preference_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController scrollController = ScrollController();
  late final StoryBloc storyBloc;

  @override
  void initState() {
    super.initState();
    storyBloc = context.read<StoryBloc>();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        if (storyBloc.state.page != null) {
          _loadStories();
        }
      }
    });
    _loadStories();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _loadStories({bool forceRefresh = false}) {
    context
        .read<StoryBloc>()
        .add(GetAllStoryEvent(forceRefresh: forceRefresh));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryBloc, StoryState>(
        builder: (BuildContext context, StoryState state) {
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            title: RotatingWidget(
              radius: 0,
              widget: Image.asset(
                "assets/snappy.png",
                fit: BoxFit.fill,
                width: 60,
                height: 60,
              ),
            ),
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
          ),
          drawer: _buildDrawer(context),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final shouldRefresh = await context.push(PageRouteName.add);
              if (shouldRefresh == true) {
                _loadStories(forceRefresh: true);
              }
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(
              CupertinoIcons.scribble,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          body: SafeArea(
              child: RefreshIndicator(
                  onRefresh: () async {
                    context
                        .read<StoryBloc>()
                        .add(GetAllStoryEvent(forceRefresh: true));
                  },
                  child: state is StoryErrorState
                      ? Center(
                          child: Text(state.message ??
                              AppLocalizations.of(context)!.error))
                      : _buildListStory(context, state.listStory!))));
    });
  }

  Widget _buildListStory(BuildContext context, List<Story> listStory) {
    return ListView.builder(
      controller: scrollController,
      shrinkWrap: false,
      itemCount: listStory.length + (storyBloc.state.page != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == listStory.length && storyBloc.state.page != null) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (listStory.isEmpty) {
          return Center(
            child: Text(AppLocalizations.of(context)!.noStory,
                style: Theme.of(context).textTheme.titleLarge),
          );
        }

        return Column(
          children: [
            _buildStoryItem(context, listStory, index),
            const Divider(),
          ],
        );
      },
    );
  }

  Widget _buildNameAndDate(
      {required BuildContext context,
      required String name,
      required DateTime dateCreated}) {
    return Row(
      spacing: 5,
      children: [
        Text(name,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        Text('•',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        Text(DateUtil.timeAgoSinceDate(context, dateCreated),
            style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildImage(
      {required String url,
      required BuildContext context,
      required double size,
      bool isCircle = false,
      bool isWidthInfinity = false}) {
    return ClipRRect(
        key: Key(url),
        borderRadius:
            isCircle ? BorderRadius.circular(100) : BorderRadius.circular(8),
        child: Builder(builder: (context) {
          return FutureBuilder<ImageInfo>(
              future: ImageUtils.getImageNetworkInfo(url),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.connectionState == ConnectionState.none) {
                  return SizedBox(
                      height: size,
                      width: size,
                      child: Center(
                          child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.primary)));
                }

                if (snapshot.hasData) {
                  return CachedNetworkImage(
                    key: Key(url),
                    cacheKey: url,
                    imageUrl: url,
                    fit: BoxFit.cover,
                    width: isWidthInfinity ? double.infinity : size,
                    height: size,
                    alignment: Alignment.topCenter,
                  );
                }

                return SizedBox(
                    height: size,
                    child: Center(
                        child: Text(
                      AppLocalizations.of(context)!.errorImage,
                    )));
              });
        }));
  }

  Widget _buildStoryItem(
      BuildContext context, List<Story> listStory, int index) {
    return InkWell(
      key: Key(listStory[index].id),
      onTap: () =>
          {context.push(PageRouteName.detail, extra: listStory[index].id)},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(
                url:
                    "https://avatar.iran.liara.run/username?username=${listStory[index].name}",
                context: context,
                isCircle: true,
                size: 40),
            Expanded(
              child: Column(
                spacing: 2,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildNameAndDate(
                      name: listStory[index].name,
                      dateCreated: listStory[index].createdAt,
                      context: context),
                  Text(
                    listStory[index].description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (listStory[index].photoUrl.isNotEmpty)
                    _buildImage(
                        url: listStory[index].photoUrl,
                        context: context,
                        size: 400)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return BlocConsumer<SharedPreferenceBloc, SharedPreferenceState>(
      listener: (context, state) {
        if (state is SharedPreferenceLoadedState) {
          if (state.savedUser == null) {
            context.go(PageRouteName.login);
          }
        }
      },
      builder: (context, state) {
        if (state is SharedPreferenceLoadedState) {
          return Drawer(
            backgroundColor: Theme.of(context).colorScheme.onSecondary,
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FlagLanguage(),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: _buildImage(
                              url:
                                  "https://avatar.iran.liara.run/username?username=${state.savedUser?.name}",
                              context: context,
                              isCircle: true,
                              size: 60),
                        ),
                      ),
                      Expanded(
                        flex: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              state.savedUser?.name ??
                                  AppLocalizations.of(context)!.user,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary),
                            ),
                            Text(
                                state.savedUser?.email ??
                                    AppLocalizations.of(context)!.emailAddress,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Row(
                    children: [
                      Container(
                          margin: const EdgeInsets.all(5),
                          child: const Icon(Icons.logout_outlined)),
                      Text(AppLocalizations.of(context)!.logout,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                    ],
                  ),
                  onTap: () {
                    context
                        .read<SharedPreferenceBloc>()
                        .add(SharedPreferenceSetSavedUserEvent(null));
                  },
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
