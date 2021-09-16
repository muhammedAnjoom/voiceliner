import 'package:binder/binder.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voice_outliner/state/notes_state.dart';
import 'package:voice_outliner/state/player_state.dart';

class RecordButton extends StatefulWidget {
  const RecordButton({Key? key}) : super(key: key);

  @override
  _RecordButtonState createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  Offset offset = const Offset(0, 0);
  _stopRecord(_) {
    HapticFeedback.mediumImpact();
    context.use(notesLogicRef).stopRecording();
  }

  _stopRecord0() {
    _stopRecord(null);
  }

  _startRecord(_) {
    context.use(notesLogicRef).startRecording();
  }

  _playEffect(LongPressDownDetails d) {
    HapticFeedback.mediumImpact();
    setState(() {
      offset = d.localPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    final playerState = context.watch(playerStateRef);
    final isRecording = playerState == PlayerState.recording;
    return GestureDetector(
        onTapDown: _startRecord,
        onTapUp: _stopRecord,
        onLongPressDown: _playEffect,
        onLongPressUp: _stopRecord0,
        onPanEnd: _stopRecord,
        onLongPressMoveUpdate: (LongPressMoveUpdateDetails d) {
          setState(() {
            offset = d.localPosition;
          });
        },
        onPanUpdate: (DragUpdateDetails d) {
          setState(() {
            offset = d.localPosition;
          });
        },
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 100),
          opacity: playerState == PlayerState.ready || isRecording ? 1.0 : 0.0,
          child: AnimatedContainer(
              width: 200,
              height: 75,
              curve: Curves.bounceInOut,
              duration: const Duration(milliseconds: 100),
              child: Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    if (!isRecording) ...[
                      const Icon(Icons.mic, color: Colors.white),
                      const SizedBox(
                        width: 10.0,
                      )
                    ],
                    Text(
                      isRecording ? "recording" : "hold to record",
                      style:
                          const TextStyle(color: Colors.white, fontSize: 15.0),
                    )
                  ])),
              decoration: BoxDecoration(
                boxShadow: [
                  const BoxShadow(
                      color: Color.fromRGBO(169, 129, 234, 0.8),
                      blurRadius: 3.0,
                      spreadRadius: 3.0,
                      offset: Offset(0, 3)),
                  if (isRecording)
                    BoxShadow(
                        color: const Color.fromRGBO(169, 129, 234, 0.6),
                        blurRadius: 120.0,
                        spreadRadius: 120.0,
                        offset: offset + const Offset(-100, -95))
                ],
                borderRadius: BorderRadius.circular(100.0),
                color: const Color.fromRGBO(169, 129, 234, 0.9),
              )),
        ));
  }
}
