part of flutter_twilio_conversations;

/// Class for paginating over items retrieved using [Channels.getPublicChannelsList], [Channels.getUserChannelsList] or [Users.getChannelUserDescriptors].
///
/// [Paginator] represents a single page of results. You can get items in this page using [Paginator.items].
/// The number if items in page can be retrieved using [Paginator.pageSize].
/// If all items did not fit into single page [Paginator.hasNextPage] will return true. You could use [Paginator.requestNextPage] to get the next page of results.
/// If [Paginator.hasNextPage()] returns false, then this is the last page. Calling [Paginator.requestNextPage()] on the last page will throw [PlatformException].
class Paginator<T> {
  final Map<String, dynamic> _passOn;

  final String _itemType;

  final String _pageId;

  final List<T> _items = [];

  final int _pageSize;

  final bool _hasNextPage;

  /// Get items available in the current page.
  List<T> get items {
    return [..._items];
  }

  /// Amount of items in the current page.
  int get pageSize {
    return _pageSize;
  }

  /// If the paginator has more pages, returns true.
  bool get hasNextPage {
    return _hasNextPage;
  }

  Paginator(
    this._pageId,
    this._pageSize,
    this._hasNextPage,
    this._itemType,
    this._passOn,
  );

  /// Construct from a map.
  factory Paginator._fromMap(Map<String, dynamic> map,
      {Map<String, dynamic>? passOn}) {
    var paginator = Paginator<T>(map['pageId'], map['pageSize'],
        map['hasNextPage'], map['itemType'], passOn!);
    paginator._updateFromMap(map);
    return paginator;
  }

  /// Query the next page.
  Future<Paginator<T>> requestNextPage() async {
    try {
      final methodData = await FlutterTwilioConversationsPlatform.instance
          .requestNextPage(_pageId, _itemType);
      final paginatorMap = Map<String, dynamic>.from(methodData);
      return Paginator<T>._fromMap(paginatorMap, passOn: _passOn);
    } on PlatformException catch (err) {
      if (err.code == 'ERROR' || err.code == 'IllegalStateException') {
        rethrow;
      }
      throw ErrorInfo(int.parse(err.code), err.message, err.details as int);
    }
  }

  /// Update properties from a map.
  void _updateFromMap(Map<String, dynamic> map) {
    if (map['items'] != null) {
      final List<Map<String, dynamic>> itemsList = map['items']
          .map<Map<String, dynamic>>((r) => Map<String, dynamic>.from(r))
          .toList();
      for (final itemMap in itemsList) {
        var item;
        switch (_itemType) {
          case 'userDescriptor':
            assert(_passOn['users'] != null);
            item = (_items as List<UserDescriptor>).firstWhere(
              (c) => c._identity == itemMap['identity'],
              orElse: () => UserDescriptor._fromMap(itemMap),
            );
            break;
          case 'channelDescriptor':
            item = (_items as List<ChannelDescriptor>).firstWhere(
              (c) => c._sid == itemMap['sid'],
              orElse: () => ChannelDescriptor._fromMap(itemMap),
            );
            break;
        }
        assert(item != null);
        if (!_items.contains(item)) {
          _items.add(item);
        }
        item._updateFromMap(itemMap);
      }
    }
  }
}
