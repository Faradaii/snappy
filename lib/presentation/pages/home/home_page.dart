import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snappy/domain/entities/story_entity.dart';
import 'package:snappy/presentation/bloc/stories/story_bloc.dart';

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
  @override
  void initState() {
    super.initState();
    context.read<StoryBloc>().add(GetAllStoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoryBloc, StoryState>(
        listener: (BuildContext context, StoryState state) {
          if (state is StoryErrorState || state is StorySuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message!),
              ),
            );
          }
        },
        builder: (BuildContext context, StoryState state) {
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                elevation: 0,
                title: Image.asset("assets/snappy.png", fit: BoxFit.fill,
                  width: 60,
                  height: 60,),
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
                onPressed: () {
                  context.push(PageRouteName.add);
                },
                backgroundColor: Theme
                    .of(context)
                    .colorScheme
                    .primary,
                child: Icon(CupertinoIcons.scribble, color: Theme
                    .of(context)
                    .colorScheme
                    .onPrimary,),
              ),
              body: SafeArea(
                child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<StoryBloc>().add(
                          GetAllStoryEvent(forceRefresh: true));
                    },
                    child:
                    state is StorySuccessState
                        ? _buildListStory(context, state.listStory)
                        : state is StoryErrorState
                        ? Center(child: Text(state.message ?? 'Error'))
                        : const Center(child: CircularProgressIndicator())),
              ));
        }
    );
  }

  Widget _buildListStory(BuildContext context, List<Story> listStory) {
    return ListView.builder(
      shrinkWrap: false,
      itemCount: listStory.length,
      itemBuilder: (context, index) {
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
      {required BuildContext context, required String name, required DateTime dateCreated}) {
    return Row(
      spacing: 5,
      children: [
        Text(
            name,
            style: Theme
                .of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)
        ),
        Text(
            '•',
            style: Theme
                .of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold)
        ),
        Text(
            DateUtil.timeAgoSinceDate(dateCreated),
            style: Theme
                .of(context)
                .textTheme
                .bodySmall
        ),
      ],
    );
  }

  Widget _buildImage(
      {required String url, required BuildContext context, required double size, bool isCircle = false, bool isWidthInfinity = false, bool isHeightAuto = false}) {
    return ClipRRect(
        key: Key(url),
        borderRadius: isCircle ? BorderRadius.circular(100) : BorderRadius
            .circular(8),
        child: Builder(
            builder: (context) {
              return FutureBuilder<ImageInfo>(
                  future: ImageUtils.getImageNetworkInfo(url),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.connectionState == ConnectionState.none) {
                      return SizedBox(
                          height: size,
                          width: size,
                          child: Center(
                              child: CircularProgressIndicator(color: Theme
                                  .of(context)
                                  .colorScheme
                                  .primary)));
                    }

                    if (snapshot.hasData) {
                      double imageWidth = snapshot.data!.image.width.toDouble();
                      double imageHeight = snapshot.data!.image.height
                          .toDouble();
                      double aspectRatio = imageWidth / imageHeight;
                      double adjustedHeight = imageHeight > 500
                          ? size
                          : imageHeight;
                      double? computedHeight = !isHeightAuto &&
                          (aspectRatio < 1.0) ? adjustedHeight : null;

                      return CachedNetworkImage(
                        key: Key(url),
                        imageUrl: url,
                        fit: BoxFit.fitWidth,
                        width: isWidthInfinity ? double.infinity : size,
                        height: computedHeight,
                        alignment: Alignment.topCenter,
                      );
                    }

                    return SizedBox(height: size,
                        child: Center(child: Text('Error loading image')));
                  }
              );
            }
        ));
  }

  Widget _buildStoryItem(BuildContext context, List<Story> listStory,
      int index) {
    return InkWell(
      key: Key(listStory[index].id),
      onTap: () =>
      {
        context.push(PageRouteName.detail, extra: listStory[index].id)
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(
                url: "https://avatar.iran.liara.run/username?username=${listStory[index]
                    .name}",
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
                      context: context
                  ),
                  Text(listStory[index].description, maxLines: 3,
                    overflow: TextOverflow.ellipsis,),
                  const SizedBox(height: 4),
                  if (listStory[index].photoUrl.isNotEmpty)
                    _buildImage(
                        url: listStory[index].photoUrl,
                        context: context,
                        isHeightAuto: true,
                        size: 400
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    context.read<SharedPreferenceBloc>().add(SharedPreferenceInitEvent());
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
            backgroundColor: Theme
                .of(context)
                .colorScheme
                .onSecondary,
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildImage(
                            url: "https://avatar.iran.liara.run/username?username=${state
                                .savedUser?.name}",
                            context: context,
                            isCircle: true,
                            size: 60
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
                              state.savedUser?.name ?? 'User',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                  color: Theme
                                      .of(context)
                                      .colorScheme
                                      .onSecondary),
                            ),
                            Text(state.savedUser?.email ?? 'Email',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                    color: Theme
                                        .of(context)
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
                      Text('Logout',
                          style: Theme
                              .of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                              color:
                              Theme
                                  .of(context)
                                  .colorScheme
                                  .primary)),
                    ],
                  ),
                  onTap: () {
                    context.read<SharedPreferenceBloc>().add(
                        SharedPreferenceSetSavedUserEvent(null));
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
