// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:meta/meta.dart' show required;

import 'method_channel_flutter_twilio_conversations.dart';

/// The interface that implementations of url_launcher must implement.
///
/// Platform implementations that live in a separate package should extend this
/// class rather than implement it as `url_launcher` does not consider newly
/// added methods to be breaking changes. Extending this class (using `extends`)
/// ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by
/// newly added [FlutterTwilioConversationsPlatform] methods.
abstract class FlutterTwilioConversationsPlatform {
  /// The default instance of [FlutterTwilioConversationsPlatform] to use.
  ///
  /// Platform-specific plugins should override this with their own
  /// platform-specific class that extends [FlutterTwilioConversationsPlatform] when they
  /// register themselves.
  ///
  /// Defaults to [MethodChannelFlutterTwilioConversations].
  static FlutterTwilioConversationsPlatform instance = MethodChannelFlutterTwilioConversations();

  /// Returns `true` if this platform is able to launch [url].
  Future<bool> canLaunch(String url) {
    throw UnimplementedError('canLaunch() has not been implemented.');
  }

  /// Returns `true` if the given [url] was successfully launched.
  ///
  /// For documentation on the other arguments, see the `launch` documentation
  /// in `package:url_launcher/url_launcher.dart`.
  Future<bool> launch(
    String url, {
    required bool useSafariVC,
    required bool useWebView,
    required bool enableJavaScript,
    required bool enableDomStorage,
    required bool universalLinksOnly,
    required Map<String, String> headers,
  }) {
    throw UnimplementedError('launch() has not been implemented.');
  }

  /// Closes the WebView, if one was opened earlier by [launch].
  Future<void> closeWebView() {
    throw UnimplementedError('closeWebView() has not been implemented.');
  }
}