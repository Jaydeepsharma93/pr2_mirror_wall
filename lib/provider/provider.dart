import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../view/url.dart';


class MainProvider extends ChangeNotifier {
  double progress = 0;
  String searchtext = 'Google';
  String newsearchtext = '';

  String groupValue = 'Google';
  List searchEngineNames = ['Google', 'Bing', 'Duck Duck Go', 'Yahoo'];
  String selectedSearchEngine = 'Google';
  String? searchedUrl;
  bool isButtonEnabled = true;

  List<String> bookmarkList = [];
  String? currentUrl;
  List<String> historylist = [];
  String? searchvalue;

  Future<void> onchange_progress(int progress) async {
    this.progress = progress / 100;
    notifyListeners();
  }

  Future<bool> timePass() async {
    if (isButtonEnabled) {
      await inAppWebViewController.goBack();
      return true;
    }

    notifyListeners();
    return false;
  }

  void search(String searchtext) {
    this.searchtext = searchtext;
    notifyListeners();
  }

  Future<void> setcurrentUrl() async {
    WebUri? webUri = await inAppWebViewController.getUrl();
    currentUrl = await inAppWebViewController.getTitle() as String;
    notifyListeners();
  }

  void addtoBookMark() {
    bookmarkList.add(currentUrl!);
    notifyListeners();
  }

  void addtoHistory() {
    historylist.add(currentUrl!);
    notifyListeners();
  }

  void updateSearchEngine(String value) {
    selectedSearchEngine = value;
    if (selectedSearchEngine == 'Google') {
      inAppWebViewController.loadUrl(
          urlRequest: URLRequest(url: WebUri("https://www.google.com/")));
    } else if (selectedSearchEngine == 'Yahoo') {
      inAppWebViewController.loadUrl(
          urlRequest: URLRequest(url: WebUri("https://in.search.yahoo.com/")));
    } else if (selectedSearchEngine == 'Bing') {
      inAppWebViewController.loadUrl(
          urlRequest: URLRequest(url: WebUri("https://www.bing.com/")));
    } else if (selectedSearchEngine == 'Duck Duck Go') {
      inAppWebViewController.loadUrl(
          urlRequest: URLRequest(url: WebUri("https://duckduckgo.com/")));
    }
    notifyListeners();
  }

  void updateSearchEngineGroupValue(String value) {
    groupValue = value;
    notifyListeners();
  }

  void searchEngines() {
    if (selectedSearchEngine == 'Google') {
      inAppWebViewController.loadUrl(
          urlRequest: URLRequest(
              url: WebUri(
                  "https://www.google.com/search?q=$newsearchtext&rlz=1C1ONGR_enIN1095IN1095&oq=hi&gs_lcrp=EgZjaHJvbWUqDggAEEUYJxg7GIAEGIoFMg4IABBFGCcYOxiABBiKBTIGCAEQRRg7Mg0IAhAAGIMBGLEDGIAEMg0IAxAuGIMBGLEDGIAEMhAIBBAAGIMBGLEDGIAEGIoFMg0IBRAAGIMBGLEDGIAEMhYIBhAuGIMBGMcBGLEDGNEDGIAEGIoFMgcIBxAAGIAEMgcICBAAGIAEMhAICRAuGIMBGLEDGIAEGIoF0gEJMTIzNmowajE1qAIJsAIB&sourceid=chrome&ie=UTF-8")));
    } else if (selectedSearchEngine == 'Yahoo') {
      inAppWebViewController.loadUrl(
          urlRequest: URLRequest(
              url: WebUri(
                  "https://in.search.yahoo.com/search;_ylt=AwrPoYNX0lFm3wcpV0y7HAx.;_ylc=X1MDMjExNDcyMzAwMwRfcgMyBGZyA2NybWFzBGZyMgNzYi10b3AEZ3ByaWQDZlRUNGtwSXdUSjZmZURhT2FPdnRXQQRuX3JzbHQDMARuX3N1Z2cDMTAEb3JpZ2luA2luLnNlYXJjaC55YWhvby5jb20EcG9zAzAEcHFzdHIDBHBxc3RybAMwBHFzdHJsAzExBHF1ZXJ5A2ZsdXR0ZXIlMjBkZXYEdF9zdG1wAzE3MTY2MzgzMDE-?p=$newsearchtext &fr2=sb-top&fr=crmas&vm=r")));
    } else if (selectedSearchEngine == 'Bing') {
      inAppWebViewController.loadUrl(
          urlRequest: URLRequest(
              url: WebUri(
                  "https://www.bing.com/search?q=$newsearchtext&qs=n&form=QBRE&sp=-1&lq=0&pq=flutter+dev&sc=19-11&sk=&cvid=B4B782306ED143AE9326650EBDDC17DC&ghsh=0&ghacc=0&ghpl=")));
    } else if (selectedSearchEngine == 'Duck Duck Go') {
      inAppWebViewController.loadUrl(
          urlRequest: URLRequest(
              url: WebUri("https://duckduckgo.com/?q=$newsearchtext&ia=web")));
    }
  }

  void checkIfShouldGoBack() {
    if (searchedUrl == 'https://www.google.com/' ||
        searchedUrl == 'https://in.search.yahoo.com/' ||
        searchedUrl == 'https://www.bing.com/' ||
        searchedUrl == 'https://duckduckgo.com/') {
      // print(searchedUrl);
      isButtonEnabled = false;
      notifyListeners();
    } else {
      isButtonEnabled = true;
      notifyListeners();
    }
  }

  void updateSearchedText(String text) {
    newsearchtext = text;
    notifyListeners();
  }
}
