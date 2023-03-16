class Utils {
  static String mediaSize(int bitsPerSec, int length) {
    var totalBytes = (bitsPerSec * (length / 1000)) / 8;
    if (totalBytes == 0) {
      return "-";
    } else {
      var sizeInMegabytes = totalBytes / (1024 * 1024);

      if (sizeInMegabytes < 1) {
        return "Size: 1 MB";
      } else if (sizeInMegabytes < 1000) {
        return "Size: ${sizeInMegabytes.toStringAsFixed(1)} MB";
      } else {
        var size = (sizeInMegabytes / 1024).toStringAsFixed(1);
        return "Size: $size GB";
      }
    }
  }
}
