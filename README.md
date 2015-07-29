# Communications

This gem provides tools for easy and painless two-sided communication between two rails applications

# Installation

Add this line to your application's Gemfile:

`gem 'communications', github: 'sck-v/communications'`

And then execute:

`$ bundle`

# Usage

The usage is simple:

## Receiver App

1. Configure receiver

```ruby
Communications.configure do
  handle :channel_name, with: SomeHandler

  on_message_failure do |queue, payload, _|
    Rails.logger.info 'Message processing error'
  end
end
```

2. Start the reciever

```ruby
Communications::Receiver.start! rescue Bunny::TCPConnectionFailedForAllHosts
```

3. Implement Handler class

```ruby
require 'communications/handler'
  
class SomeHandler
  include Communications::Handler

  def handle(payload)
    SomeWorker.do_something_with_payload(payload)
  end
end
```

## Transmitter App

1. Publish message

```ruby
Communications::Publisher.publish(:channel_name, message_hash)
```
