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
  late GoogleMapController mapController;
  bool isOpenBottomSheet = false;

  @override
  void initState() {
    super.initState();
    context.read<DetailStoryBloc>().add(GetDetailStoryEvent(widget.storyId));
  }

  @override
  Widget build(BuildContext context) {
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
            if (detailStory.lat != null && detailStory.lon != null)
              _buildMiniMaps(
                  detailStory: detailStory,
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                      enableDrag: true,
                      showDragHandle: true,
                      useSafeArea: true,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => BuildMapsBottomSheet(
                        story: detailStory,
                        mapController: mapController,
                      ),
                    );
                  }),
          ],
        ),
        Text(DateUtil.dateTimeToString(context, detailStory.createdAt)),
      ],
    );
  }

  Widget _buildMiniMaps({required Story detailStory, required Function onTap}) {
    final LatLng latlng = LatLng(detailStory.lat!, detailStory.lon!);
    final marker = {
      Marker(
        markerId: MarkerId(detailStory.name),
        position: latlng,
      )
    };
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.all(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          onTap();
        },
        child: IgnorePointer(
          ignoring: true,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: GoogleMap(
                markers: marker,
                onMapCreated: (controller) {
                  setState(() {
                    mapController = controller;
                  });
                  mapController.animateCamera(
                    CameraUpdate.newLatLngZoom(latlng, 10),
                  );
                },
                initialCameraPosition:
                    CameraPosition(target: latlng, zoom: 1000),
                zoomControlsEnabled: false),
          ),
        ),
      ),
    );
  }
}

class BuildMapsBottomSheet extends StatefulWidget {
  final Story story;
  GoogleMapController mapController;
  BuildMapsBottomSheet(
      {super.key, required this.story, required this.mapController});

  @override
  State<BuildMapsBottomSheet> createState() => _BuildMapsBottomSheetState();
}

class _BuildMapsBottomSheetState extends State<BuildMapsBottomSheet> {
  late LatLng latlngStory;
  late geo.Placemark place;
  final Set<Marker> markers = {};
  bool isShowDetailMarker = false;

  @override
  void initState() {
    super.initState();

    latlngStory = LatLng(widget.story.lat!, widget.story.lon!);

    _buildMarkers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _buildMarkers() async {
    final info = await geo.placemarkFromCoordinates(
        latlngStory.latitude, latlngStory.longitude);
    place = info[0];

    final marker = Marker(
      markerId: MarkerId(widget.story.name),
      position: latlngStory,
      infoWindow: InfoWindow(
          title: widget.story.name, snippet: place.administrativeArea),
      onTap: () {
        show();
      },
    );
    setState(() {
      markers.add(marker);
    });
  }

  void show() {
    showModalBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        useSafeArea: true,
        enableDrag: true,
        isScrollControlled: true,
        context: context,
        builder: (context) => Container(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "${place.name}",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "${place.street}, ${place.name}, ${place.administrativeArea} - ${place.country}",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    Divider(),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      child: Image.network(
                        widget.story.photoUrl,
                        fit: BoxFit.fitWidth,
                        width: double.infinity,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SizedBox(
          width: MediaQuery.of(context).size.width - 10, child: _buildMaps()),
    ));
  }

  _buildMaps() {
    return GoogleMap(
      markers: markers,
      initialCameraPosition: CameraPosition(target: latlngStory, zoom: 15),
    );
  }
}
