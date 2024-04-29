import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:photo_memories/dialogs/loading_screen_controller.dart';


@immutable
class LoadingScreen {
  //? singleton declearation starts
  LoadingScreen._();
  static final LoadingScreen _shared = LoadingScreen._();
  factory LoadingScreen.instance() => _shared;
  //?  singleton declearation ends
  LoadingScreenController? _controller;

  void show({
    required BuildContext context,
    required String text,
  }) {
    log('show fxn called');
    if (_controller?.update(text) ?? false) {
      log('show1 fxn called');
      return;
    } else {
      log('show2 fxn called');
      _controller = _showOverlay(context: context, text: text);
    }
  }

  
  void hide() {
   
    log('Hide fxn called');
    _controller?.close;
    
    _controller = null;
  }


  LoadingScreenController _showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final text0 = StreamController<String>();
    text0.add(text);

//!Get the size
    final state = Overlay.of(context);
//? to know how big the screen is
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;


    void hide() {
      log('Hide fxn called');
      _controller?.close;
state.dispose();
      _controller = null;
    }
    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.8,
                minWidth: size.width * 0.5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const CircularProgressIndicator(),
                    const SizedBox(
                      height: 20,
                    ),
                    StreamBuilder<String>(
                      stream: text0.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data ?? 'chuks',
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    state.insert(overlay);
    _controller = LoadingScreenController(
      close: () {
        text0.close();
        state.dispose();
        overlay.remove();
        return true;
      },
      update: (textUpdate) {
        text0.add(textUpdate);
        return true;
      },
    );
    return LoadingScreenController(
      close: () {
        text0.close();
        state.dispose();
        overlay.remove();
        return true;
      },
      update: (textUpdate) {
        text0.add(textUpdate);
        return true;
      },
    );
  }
}
