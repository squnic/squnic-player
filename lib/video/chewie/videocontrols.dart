import 'dart:async';

import 'chewie_player.dart';
import 'chewie_progress_colors.dart';
import 'progress_bar.dart';
import 'utils.dart';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../basics/colors.dart';

class CustomControls extends StatefulWidget {
  final String title;
  CustomControls({Key key, this.title = "Video"}) : super(key: key);

  @override
  _CustomControlsState createState() => _CustomControlsState();
}

class _CustomControlsState extends State<CustomControls> {
  VideoPlayerValue _latestValue;
  double _latestVolume;
  double _latestBrightness;
  bool _hideStuff = true;
  Timer _hideTimer;
  Timer _initTimer;
  Timer _showAfterExpandCollapseTimer;
  bool _dragging = false;
  bool _displayTapped = false;

  bool _showSwipeSeek = false;
  bool _showSwipeGestures = false;
  bool _showPlus10 = false;
  bool _showMinus10 = false;

  int forwardTap = 0;
  int backwardTap = 0;

  int _swipeSeek = 0;

  final barHeight = 30.0;
  final appBarHeight = 50.0;
  final marginSize = 5.0;

  VideoPlayerController controller;
  ChewieController chewieController;

  ColorTheme colorTheme;

  @override
  Widget build(BuildContext context) {
    colorTheme = ColorTheme();
    if (_latestValue.hasError) {
      return chewieController.errorBuilder != null
          ? chewieController.errorBuilder(
              context,
              chewieController.videoPlayerController.value.errorDescription,
            )
          : Center(
              child: Icon(
                Icons.error,
                color: Colors.white,
                size: 42,
              ),
            );
    }

    return MouseRegion(
      onHover: (_) {
        _cancelAndRestartTimer();
      },
      child: GestureDetector(
        onTap: () {
          _cancelAndRestartTimer();
          setState(() {
            _showSwipeGestures = !_showSwipeGestures;
            _showSwipeSeek = false;
          });
        },
        // onDoubleTap: () {
        //   // if (controller.value.isPlaying) {
        //   //   controller.pause();
        //   // } else {
        //   //   controller.play();
        //   // }
        //   // setState(() {
        //   //   _showSwipeGestures=false;
        //   //   _showSwipeSeek=false;
        //   // });
        //   if (!controller.value.initialized) {
        //     return;
        //   }

        //   //   setState(() {
        //   //   _showSwipeGestures=true;
        //   //   _showSwipeSeek = true;
        //   // });

        //   // Timer(Duration(milliseconds: 300), (){
        //   //   setState(() {
        //   //     _showSwipeGestures=false;
        //   //     _showSwipeSeek=false;
        //   //   });
        //   // });
        // },
        // onVerticalDragUpdate: (DragUpdateDetails details) {
        //   // setState(() {
        //   //   _showSwipeGestures=true;
        //   // });
        //   // Timer(Duration(milliseconds: 300), (){
        //   // setState(() {
        //   //   _showSwipeGestures=false;
        //   // });
        //   // });
        // },
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          if (!controller.value.initialized) {
            return;
          }
          controller.seekTo(controller.value.position +
              Duration(seconds: details.primaryDelta.round()));
          if (details.primaryDelta.round() > 0) {
            _swipeSeek = controller.value.position.inSeconds;
            setState(() {
              _showSwipeGestures = true;
              _showSwipeSeek = true;
              _hideStuff=false;
            });

            Timer(Duration(milliseconds: 300), () {
              if(_showSwipeSeek){
                setState(() {
                _showSwipeSeek = false;
              });
              }
            });
          }
        },
        child: AbsorbPointer(
            absorbing: _hideStuff,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    chewieController.isFullScreen
                        ? _buildAppBar(context)
                        : SafeArea(child: _buildAppBar(context)),
                     _latestValue != null &&
                                    !_latestValue.isPlaying &&
                                    _latestValue.duration == null ||
                                _latestValue.isBuffering
                            ?  const Expanded(child: const Center(
                                  child: const CircularProgressIndicator(),
                                ) ,) 
                            : _buildHitArea(),
                    _buildBottomBar(context),
                  ],
                ),
                Container(
                        constraints: BoxConstraints.expand(),
                        color:colorTheme.white.withOpacity(0.5),
                        margin: EdgeInsets.only(top: appBarHeight,bottom: barHeight*2),
                        child: Stack(
                          children: <Widget>[
                            _showSwipeSeek
                                ? Center(
                                    child: Container(
                                      color: colorTheme.background
                                          .withOpacity(0.5),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Text(
                                          '[' + _swipeSeek.toString() + 's]',
                                          style: TextStyle(
                                              color: colorTheme.white,
                                              fontSize: 30)),
                                    ),
                                  )
                                : Container(),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      // color: colorTheme.white.withOpacity(0.5),
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: (){
                                          print('Minus Tapped');
                                          setState(() {
                                            _hideStuff=!_hideStuff;
                                            _showSwipeGestures=false;
                                          });
                                          // _cancelAndRestartTimer();
                                        },
                                        onDoubleTap: () {
                                          if (!controller.value.initialized) {
                                            return;
                                          }
                                          print('[-10s]');
                                          setState(() {
                                            _showMinus10 = true;
                                            _showPlus10 = false;
                                          });
                                          if (controller
                                                  .value.position.inSeconds >
                                              10) {
                                            controller.seekTo(Duration(
                                                seconds: controller.value
                                                        .position.inSeconds -
                                                    10));
                                          } else {
                                            controller
                                                .seekTo(Duration(seconds: 0));
                                          }
                                          backwardTap+=1;
                                            Timer(Duration(seconds: 2),(){
                                              if(!_showPlus10){
                                                forwardTap =0;
                                                backwardTap=0;
                                              }
                                            });
                                            Timer(Duration(seconds: 3), () {
                                              if(_showMinus10){
                                                setState(() {
                                                _showMinus10 = false;
                                                _showPlus10 = false;
                                              });
                                              }
                                            });
                                        },
                                        child: Center(
                                          child: _showMinus10
                                              ? Container(
                                                  color: colorTheme.background
                                                      .withOpacity(0.5),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  child: Text(
                                                    '[-${backwardTap*10}s]',
                                                    style: TextStyle(
                                                        color: colorTheme.white,
                                                        fontSize: 30),
                                                  ),
                                                )
                                              : Container(),
                                        ),
                                      ),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                        // color:
                                        //     colorTheme.white.withOpacity(0.5),
                                        child: GestureDetector(
                                                    onVerticalDragUpdate: (DragUpdateDetails details){
                                                      if (!controller.value.initialized) {
                                            return;
                                          }
                                                      controller.setVolume(_latestVolume+(details.primaryDelta.round()/10));
                                                    },
                                          behavior: HitTestBehavior.translucent,
                                          onTap: (){
                                          print('Plus Tapped');
                                          setState(() {
                                            _hideStuff=!_hideStuff;
                                            _showSwipeGestures=false;
                                          });
                                          // _cancelAndRestartTimer();
                                        },
                                          onDoubleTap: () {
                                            if (!controller.value.initialized) {
                                              return;
                                            }
                                            print('[+10s]');
                                            setState(() {
                                              _showMinus10 = false;
                                              _showPlus10 = true;
                                            });
                                            if (controller
                                                    .value.position.inSeconds <
                                                controller.value.duration
                                                        .inSeconds -
                                                    10) {
                                              controller.seekTo(Duration(
                                                  seconds: controller.value
                                                          .position.inSeconds +
                                                      10));
                                            }
                                            forwardTap+=1;
                                            Timer(Duration(seconds: 2),(){
                                              if(!_showPlus10){
                                                forwardTap =0;
                                                backwardTap=0;
                                              }
                                            });
                                            Timer(Duration(seconds: 3), () {
                                              if(_showPlus10){
                                                setState(() {
                                                _showMinus10 = false;
                                                _showPlus10 = false;
                                              });
                                              }
                                            });
                                          },
                                          child: Center(
                                            child: _showPlus10
                                                ? Container(
                                                    color: colorTheme.background
                                                        .withOpacity(0.5),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
                                                    child: Text(
                                                      '[+${forwardTap*10}s]',
                                                      style: TextStyle(
                                                          color:
                                                              colorTheme.white,
                                                          fontSize: 30),
                                                    ),
                                                  )
                                                : Container(),
                                          ),
                                        ))),
                              ],
                            ),
                          ],
                        ))
              ],
            )),
      ),
    );
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _dispose() {
    controller.removeListener(_updateState);
    _hideTimer?.cancel();
    _initTimer?.cancel();
    _showAfterExpandCollapseTimer?.cancel();
  }

  @override
  void didChangeDependencies() {
    final _oldController = chewieController;
    chewieController = ChewieController.of(context);
    controller = chewieController.videoPlayerController;

    if (_oldController != chewieController) {
      _dispose();
      _initialize();
    }

    super.didChangeDependencies();
  }

  AnimatedOpacity _buildAppBar(BuildContext context) {
    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 1.0,
      duration: Duration(milliseconds: 300),
      child: Container(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.centerLeft,
        color: colorTheme.background.withOpacity(0.4),
        child: Row(
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.arrow_back),
                color: colorTheme.white,
                onPressed: () {
                  if(chewieController.isFullScreen){
                    chewieController.exitFullScreen();
                  }
                  if (chewieController.isFullScreen) {
                    print('\n\n\nFull Screen ...\n\n\n');
                    chewieController.exitFullScreen();
                  } else {
                    Navigator.pop(context, true);
                  }
                }),
            Text(
              widget.title,
              style: TextStyle(
                  color: colorTheme.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedOpacity _buildBottomBar(
    BuildContext context,
  ) {
    final iconColor = colorTheme.white;

    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 1.0,
      duration: Duration(milliseconds: 300),
      child: Container(
        height: barHeight * 2,
        width: double.infinity,
        color: colorTheme.background.withOpacity(0.4),
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            chewieController.isLive
                ? Expanded(child: const Text('LIVE'))
                : Expanded(child: _buildPosition(iconColor)),
            chewieController.isLive ? const SizedBox() : _buildProgressBar(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildPlayPause(controller),
                chewieController.allowMuting
                    ? _buildMuteButton(controller)
                    : Container(),
                chewieController.allowFullScreen
                    ? _buildExpandButton()
                    : Container(),
              ],
            )
          ],
        ),
      ),
    );
  }

  GestureDetector _buildExpandButton() {
    return GestureDetector(
      onTap: _onExpandCollapse,
      child: AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: Duration(milliseconds: 300),
        child: Container(
          height: barHeight,
          margin: EdgeInsets.only(right: 12.0),
          padding: EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: Center(
            child: Icon(
              chewieController.isFullScreen
                  ? Icons.fullscreen_exit
                  : Icons.fullscreen,
              color: colorTheme.white,
            ),
          ),
        ),
      ),
    );
  }

  Expanded _buildHitArea() {
    return Expanded(
      child: GestureDetector(
        // onDoubleTap: _playPause,
        onTap: () {
          if (_latestValue != null && _latestValue.isPlaying) {
            if (_displayTapped) {
              setState(() {
                _hideStuff = true;
              });
            } else
              _cancelAndRestartTimer();
          } else {
            _playPause();

            setState(() {
              _hideStuff = true;
            });
          }
        },
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: AnimatedOpacity(
              opacity: _hideStuff ? 0.0 : 1.0,
              duration: Duration(milliseconds: 300),
              child: GestureDetector(
                  child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                          icon: Icon(Icons.skip_previous),
                          color: colorTheme.white,
                          iconSize: 50,
                          onPressed: () {}),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          icon: Icon(Icons.skip_next),
                          color: colorTheme.white,
                          iconSize: 50,
                          onPressed: () {}),
                    ),
                  ],
                ),
              )),
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _buildMuteButton(
    VideoPlayerController controller,
  ) {
    return GestureDetector(
      onTap: () {
        _cancelAndRestartTimer();

        if (_latestValue.volume == 0) {
          controller.setVolume(_latestVolume ?? 0.5);
        } else {
          _latestVolume = controller.value.volume;
          controller.setVolume(0.0);
        }
      },
      child: AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: Duration(milliseconds: 300),
        child: ClipRect(
          child: Container(
            child: Container(
              height: barHeight,
              padding: EdgeInsets.only(
                left: 8.0,
                right: 8.0,
              ),
              child: Icon(
                (_latestValue != null && _latestValue.volume > 0)
                    ? Icons.volume_up
                    : Icons.volume_off,
                color: colorTheme.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _buildPlayPause(VideoPlayerController controller) {
    return GestureDetector(
      onTap: _playPause,
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.only(left: 8.0, right: 4.0),
        padding: EdgeInsets.only(
          left: 12.0,
          right: 12.0,
        ),
        child: Icon(
          controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          color: colorTheme.white,
        ),
      ),
    );
  }

  Widget _buildPosition(Color iconColor) {
    final position = _latestValue != null && _latestValue.position != null
        ? _latestValue.position
        : Duration.zero;
    final duration = _latestValue != null && _latestValue.duration != null
        ? _latestValue.duration
        : Duration.zero;

    return Padding(
        padding: EdgeInsets.only(right: 24.0),
        child: Row(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                '${formatDuration(position)}',
                style: TextStyle(
                  fontSize: 14.0,
                  color: colorTheme.primary,
                ),
              ),
            ),
            Expanded(
                child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                '${formatDuration(duration)}',
                style: TextStyle(
                  fontSize: 14.0,
                  color: colorTheme.white,
                ),
              ),
            ))
          ],
        ));
  }

  void _cancelAndRestartTimer() {
    _hideTimer?.cancel();
    _startHideTimer();

    setState(() {
      _hideStuff = false;
      _displayTapped = true;
    });
  }

  Future<Null> _initialize() async {
    controller.addListener(_updateState);

    _updateState();

    if ((controller.value != null && controller.value.isPlaying) ||
        chewieController.autoPlay) {
      _startHideTimer();
    }

    if (chewieController.showControlsOnInitialize) {
      _initTimer = Timer(Duration(milliseconds: 200), () {
        setState(() {
          _hideStuff = false;
        });
      });
    }
  }

  void _onExpandCollapse() {
    setState(() {
      _hideStuff = true;

      chewieController.toggleFullScreen();
      _showAfterExpandCollapseTimer = Timer(Duration(milliseconds: 300), () {
        setState(() {
          _cancelAndRestartTimer();
        });
      });
    });
  }

  void _playPause() {
    bool isFinished;
    if (_latestValue.duration != null) {
      isFinished = _latestValue.position >= _latestValue.duration;
    } else {
      isFinished = false;
    }

    setState(() {
      if (controller.value.isPlaying) {
        _hideStuff = false;
        _hideTimer?.cancel();
        controller.pause();
      } else {
        _cancelAndRestartTimer();

        if (!controller.value.initialized) {
          controller.initialize().then((_) {
            controller.play();
          });
        } else {
          if (isFinished) {
            controller.seekTo(Duration(seconds: 0));
          }
          controller.play();
        }
      }
    });
  }

  void _startHideTimer() {
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _hideStuff = true;
        _showSwipeGestures = true;
      });
    });
  }

  void _updateState() {
    setState(() {
      _latestValue = controller.value;
    });
  }

  Widget _buildProgressBar() {
    return Expanded(
        child: Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: CustomVideoProgressBar(
        controller,
        onDragStart: () {
          setState(() {
            _dragging = true;
          });

          _hideTimer?.cancel();
        },
        onDragEnd: () {
          setState(() {
            _dragging = false;
          });

          _startHideTimer();
        },
        colors: chewieController.materialProgressColors ??
            ChewieProgressColors(
              playedColor: colorTheme.primary.withOpacity(0.7),
              handleColor: colorTheme.white.withOpacity(1),
              bufferedColor: colorTheme.primary.withOpacity(0.2),
              backgroundColor: colorTheme.background.withOpacity(0.5),
            ),
      ),
    ));
  }
}
