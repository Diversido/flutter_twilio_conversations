import 'package:flutter_twilio_conversations_platform_interface/flutter_twilio_conversations_platform_interface.dart';
import 'package:js/js.dart';

@JS('Twilio.Conversations.Paginator')
class TwilioPaginator<T> {
  external bool get hasNextPage;
  external bool get hasPrevPage;
  external List<T> get items;
}

extension Interop on TwilioPaginator {
  PaginatorModel toModel() {
    return PaginatorModel(
        hasNextPage: hasNextPage, hasPrevPage: hasPrevPage, items: items);
  }
}
