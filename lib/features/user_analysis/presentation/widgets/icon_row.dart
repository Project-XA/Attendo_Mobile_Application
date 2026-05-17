
import 'package:flutter/widgets.dart';

class IconRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const IconRow({
    required this.icon,
    required this.label,
    required this.color,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
