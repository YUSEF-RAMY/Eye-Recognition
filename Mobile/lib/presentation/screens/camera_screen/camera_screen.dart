import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'dart:developer';

class CameraWithOverlay extends StatefulWidget {
  static String id = 'CameraWithOverlay';

  const CameraWithOverlay({super.key});

  @override
  State<CameraWithOverlay> createState() => _CameraWithOverlayState();
}

class _CameraWithOverlayState extends State<CameraWithOverlay> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  bool _isInitialized = false;

  // نستخدم key لقياس حجم preview widget على الشاشة
  final GlobalKey _previewContainerKey = GlobalKey();

  // مقاس المستطيل الثابت (logical pixels)
  static const double overlayFixedWidth = 185;
  static const double overlayFixedHeight = 38;

  // أبعاد واجهة المعاينة الحالية بالـ logical pixels
  double previewWidgetWidth = 0;
  double previewWidgetHeight = 0;

  @override
  void initState() {
    super.initState();
    _initCameras();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initCameras() async {
    try {
      cameras = await availableCameras();
      if (cameras == null || cameras!.isEmpty) return;

      // استخدم الكاميرا الأمامية أو الخلفية حسب الحاجة
      final camera = cameras!.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras!.first,
      );

      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();

      if (!mounted) return;
      setState(() {
        _isInitialized = true;
      });

      // بعد الإظهار نأخذ قياسات preview widget
      WidgetsBinding.instance.addPostFrameCallback((_) => _measurePreview());
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  void _measurePreview() {
    final RenderBox? rb =
        _previewContainerKey.currentContext?.findRenderObject() as RenderBox?;
    if (rb != null) {
      setState(() {
        previewWidgetWidth = rb.size.width;
        previewWidgetHeight = rb.size.height;
      });
    }
  }

  /// يحوّل Uint8List (بيانات الصورة الملتقطة) إلى ملف مؤقت ويعيد المسار
  Future<File> _saveXFileToFile(XFile xfile) async {
    final dir = await getTemporaryDirectory();
    final target = File(
      '${dir.path}/captured_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    final bytes = await xfile.readAsBytes();
    await target.writeAsBytes(bytes);
    return target;
  }

  /// قص الصورة بحسب المستطيل المعروض على الشاشة
  Future<Uint8List> cropImageByOverlay(Uint8List imageBytes) async {
    final captured = img.decodeImage(imageBytes);
    if (captured == null) throw Exception('Failed to decode image');

    // عرض/ارتفاع الصورة الفعليين
    final int imgW = captured.width;
    final int imgH = captured.height;

    final previewSize = _controller!.value.previewSize!;
    final double previewAspectRatio = previewSize.height / previewSize.width;

    final double widgetAspectRatio = previewWidgetHeight / previewWidgetWidth;

    // حساب الجزء المرئي فعليًا من الصورة
    double visibleW, visibleH;

    if (widgetAspectRatio > previewAspectRatio) {
      // الصورة متقصوصة من الجوانب
      visibleH = imgH.toDouble();
      visibleW = visibleH / widgetAspectRatio;
    } else {
      // الصورة متقصوصة من فوق وتحت
      visibleW = imgW.toDouble();
      visibleH = visibleW * widgetAspectRatio;
    }

    // إزاحة الجزء المرئي داخل الصورة الحقيقية
    final double offsetX = (imgW - visibleW) / 2;
    final double offsetY = (imgH - visibleH) / 2;

    // تحويل overlay من UI → image pixels
    final double scaleX = visibleW / previewWidgetWidth;
    final double scaleY = visibleH / previewWidgetHeight;

    final int cropW = (overlayFixedWidth * scaleX).round();
    final int cropH = (overlayFixedHeight * scaleY).round();

    // مركز المستطيل المرئي
    final int centerX = (offsetX + visibleW / 2).round();
    final int centerY = (offsetY + visibleH / 2).round();

    int x = (centerX - cropW / 2).round();
    int y = (centerY - cropH / 2).round();

    x = x.clamp(0, imgW - cropW);
    y = y.clamp(0, imgH - cropH);

    final cropped = img.copyCrop(
      captured,
      x: x,
      y: y,
      width: cropW,
      height: cropH,
    );
    return Uint8List.fromList(img.encodeJpg(cropped));
  }

  Future<void> _takePictureAndCrop() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      final XFile raw = await _controller!.takePicture();

      // نحفظه مؤقتًا كـ File
      final File saved = await _saveXFileToFile(raw);
      final Uint8List bytes = await saved.readAsBytes();

      // نقص بحسب المستطيل المعروض
      final Uint8List croppedBytes = await cropImageByOverlay(bytes);

      // الآن لديك croppedBytes (Uint8List) -> إما اعرضه مباشرة أو حوله لملف
      final File finalFile = await _uint8ListToFile(croppedBytes);

      // مثال: عرضها أو إرسالها أو حفظها
      if (!mounted) return;
      Navigator.pop(context, finalFile); // finalFile = ملف الصورة بعد القص

      // لو تستخدم widget.image كـ File (مثل كلامك سابقًا) حدّثها:
      // setState(() { widget.image = finalFile; });
    } catch (e, st) {
      debugPrint('capture/crop error: $e\n$st');
    }
  }

  Future<File> _uint8ListToFile(Uint8List bytes) async {
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await file.writeAsBytes(bytes);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera with overlay'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: _isInitialized && _controller != null
          ? SafeArea(
              child: Column(
                children: [
                  // الحاوية التي تحتوي Preview + Overlay
                  Expanded(
                    child: Container(
                      key: _previewContainerKey,
                      color: Colors.black,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // مهم: نحدّث قياسات واجهة المعاينة عند كل تغيير في layout
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (previewWidgetWidth != constraints.maxWidth ||
                                previewWidgetHeight != constraints.maxHeight) {
                              setState(() {
                                previewWidgetWidth = constraints.maxWidth;
                                previewWidgetHeight = constraints.maxHeight;
                              });
                            }
                          });

                          return Stack(
                            children: [
                              // كاميرا Preview
                              Positioned.fill(
                                child: CameraPreview(_controller!),
                              ),

                              // overlay مستطيل مركزي
                              Center(
                                child: Container(
                                  height: 38,
                                  width: 185,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.redAccent,
                                      width: 3,
                                    ),
                                    color: Colors.transparent,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 18,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                              (0.5 * 255).toInt(),
                                              100,
                                              236,
                                              295,
                                            ),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(24),
                                            ),
                                            border: BoxBorder.all(
                                              width: 1,
                                              color: Color.fromARGB(
                                                (0.6 * 255).toInt(),
                                                136,
                                                255,
                                                81,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 18,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                              (0.5 * 255).toInt(),
                                              100,
                                              236,
                                              295,
                                            ),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(16),
                                            ),
                                            border: BoxBorder.all(
                                              width: 1,
                                              color: Color.fromARGB(
                                                (0.6 * 255).toInt(),
                                                136,
                                                255,
                                                81,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // تعليمات بسيطة في الأعلى
                              Positioned(
                                top: 16,
                                left: 16,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  color: Colors.black45,
                                  child: const Text(
                                    'ضع العين داخل المستطيل ثم اضغط تصوير',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  // أزرار التحكم
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _takePictureAndCrop(),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('التقاط'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () async {
                            log(cameras!.length.toString());
                            // مثال: تبديل الكاميرا لو متوفرة أكثر من واحدة
                            if (cameras != null && cameras!.length > 1) {
                              final idx = cameras!.indexOf(
                                _controller!.description,
                              );
                              log(idx.toString());
                              final newIdx = (idx + 1) % cameras!.length;
                              log(newIdx.toString());
                              await _controller!.dispose();
                              _controller = CameraController(
                                cameras![newIdx],
                                ResolutionPreset.high,
                                enableAudio: false,
                              );
                              await _controller!.initialize();
                              if (!mounted) return;
                              setState(() {});
                            }
                          },
                          icon: const Icon(Icons.flip_camera_android),
                          label: const Text('تبديل'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
