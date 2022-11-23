abstract class SharePrincipal {
  String getId();

  String getLabel();

  String? getSvgIconAsset();

  Map<String, dynamic> toMap();
}
