import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

/// Widget de câmera com overlay de grade técnica para análise de superfícies
class CameraAnalyzerView extends StatefulWidget {
  /// Callback quando foto é capturada
  final Function(XFile) onPhotoCapture;
  
  /// Callback para controlar flash
  final Function(FlashMode) onFlashToggle;

  const CameraAnalyzerView({
    Key? key,
    required this.onPhotoCapture,
    required this.onFlashToggle,
  }) : super(key: key);

  @override
  State<CameraAnalyzerView> createState() => _CameraAnalyzerViewState();
}

class _CameraAnalyzerViewState extends State<CameraAnalyzerView>
    with WidgetsBindingObserver {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  FlashMode _flashMode = FlashMode.torch;
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  /// Inicializa a câmera
  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      _initializeControllerFuture = _cameraController.initialize();

      // Ativar flash automático
      await _cameraController.setFlashMode(_flashMode);

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('Erro ao inicializar câmera: $e');
    }
  }

  /// Captura foto e inicia análise
  Future<void> _capturePhoto() async {
    if (_isAnalyzing) return;

    try {
      setState(() => _isAnalyzing = true);

      final image = await _cameraController.takePicture();
      widget.onPhotoCapture(image);

      // Simular análise por 2 segundos
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isAnalyzing = false);
      }
    } catch (e) {
      debugPrint('Erro ao capturar foto: $e');
      if (mounted) {
        setState(() => _isAnalyzing = false);
      }
    }
  }

  /// Alterna modo flash
  Future<void> _toggleFlash() async {
    try {
      final newMode = _flashMode == FlashMode.torch ? FlashMode.off : FlashMode.torch;
      await _cameraController.setFlashMode(newMode);
      widget.onFlashToggle(newMode);

      if (mounted) {
        setState(() => _flashMode = newMode);
      }
    } catch (e) {
      debugPrint('Erro ao alternar flash: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              // Preview da câmera
              CameraPreview(_cameraController),

              // Overlay com grade técnica
              _buildTechnicalOverlay(),

              // Controles
              _buildControls(),
            ],
          );
        } else {
          return Container(
            color: Colors.black,
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
              ),
            ),
          );
        }
      },
    );
  }

  /// Constrói overlay com grade técnica 3x3
  Widget _buildTechnicalOverlay() {
    return Positioned.fill(
      child: CustomPaint(
        painter: TechnicalGridPainter(),
      ),
    );
  }

  /// Constrói controles (botão de captura, flash, etc)
  Widget _buildControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Instruções
            if (!_isAnalyzing)
              Text(
                _flashMode == FlashMode.torch
                    ? '📸 Posicione a 30cm da superfície'
                    : '⚠️ Ative o flash para continuar',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),

            if (_isAnalyzing)
              const Column(
                children: [
                  SizedBox(height: 8),
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Analisando superfície...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 24),

            // Botões de controle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Botão de Flash
                GestureDetector(
                  onTap: _isAnalyzing ? null : _toggleFlash,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _flashMode == FlashMode.torch
                          ? const Color(0xFFD4AF37)
                          : Colors.grey.withOpacity(0.3),
                    ),
                    child: Icon(
                      Icons.flash_on,
                      color: _flashMode == FlashMode.torch
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),

                // Botão de Captura
                GestureDetector(
                  onTap: _isAnalyzing ? null : _capturePhoto,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFD4AF37),
                        width: 4,
                      ),
                      color: _isAnalyzing
                          ? Colors.grey.withOpacity(0.3)
                          : Colors.white,
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFD4AF37),
                      ),
                    ),
                  ),
                ),

                // Espaçador
                const SizedBox(width: 56),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// CustomPainter para desenhar grade técnica 3x3
class TechnicalGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 1;

    // Linhas horizontais
    final horizontalSpacing = size.height / 3;
    for (int i = 1; i < 3; i++) {
      canvas.drawLine(
        Offset(0, horizontalSpacing * i),
        Offset(size.width, horizontalSpacing * i),
        paint,
      );
    }

    // Linhas verticais
    final verticalSpacing = size.width / 3;
    for (int i = 1; i < 3; i++) {
      canvas.drawLine(
        Offset(verticalSpacing * i, 0),
        Offset(verticalSpacing * i, size.height),
        paint,
      );
    }

    // Círculo central
    final centerPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = 60.0;
    canvas.drawCircle(center, radius, centerPaint);
  }

  @override
  bool shouldRepaint(TechnicalGridPainter oldDelegate) => false;
}
