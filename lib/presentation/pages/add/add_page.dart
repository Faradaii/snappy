import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:go_router/go_router.dart';
import 'package:hl_image_picker/hl_image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:snappy/config/flavor/flavor_config.dart';
import 'package:snappy/config/route/router.dart';
import 'package:snappy/presentation/bloc/add_story/add_story_bloc.dart';
import 'package:snappy/presentation/pages/add/add_location_story.dart';

import '../../../common/localizations/common.dart';
import '../../widgets/custom_text_field.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? imagePathState;
  TextEditingController? description;
  double? lat;
  double? lon;
  geo.Placemark? place;

  @override
  void initState() {
    description = TextEditingController(text: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddStoryBloc, AddStoryState>(
      listener: (context, state) {
        if (state is AddStoryErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.failedAddStory),
            ),
          );
        }
        if (state is AddStorySuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!.successAddStory),
          ));
          context.pop(true);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.addStory,
                    style: Theme.of(context).textTheme.titleLarge),
                if (FlavorConfig.instance.flavor == FlavorType.premium)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(AppLocalizations.of(context)!.withPro,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary)),
                  )
              ],
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                context.pop();
              },
            ),
          ),
          bottomNavigationBar: _buildUploadButton(state),
          body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
                child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  imagePathState?.isEmpty ?? true
                      ? const Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.image,
                            size: 300,
                          ),
                        )
                      : _onShowImage(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildImagePickerButton(context, () async {
                          _onGalleryView(context);
                        }, AppLocalizations.of(context)!.gallery),
                        _buildImagePickerButton(context, () async {
                          _onCameraView(context);
                        }, AppLocalizations.of(context)!.camera),
                      ],
                    ),
                  ),
                  _buildDescField(context),
                  if (FlavorConfig.instance.flavor == FlavorType.premium)
                    _buildAddLocation(context),
                ],
              ),
            ));
          })),
        );
      },
    );
  }

  _onGalleryView(BuildContext context) async {
    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isMobile = (isAndroid || isiOS);

    final ImagePicker imagePicker = ImagePicker();

    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      var imagePath = image.path;
      if (isMobile) {
        final cropper = HLImagePicker();
        final cropped = await cropper.openCropper(image.path,
            cropOptions: const HLCropOptions(aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio16x9,
            ]));
        if (cropped.path.isNotEmpty) imagePath = cropped.path;
      }
      setState(() {
        imagePathState = imagePath;
      });
      if (context.mounted) {
        context.read<AddStoryBloc>().add(AddStoryImagePickEvent(imagePath));
      }
    }
  }

  _onCameraView(BuildContext context) async {
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isMobile = (isAndroid || isiOS);
    if (!isMobile) return;

    final ImagePicker imagePicker = ImagePicker();

    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.camera);

    if (image != null) {
      var imagePath = image.path;
      if (isMobile) {
        final cropper = HLImagePicker();
        final cropped = await cropper.openCropper(image.path,
            cropOptions: HLCropOptions(aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio16x9,
            ]));
        if (cropped.path.isNotEmpty) imagePath = cropped.path;
      }
      setState(() {
        imagePathState = imagePath;
      });
      if (context.mounted) {
        context.read<AddStoryBloc>().add(AddStoryImagePickEvent(imagePath));
      }
    }
  }

  Widget _onShowImage() {
    return kIsWeb
        ? Image.network(
            imagePathState!,
          )
        : Image.file(
            File(imagePathState!),
          );
  }

  _onUpload(
      {required BuildContext context,
      required String description,
      double? lat,
      double? lon}) async {
    if (imagePathState?.isNotEmpty ?? false) {
      try {
        final compressedImage = await _compressImage(imagePathState!);
        if (context.mounted) {
          context.read<AddStoryBloc>().add(AddStorySubmitEvent(
                description: description,
                photo: compressedImage,
                lat: lat,
                lon: lon,
              ));
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(AppLocalizations.of(context)!.failedUploadImage)),
          );
        }
      }
    }
  }

  Future<List<int>> _compressImage(String imagePath) async {
    final file = File(imagePath);
    final bytes = await file.readAsBytes();

    int imageLength = bytes.length;
    if (imageLength < 1000000) return bytes;
    final img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;
    int compressQuality = 100;
    int length = imageLength;
    List<int> newByte = [];
    do {
      compressQuality -= 10;
      newByte = img.encodeJpg(
        image,
        quality: compressQuality,
      );
      length = newByte.length;
    } while (length > 1000000);
    return newByte;
  }

  Widget _buildUploadButton(state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        onPressed: () {
          if (state is AddStoryLoadingState) {
            null;
          } else if (_formKey.currentState!.validate() &&
              imagePathState!.isNotEmpty) {
            _onUpload(
                context: context,
                description: description!.text.trim(),
                lat: lat,
                lon: lon);
          }
        },
        style: ElevatedButton.styleFrom(
            fixedSize: Size(MediaQuery.of(context).size.width, 50),
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
        child: state is AddStoryLoadingState
            ? CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary)
            : Text(
                AppLocalizations.of(context)!.upload,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 20,
                ),
              ),
      ),
    );
  }

  Widget _buildImagePickerButton(
      BuildContext context, void Function() onPressed, String text) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
        child: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildDescField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: CustomTextField(
          controller: description,
          maxLines: 8,
          hintText: AppLocalizations.of(context)!.descriptionUploadStoryHint,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.pleaseFillDescription;
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildAddLocation(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            (place != null)
                ? Expanded(
                    child: Text(
                        "${place?.street}, ${place?.name}, ${place?.administrativeArea} - ${place?.country} ${place?.postalCode}"))
                : SizedBox.shrink(),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final PlaceWithLatLng? result =
                      await context.push(PageRouteName.addLocation);
                  if (result != null) {
                    setState(() {
                      lat = result.latLng.latitude;
                      lon = result.latLng.longitude;
                      place = result.place;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                child: Text(
                  (place == null)
                      ? AppLocalizations.of(context)!.addLocation
                      : AppLocalizations.of(context)!.pickAnother,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            if (place != null)
              IconButton(
                onPressed: () {
                  setState(() {
                    lat = null;
                    lon = null;
                    place = null;
                  });
                },
                icon: Icon(
                  Icons.delete_rounded,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
          ],
        ));
  }
}
