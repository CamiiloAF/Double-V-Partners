import 'package:flutter/material.dart';

import '../../../../../shared/theme/app_colors_theme.dart';

class FormSectionContainer extends StatelessWidget {
  const FormSectionContainer({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    this.trailing,
    this.onRemove,
    this.showRemoveButton = false,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;
  final Widget? trailing;
  final VoidCallback? onRemove;
  final bool showRemoveButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColorsTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColorsTheme.primary, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColorsTheme.headline,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
              if (showRemoveButton && onRemove != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColorsTheme.error,
                  ),
                  tooltip: 'Eliminar dirección',
                ),
              ],
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }
}
