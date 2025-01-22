import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hl_image_picker/hl_image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:snappy/presentation/bloc/add_story/add_story_bloc.dart';

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
              content: Text(state.message!),
            ),
          );
        }
        if (state is AddStorySuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message!),
          ));
          context.pop(true);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.addStory,
                style: Theme.of(context).textTheme.titleLarge),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                context.pop();
              },
            ),
          ),
          bottomNavigationBar: _buildUploadButton(state),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: imagePathState?.isEmpty ?? true
                      ? const Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.image,
                            size: 100,
                          ),
                        )
                      : _onShowImage(),
                ),
                Expanded(
                  child: Padding(
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
                ),
                _buildDescField(context)
              ],
            ),
          ),
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
        ? Image.network(imagePathState!)
        : Image.file(File(imagePathState!));
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
            _onUpload(context: context, description: description!.text.trim());
          }
        },
        style: ElevatedButton.styleFrom(
          fixedSize: Size(MediaQuery.of(context).size.width, 50),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
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
        ),
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
}
