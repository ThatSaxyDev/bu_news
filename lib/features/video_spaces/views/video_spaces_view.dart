import 'package:bu_news/config/agora_config.dart';
import 'package:bu_news/features/video_spaces/controllers/videos_spaces_controller.dart';
import 'package:bu_news/models/video_call_model.dart';
import 'package:bu_news/utils/loader.dart';
import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoSpacesView extends ConsumerStatefulWidget {
  final String channelId;
  final VideoCallModel videoSpace;
  const VideoSpacesView({
    super.key,
    required this.channelId,
    required this.videoSpace,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VideoSpacesViewState();
}

class _VideoSpacesViewState extends ConsumerState<VideoSpacesView> {
  AgoraClient? client;

  @override
  void initState() {
    super.initState();
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: AgoraConfig.appId,
        channelName: widget.channelId,
        tokenUrl: AgoraConfig.tokenUrl,
      ),
    );
    initAgora();
  }

  void initAgora() async {
    await client!.initialize();
  }

  void leaveSpace() {
    ref.read(videoSpacesControllerProvider.notifier).leaveSpace(
          callerId: widget.videoSpace.callerId,
          receiverId: widget.videoSpace.receiverId,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(videoSpacesControllerProvider);
    return Scaffold(
      body: client == null
          ? const Loader()
          : SafeArea(
              child: Stack(
                children: [
                  AgoraVideoViewer(client: client!),
                  AgoraVideoButtons(
                    client: client!,
                    disconnectButtonChild: IconButton(
                      onPressed: () async {
                        await client!.engine.leaveChannel();
                        leaveSpace();
                      },
                      icon: const Icon(Icons.call_end),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
