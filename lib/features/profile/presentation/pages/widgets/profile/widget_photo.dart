import 'package:appdriver/core/utils/colors.dart';
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WidgetPhoto extends StatelessWidget {
  final String urlPhoto;
  final bool hasTitle;
  final bool header;
  final String type;
  final String? title;
  final String showModalTitle;
  final VoidCallback? cameraPhoto;
  final VoidCallback? galleryPhoto;
  final VoidCallback? removePhoto;
  final double width;
  final double height;
  const WidgetPhoto({
    Key? key,
    required this.urlPhoto,
    this.hasTitle = false,
    this.title,
    required this.showModalTitle,
    this.galleryPhoto,
    this.cameraPhoto,
    this.removePhoto,
    this.header = true,
    required this.type,
    this.width = 100,
    this.height = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Visibility(
          visible: header,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // CircleAvatar(
                  //   radius: 20,
                  //   backgroundImage: NetworkImage('https://i.pravatar.cc/150'),
                  //   backgroundColor: Colors.transparent,
                  // ),
                  Text(
                    showModalTitle,
                    style: GoogleFonts.montserrat(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                  (urlPhoto.isNotEmpty)
                      ? widgetAddPhoto(
                          context: context,
                          child: Text(
                            'Editar',
                            style: GoogleFonts.montserrat(fontSize: 16, color: primaryColor, fontWeight: FontWeight.w400),
                          ),
                        )
                      : Container(),
                ],
              ),
              const SizedBox(
                height: 19,
              ),
            ],
          ),
        ),
        Column(
          children: [
            Stack(
              children: [
                Visibility(
                  visible: urlPhoto.isNotEmpty,
                  child: CachedNetworkImage(
                    imageUrl: urlPhoto ,
                    imageBuilder: (context, imageProvider) => Container(
                      width: width,
                      height: height,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xFFD9D9D9),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 0), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(11),
                        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      width: width,
                      height: height,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xFFD9D9D9),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 0), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(25),
                        child: const CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          strokeWidth: 5.0,
                          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.transparent,
                        ),
                        image: const DecorationImage(
                          image: ExactAssetImage('assets/user.jpg'),
                          fit: BoxFit.cover,
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                  ),
                  replacement: widgetAddPhoto(
                    context: context,
                    child: widgetEmptyAddPhoto(
                      width: width,
                      height: height,
                    ),
                  ),
                ),
                Visibility(
                  visible: urlPhoto.isNotEmpty,
                  replacement: const SizedBox.shrink(),
                  child: Positioned(
                    top: 0.0,
                    right: 0.0,
                    child: widgetRemovePhoto(
                      type: type,
                      context: context,
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: hasTitle,
              child: Column(
                children: [
                  const SizedBox(
                    height: 7,
                  ),
                  widgetAddPhoto(
                    context: context,
                    child: Text(
                      urlPhoto.isEmpty ? 'Anverso' : 'Cambiar anverso',
                      style: GoogleFonts.montserrat(fontSize: 16, color: primaryColor, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Container widgetEmptyAddPhoto({double width = 150, double height = 100}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFD9D9D9),
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
      ),
      child: const Center(
        child: SizedBox(
          height: 50,
          width: 50,
          child: Icon(
            Icons.add_circle_outline,
            color: primaryColor,
            size: 50,
          ),
        ),
      ),
    );
  }

  Widget widgetRemovePhoto({String? type, required BuildContext context}) {
    return FloatingActionButton(
      child: const Icon(
        Icons.close,
        color: Colors.red,
      ),
      onPressed: () async {
        await showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(38), topRight: Radius.circular(38)),
          ),
          context: context,
          builder: (BuildContext context) {
            return Container(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '¿Está seguro que quiere eliminar esta foto?',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff242424),
                    ),
                  ),
                  const SizedBox(
                    height: 19,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RoundedButton(
                          backgroundColor: const Color(0xffFAFAFA),
                          borderColor: const Color(0xffD9D9D9),
                          textColor: Colors.black,
                          // loading: state.formStatus is FormSubmitting ? true : false,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          label: 'Cancelar',
                        ),
                      ),
                      const SizedBox(
                        width: 19,
                      ),
                      Expanded(
                        child: RoundedButton(
                          // loading: state.formStatus is FormSubmitting ? true : false,
                          onPressed: removePhoto,
                          label: 'Si, eliminar',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
      backgroundColor: Colors.white,
      mini: true,
      elevation: 5.0,
    );
  }

  Widget widgetAddPhoto({Widget? child, required BuildContext context}) {
    return GestureDetector(
      onTap: () async {
        await showModalBottomSheet(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(38), topRight: Radius.circular(38)),
          ),
          context: context,
          builder: (BuildContext context) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    showModalTitle,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.montserrat(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 19,
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          Builder(
                            builder: (context) {
                              return ElevatedButton(
                                onPressed: galleryPhoto,
                                child: const Icon(Icons.add_to_photos, color: Colors.white),
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(20),
                                  primary: primaryColor, // <-- Button color
                                  onPrimary: Colors.red, // <-- Splash color
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Galería',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.montserrat(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: cameraPhoto,
                            child: const Icon(Icons.camera_alt_outlined, color: Colors.white),
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20),
                              primary: primaryColor, // <-- Button color
                              onPrimary: Colors.red, // <-- Splash color
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Cámara',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.montserrat(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
      child: child,
    );
  }
}
