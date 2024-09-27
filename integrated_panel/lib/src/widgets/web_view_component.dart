import 'package:flutter/material.dart';
import 'package:integrated_panel/src/utils/logger.dart';
import 'package:integrated_panel/src/widgets/loader.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  const WebViewScreen({super.key, required this.url});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  // #docregion platform_features
  String? stringurl;
  bool isLoading = false;
  final WebViewController _controller = WebViewController();
  
  
  @override
  void initState() {
    super.initState();
    stringurl = widget.url;
    var delegate = NavigationDelegate(onPageStarted: (url) {
      if (!mounted) return;
      setState(() { 
        isLoading = true; 
        stringurl = url;
      });
       
    },onPageFinished: (url) {
      if (!mounted) return;
      setState((){ isLoading = false;stringurl = url;},);
      Logger.info(url); 
      if(stringurl!.contains("rejectionID=")){
        Navigator.of(context).pop(stringurl);
      } 
      if(stringurl!.contains("pgtid=22")){
        Navigator.of(context).pop("success");
      }
    },
    );
    _controller.setNavigationDelegate(delegate);
    _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    _controller.platform.currentUrl();
    _controller.loadRequest(Uri.parse(stringurl!));
      
  }

  @override
  void dispose() {
    _controller.clearCache();
    _controller.loadRequest(Uri.parse('about:blank')); // Load a blank page to stop the WebView
    super.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
        appBar: AppBar(
          toolbarHeight: 35,
          leading: IconButton(onPressed: ()=>
            Navigator.of(context).pop("closed")
          , icon: const Icon(Icons.close))
        ),
      body: isLoading ? const ProgressBar() :
        WebViewWidget(controller: _controller)
    );
  }
}

class BottomToTopPageRoute extends PageRouteBuilder {
  final Widget widget;

  BottomToTopPageRoute({required this.widget})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: const Offset(0, 0),
                )
                    .animate(CurvedAnimation(
                      curve: Curves.easeInOut, // Adjust curve as desired
                      parent: animation,
                    )),
                child: child,
              ),
        );
}
