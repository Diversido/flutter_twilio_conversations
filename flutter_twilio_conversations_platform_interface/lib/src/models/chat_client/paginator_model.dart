import 'package:flutter_twilio_conversations/flutter_twilio_conversations.dart';

/// Model that a plugin implementation can use to construct a ChatClient.
class PaginatorModel<T> {
  final bool hasNextPage;
  final bool hasPrevPage;
  final List<T> items;

  const PaginatorModel({
    required this.hasNextPage,
    required this.hasPrevPage,
    required this.items,
  });
}
