import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'dart:developer';

class CameraWithOverlay extends StatefulWidget {
  static String id = 'CameraWithOverlay';
  final double overlayWidthFraction = 0.7; // مثلاً 0.5 => 50% من عرض المعاينة
  final double overlayHeightFraction = 0.09;

  const CameraWithOverlay({Key? key}) : super(key: key);

  @override
  State<CameraWithOverlay> createState() => _CameraWithOverlayState();
}

class _CameraWithOverlayState extends State<CameraWithOverlay> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  bool _isInitialized = false;

  // نستخدم key لقياس حجم preview widget على الشاشة
  final GlobalKey _previewContainerKey = GlobalKey();

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

    // لو قياسات preview غير معروفة، نفترض مركزية ونأخذ نسب ثابتة:
    if (previewWidgetWidth == 0 || previewWidgetHeight == 0) {
      // استخدم نسبة الافتراضية
      previewWidgetWidth = imgW.toDouble();
      previewWidgetHeight = imgH.toDouble();
    }

    // نسبة المستطيل في الواجهة
    final double overlayW = widget.overlayWidthFraction; // 0..1
    final double overlayH = widget.overlayHeightFraction;

    // نحدد موقع المستطيل كنسبة من الواجهة (نفرض مركزي)
    final double overlayPixelW_onWidget = previewWidgetWidth * overlayW;
    final double overlayPixelH_onWidget = previewWidgetHeight * overlayH;

    // نسبة المستطيل من عرض/ارتفاع الواجهة
    final double ratioW = overlayPixelW_onWidget / previewWidgetWidth;
    final double ratioH = overlayPixelH_onWidget / previewWidgetHeight;

    // نحولها إلى حجم بالبيكسل في الصورة الحقيقية
    final int cropW = (imgW * ratioW).toInt();
    final int cropH = (imgH * ratioH).toInt();

    // لأن المستطيل مركزي على الواجهة، نحسب مركز الصورة ثم نحدد x,y
    final int centerX = (imgW / 2).toInt();
    final int centerY = (imgH / 2).toInt();

    int x = (centerX - cropW / 2).round();
    int y = (centerY - cropH / 2).round();

    // ضمان ألا تكون الإحداثيات خارج الصورة
    x = x.clamp(0, imgW - 1 - cropW.clamp(0, imgW));
    y = y.clamp(0, imgH - 1 - cropH.clamp(0, imgH));

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
      appBar: AppBar(title: const Text('Camera with overlay')),
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
                                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
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
