import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoGallery extends StatefulWidget {
  const PhotoGallery({Key? key}) : super(key: key);

  @override
  State<PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  bool loading = false;
  late List<AssetEntity> entities;
  // late List<AssetEntity> imageEntities;

  Future<void> _requestAssets() async {
    setState(() {
      loading = true;
    });
    await PhotoManager.requestPermissionExtend();
    // ignore: avoid_print
    print("persission granted");
    setState(() {
      loading = false;
    });
  }

  Future<void> _loadAsset() async {
    setState(() {
      loading = true;
    });
    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList();
    entities = await paths.first.getAssetListPaged(page: 0, size: 80);
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    _requestAssets();
    _loadAsset();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        loading
            ? const CircularProgressIndicator.adaptive()
            : galleryBuilder(entities)
      ],
    );
  }
}

galleryBuilder(entities) {
  int totalImages = 15;
  return SizedBox(
    width: double.infinity,
    height: 200,
    child: GridView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
      ),
      itemCount: totalImages + 1,
      itemBuilder: (context, index) {
        return Container(
          decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: index < totalImages
                ? GestureDetector(
                    onTap: () {}, //redirect to edit page
                    child: Image(
                      image: customImage(
                        entities[index],
                      ),
                    ),
                  )
                : lastImage(
                    entities[index],
                  ),
          ),
        );
      },
    ),
  );
}

lastImage(assetEntity) {
  return Stack(
    children: [
      Image(image: customImage(assetEntity)),
      Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 74, 157, 112).withOpacity(0.8),
              borderRadius: BorderRadius.circular(15)),
          child: const Text(
            "+ More..",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ),
    ],
  );
}

customImage(assetEntity) {
  return AssetEntityImageProvider(
    assetEntity,
    // isOriginal: false,
    thumbnailSize: const ThumbnailSize.square(90),
    thumbnailFormat: ThumbnailFormat.jpeg,
  );
}
