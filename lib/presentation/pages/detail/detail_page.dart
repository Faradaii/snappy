import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snappy/domain/entities/story_entity.dart';
import 'package:snappy/presentation/bloc/detail_story/detail_story_bloc.dart';

import '../../../common/localizations/common.dart';
import '../../../common/utils/date_util.dart';

class DetailPage extends StatefulWidget {
  final String storyId;

  const DetailPage({super.key, required this.storyId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isOpenBottomSheet = false;

  @override
  Widget build(BuildContext context) {
    context.read<DetailStoryBloc>().add(GetDetailStoryEvent(widget.storyId));
    return BlocBuilder<DetailStoryBloc, DetailStoryState>(
      builder: (context, state) {
        return Scaffold(
          bottomSheet: (isOpenBottomSheet && state is DetailStorySuccessState) ? BuildMapsBottomSheet(story: state.detailStory) : null,
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

  Widget _buildBottomPart({
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
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              child: Image.network(
                detailStory.photoUrl,
                fit: BoxFit.fitWidth,
                width: double.infinity,
                alignment: Alignment.topCenter,
              ),
            ),
            if (detailStory.lat != null && detailStory.lon != null) _buildMapsMini(detailStory: detailStory, onTap: () => () => setState(() => isOpenBottomSheet = !isOpenBottomSheet)),
          ],
        ),
        Text(DateUtil.dateTimeToString(context, detailStory.createdAt)),
      ],
    );
  }

  Widget _buildMapsMini ({required Story detailStory, required Function onTap}) {
    final latlng = LatLng(detailStory.lat!, detailStory.lon!);
    return InkWell(
      onTap: onTap(),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(10),
        child: GoogleMap(initialCameraPosition: CameraPosition(target: latlng, zoom: 20),),
      ),
    );
  }
}

class BuildMapsBottomSheet extends StatefulWidget {
  final Story story;
  const BuildMapsBottomSheet({super.key, required this.story});

  @override
  State<BuildMapsBottomSheet> createState() => _BuildMapsBottomSheetState();
}

class _BuildMapsBottomSheetState extends State<BuildMapsBottomSheet> {
  late GoogleMapController mapController;
  late LatLng latlngStory;
  final Set<Marker> markers = {};
  bool isShowDetailMarker = false;

  @override
  void initState() {
    super.initState();

    latlngStory = LatLng(widget.story.lat!, widget.story.lon!);

    _buildMarkers();
  }

  void _buildMarkers() async {
    var imageUrl = widget.story.photoUrl;
    var dio = Dio();
    var bytes = await dio.get(imageUrl, options: Options(responseType: ResponseType.bytes));

    final customIcon = BitmapDescriptor.bytes(bytes.data);
    final marker = Marker(
      icon: customIcon,
      markerId: MarkerId(widget.story.name),
      position: latlngStory,
      onTap: () {
        mapController.animateCamera(
          CameraUpdate.newLatLngZoom(latlngStory, 20),
        );
        setState(() {
          isShowDetailMarker = !isShowDetailMarker;
        });
      },
    );
    markers.add(marker);
  }

  @override
  Widget build(BuildContext context) {
    final detailStory = widget.story;
    return BottomSheet(
      showDragHandle: true,
      onClosing: () {},
      builder: (context) =>
        Stack(
          children: [
            GoogleMap(
              markers: markers,
              initialCameraPosition: CameraPosition(target: latlngStory, zoom: 20),
              onMapCreated: (controller) {
                setState(() {
                  mapController = controller;
                });
                mapController.animateCamera(
                  CameraUpdate.newLatLngZoom(latlngStory, 20),
                );
              },
            ),
            _buildZoomButton(),
            if (isShowDetailMarker)
            FutureBuilder<Widget>(
              future: _buildDetailMarker(detailStory: detailStory, isShowDetailMarker: isShowDetailMarker),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                }
                return const Center(child: CircularProgressIndicator());
              },
            )
          ],
        )
  );
  }

  Widget _buildZoomButton() {
    return Positioned(
      top: 16,
      right: 16,
      child: Column(
        children: [
          FloatingActionButton.small(
            heroTag: "zoom-in",
            onPressed: () {
              mapController.animateCamera(
                CameraUpdate.zoomIn(),
              );
            },
            child: const Icon(Icons.add),
          ),
          FloatingActionButton.small(
            heroTag: "zoom-out",
            onPressed: () {
              mapController.animateCamera(
                CameraUpdate.zoomOut(),
              );
            },
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }

  Future<Widget> _buildDetailMarker({required Story detailStory, required bool isShowDetailMarker}) async {
    final info =
        await geo.placemarkFromCoordinates(latlngStory.latitude, latlngStory.longitude);
    final place = info[0];
    return Positioned(
      bottom: 16,
      right: 16,
      left: 16,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text("${place.name}"),
            Text("${place.street}"),
          ],
        ),
      ),
    );
  }
}
