import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CommonCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final List<BoxShadow>? shadow;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool hasBorder;
  final Color? borderColor;

  const CommonCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.shadow,
    this.backgroundColor,
    this.borderRadius,
    this.onTap,
    this.hasBorder = false,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(vertical: Constants.spacingS),
      child: Material(
        color: backgroundColor ?? Constants.cardColor,
        borderRadius: borderRadius ?? Constants.borderRadiusL,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.1),
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? Constants.borderRadiusL,
          child: Container(
            padding: padding ?? EdgeInsets.all(Constants.spacingL),
            decoration: BoxDecoration(
              borderRadius: borderRadius ?? Constants.borderRadiusL,
              border: hasBorder
                  ? Border.all(
                      color: borderColor ?? Constants.borderColor,
                      width: 1,
                    )
                  : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String description;
  final String? date;
  final String? location;
  final VoidCallback? onTap;
  final String? price;
  final bool isClickable;

  const EventCard({
    Key? key,
    required this.title,
    required this.description,
    this.date,
    this.location,
    this.onTap,
    this.price,
    this.isClickable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      onTap: isClickable ? onTap : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Constants.titleLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (price != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Constants.spacingM,
                    vertical: Constants.spacingXS,
                  ),
                  decoration: BoxDecoration(
                    color: Constants.primaryLightColor,
                    borderRadius: Constants.borderRadiusM,
                  ),
                  child: Text(
                    price!,
                    style: Constants.labelMedium.copyWith(
                      color: Constants.primaryColor,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: Constants.spacingS),
          Text(
            description,
            style: Constants.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (date != null || location != null) ...[
            SizedBox(height: Constants.spacingM),
            Row(
              children: [
                if (date != null) ...[
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Constants.textSecondaryColor,
                  ),
                  SizedBox(width: Constants.spacingXS),
                  Text(
                    date!,
                    style: Constants.bodySmall,
                  ),
                  SizedBox(width: Constants.spacingL),
                ],
                if (location != null) ...[
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Constants.textSecondaryColor,
                  ),
                  SizedBox(width: Constants.spacingXS),
                  Expanded(
                    child: Text(
                      location!,
                      style: Constants.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class EmptyStateCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? action;
  final String? actionLabel;

  const EmptyStateCard({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
    this.actionLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Constants.textMutedColor,
          ),
          SizedBox(height: Constants.spacingL),
          Text(
            title,
            style: Constants.titleMedium,
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            SizedBox(height: Constants.spacingS),
            Text(
              subtitle!,
              style: Constants.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
          if (action != null && actionLabel != null) ...[
            SizedBox(height: Constants.spacingL),
            ElevatedButton(
              onPressed: action,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
