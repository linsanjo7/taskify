import 'package:share_plus/share_plus.dart';

class ShareService {
  Future<void> shareTask(String title, String description) async {
    await Share.share("$title\n\n$description");
  }
}
