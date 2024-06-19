class MessageMethods {
  static void getChannel() {}
  static void updateMessageBody() {}
  static void setAttributes() {}
  static void getMedia() {}
}



    // fun getMedia(call: MethodCall, result: MethodChannel.Result) {
    //     val channelSid = call.argument<String>("channelSid")
    //             ?: return result.error("ERROR", "Missing 'channelSid'", null)

    //     val messageIndex = call.argument<Int>("messageIndex")?.toLong()
    //             ?: return result.error("ERROR", "Missing 'messageIndex'", null)

    //     TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
    //             override fun onSuccess(channel: Conversation) {
    //                 Log.d("TwilioInfo", "MessageMethods.getMedia => onSuccess")
    //                 channel.getMessageByIndex(messageIndex, object : CallbackListener<Message> {
    //                     override fun onSuccess(message: Message) {
    //                         Log.d("TwilioInfo", "MessageMethods.getMedia (Messages.getMessageByIndex) => onSuccess")
    //                         message.getTemporaryContentUrlsForAttachedMedia(object : CallbackListener<Map<String, String>> {
    //                             override fun onSuccess(fileUrls: Map<String, String>) {
    //                                 Log.d("TwilioInfo", "MessageMethods.getMedia (Message.Media.download) => onSuccess")
    //                                 result.success(fileUrls[fileUrls.keys.first()] as String)
    //                             }

    //                             override fun onError(errorInfo: ErrorInfo) {
    //                                 Log.d("TwilioInfo", "MessageMethods.getMedia (Message.Media.download) => onError: $errorInfo")
    //                                 result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
    //                             }
    //                         })
    //                     }

    //                     override fun onError(errorInfo: ErrorInfo) {
    //                         Log.d("TwilioInfo", "MessageMethods.updateMessageBody (Messages.getMessageByIndex) => onError: $errorInfo")
    //                         result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
    //                     }
    //                 })
    //             }

    //             override fun onError(errorInfo: ErrorInfo) {
    //                 Log.d("TwilioInfo", "MessageMethods.getMedia => onError: $errorInfo")
    //                 result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
    //             }
    //         })
    // }
