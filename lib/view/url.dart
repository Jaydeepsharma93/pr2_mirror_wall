import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pr2_mirror_wall/view/history.dart';
import 'package:provider/provider.dart';

import '../provider/provider.dart';

late InAppWebViewController inAppWebViewController;
TextEditingController txtsearch = TextEditingController();

PullToRefreshController pullToRefreshController = PullToRefreshController(
  onRefresh: () {
    inAppWebViewController.reload();
  },
);

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          bottom: PreferredSize(
        preferredSize: Size.fromHeight(20),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            controller: txtsearch,
            decoration: InputDecoration(
                prefixIcon: Spacer(),
                suffixIcon: Icon(Icons.search),
                hintText: 'Search or type URL',
                fillColor: Colors.white,
                filled: true,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                contentPadding: EdgeInsets.symmetric(vertical: 10)),
            onFieldSubmitted: (value) {
              Provider.of<MainProvider>(context, listen: false)
                  .updateSearchedText(value);
              Provider.of<MainProvider>(context, listen: false).searchEngines();
              txtsearch.clear();
            },
          ),
        ),
      )),
      body: StreamBuilder(
          stream: Connectivity().onConnectivityChanged,
          builder: (context, snapshot) {
            if (snapshot.data!.contains(ConnectivityResult.mobile) ||
                snapshot.data!.contains(ConnectivityResult.wifi)) {
              return Stack(
                children: [
                  InAppWebView(
                    initialUrlRequest: URLRequest(
                      url: WebUri('https://www.google.com/'),
                    ),
                    onWebViewCreated: (controller) {
                      inAppWebViewController = controller;
                    },
                    onProgressChanged: (controller, progress) {
                      Provider.of<MainProvider>(context, listen: false)
                          .onchange_progress(progress);
                    },

                    // for the History add and show
                    onLoadStart: (controller, url) {
                      // Provider.of<MainProvider>(context, listen: false)
                      //     .setcurrentUrl(url.toString());

                      Provider.of<MainProvider>(context, listen: false)
                          .addtoHistory();
                    },

                    // for the add to fav site
                    onLoadStop: (controller, url) {
                      // Provider.of<MainProvider>(context, listen: false)
                      //     .setcurrentUrl(url.toString());
                      //
                      // Provider.of<MainProvider>(context, listen: false)
                      //     .addtoHistory();

                      Provider.of<MainProvider>(context, listen: false)
                          .setcurrentUrl();
                      pullToRefreshController.endRefreshing();
                    },
                    pullToRefreshController: pullToRefreshController,
                  ),
                  (Provider.of<MainProvider>(context, listen: true).progress <
                          1)
                      ? Align(
                          alignment: Alignment.topCenter,
                          child: LinearProgressIndicator(
                            color: Colors.blueAccent,
                            value:
                                Provider.of<MainProvider>(context, listen: true)
                                    .progress,
                          ),
                        )
                      : Container(),
                ],
              );
            } else {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text('no internet access')
                ],
              ));
            }
          }),
      bottomNavigationBar: Container(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                disabledColor: Colors.red,
                onPressed: Provider.of<MainProvider>(context, listen: false)
                        .isButtonEnabled
                    ? () {
                        if (Provider.of<MainProvider>(context, listen: false)
                            .isButtonEnabled) {
                          inAppWebViewController.goBack();
                        } else {
                          return;
                        }
                      }
                    : null,
                icon: Icon(Icons.arrow_back_ios_new)),
            IconButton(
                onPressed: () {
                  inAppWebViewController.goForward();
                },
                icon: Icon(Icons.arrow_forward_ios)),
            IconButton(
                onPressed: () {
                  inAppWebViewController.reload();
                },
                icon: Icon(Icons.refresh)),
            IconButton(
                onPressed: () {
                  Provider.of<MainProvider>(context, listen: false)
                      .addtoBookMark();
                },
                icon: Icon(Icons.looks_one_outlined)),
            PopupMenuButton(
              onSelected: (value) {
                if (value == 'Feedback') {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Consumer<MainProvider>(
                        builder: (context, mainProvider, child) {
                          return ListView.builder(
                            itemCount: mainProvider.bookmarkList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(mainProvider.bookmarkList[index]),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                } else if (value == 'History') {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const History(),
                  ));
                } else if (value == 'Engine') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Search Engines"),
                        content: Container(
                          height: 240,
                          width: 400,
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  itemCount: 4,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) =>
                                      RadioListTile(
                                    title: Text(Provider.of<MainProvider>(
                                            context,
                                            listen: true)
                                        .searchEngineNames[index]),
                                    value: Provider.of<MainProvider>(context,
                                            listen: true)
                                        .searchEngineNames[index],
                                    groupValue: Provider.of<MainProvider>(
                                            context,
                                            listen: true)
                                        .groupValue,
                                    onChanged: (value) {
                                      Provider.of<MainProvider>(context,
                                              listen: false)
                                          .updateSearchEngineGroupValue(value!);
                                      Navigator.pop(context);
                                      Provider.of<MainProvider>(context,
                                              listen: false)
                                          .updateSearchEngine(value!);

                                      print(value);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
              itemBuilder: (context) => <PopupMenuEntry>[
                PopupMenuItem(value: 'Engine', child: Text('Search Engine')),
                PopupMenuItem(value: 'Feedback', child: Text('Feedback')),
                PopupMenuItem(value: 'History', child: Text('History')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
