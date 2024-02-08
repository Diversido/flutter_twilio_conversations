# flutter_twilio_conversations_example

Demonstrates how to use the `flutter_twilio_conversations` plugin. Includes: authorization by JWT-token, presenting the list of dialogs, showing the list of messages, sending texts & images, using local notifiations to notify about new messages. To setup push notifications use [Twilio's Official Setup Guide](https://www.twilio.com/docs/conversations/push-notification-configuration)

## Supported platforms
* Android
* iOS

## Prerequisites

This example makes use of a backend, to setup a backend and make it reachable on the internet we decided
to use Firebase in this project. Therefore you need to do some setup steps to get this example up and
running. Also we are going to be using Twilio Conversations, which also needs some setup before
getting started.

1. [Create a Twilio account](https://www.twilio.com/referral/j7GFTv)
2. [Create a Firebase account](https://firebase.google.com/)

## Required plans on Twilio
Please note the following about costs and required plans on these accounts. On Twilio you will get $15
on your Trial account. This should be enough to start testing Conversations.

## Required plans on Firebase
On Firebase you will kick off in the [Spark plan](https://firebase.google.com/pricing). But you will need
to upgrade to the Blaze plan. Don't be scared for any costs, because:

> The Spark plan allows outbound network requests only to Google-owned services. Inbound invocation requests are
> allowed within the quota. On the Blaze plan, Cloud Functions provides a perpetual free tier. The first 2,000,000
> invocations, 400,000 GB-sec, 200,000 CPU-sec, and 5 GB of Internet egress traffic is provided for free each month.
> You are only charged on usage past this free allotment. Pricing is based on total number of invocations, and
> compute time. Compute time is variable based on the amount of memory and CPU provisioned for a function. Usage
> limits are also enforced through daily and 100s quotas. For more information, see [Cloud Functions Pricing](https://cloud.google.com/functions/pricing).