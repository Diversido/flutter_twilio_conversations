class MessageMethods {
  void getChannel() {}

  /*pluginInstance: TwilioConversationsPlugin, call: MethodCall, result: MethodChannel.Result) {
        val channelSid = call.argument<String>("channelSid")
                ?: return result.error("ERROR", "Missing 'channelSid'", null)

        TwilioConversationsPlugin.chatClient?.getConversation(channelSid, object : CallbackListener<Conversation> {
            override fun onSuccess(channel: Conversation) {
                Log.d("TwilioInfo", "MessageMethods.getChannel => onSuccess")
                result.success(Mapper.channelToMap(pluginInstance, channel))
            }

            override fun onError(errorInfo: ErrorInfo) {
                Log.d("TwilioInfo", "MessageMethods.getChannel => onError: $errorInfo")
                result.error("${errorInfo.code}", errorInfo.message, errorInfo.status)
            }
        })*/
}
