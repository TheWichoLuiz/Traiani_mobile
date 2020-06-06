import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/viewobject/message.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ChatImageDetailView extends StatefulWidget {
  const ChatImageDetailView({@required this.messageObj});
  final Message messageObj;
  @override
  _ChatImageDetailViewState createState() => _ChatImageDetailViewState();
}

class _ChatImageDetailViewState extends State<ChatImageDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0.0,
          // brightness: Utils.getBrightnessForAppBar(context),
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: PsColors.mainColorWithWhite),
          title: Text('',
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(fontWeight: FontWeight.bold)
                  .copyWith(color: PsColors.mainColorWithWhite)),
        ),
        body: PhotoViewGallery.builder(
          itemCount: 1,
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions.customChild(
              child: PsNetworkImageWithUrl(
                photoKey: '',
                imagePath: widget.messageObj.message,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                boxfit: BoxFit.contain,
              ),
              childSize: MediaQuery.of(context).size,
            );
          },
          scrollPhysics: const BouncingScrollPhysics(),
          loadingChild: const Center(
            child: CircularProgressIndicator(),
          ),
        ));
  }
}
