import 'package:flutter/material.dart';

class TutorialStep {
  final String title;
  final String description;
  final GlobalKey? targetKey;
  final Alignment? targetAlignment;
  final Widget? customContent;
  final VoidCallback? onNext;

  const TutorialStep({
    required this.title,
    required this.description,
    this.targetKey,
    this.targetAlignment,
    this.customContent,
    this.onNext,
  });
}

class TutorialOverlay extends StatefulWidget {
  final List<TutorialStep> steps;
  final VoidCallback onComplete;
  final VoidCallback onSkip;

  const TutorialOverlay({
    super.key,
    required this.steps,
    required this.onComplete,
    required this.onSkip,
  });

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay>
    with SingleTickerProviderStateMixin {
  int currentStep = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (currentStep < widget.steps.length - 1) {
      setState(() {
        currentStep++;
      });
      _animationController.reset();
      _animationController.forward();
    } else {
      widget.onComplete();
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.steps[currentStep];
    
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: _buildTutorialContent(step),
        );
      },
    );
  }

  Widget _buildTutorialContent(TutorialStep step) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a2e),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF00d4ff),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00d4ff).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step indicator and navigation buttons
            Row(
              children: [
                // Step indicator
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00d4ff).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Step ${currentStep + 1} of ${widget.steps.length}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF00d4ff),
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const Spacer(),
                // Navigation buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Previous button
                    if (currentStep > 0)
                      GestureDetector(
                        onTap: _previousStep,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    if (currentStep > 0) const SizedBox(width: 8),
                    // Next button
                    GestureDetector(
                      onTap: step.onNext ?? _nextStep,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00d4ff).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF00d4ff)),
                        ),
                        child: Icon(
                          currentStep == widget.steps.length - 1 
                              ? Icons.play_arrow 
                              : Icons.arrow_forward,
                          color: const Color(0xFF00d4ff),
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Skip button
                    GestureDetector(
                      onTap: widget.onSkip,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Progress indicator
            SizedBox(
              width: double.infinity,
              height: 4,
              child: LinearProgressIndicator(
                value: (currentStep + 1) / widget.steps.length,
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00d4ff)),
              ),
            ),
            const SizedBox(height: 16),
            
            // Title
            Text(
              step.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            
            // Description
            Text(
              step.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
                height: 1.4,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
            
            // Custom content
            if (step.customContent != null) ...[
              const SizedBox(height: 16),
              step.customContent!,
            ],
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}