# protobuf

Protobuf is an implementation of [Google's protocol buffers][google-pb] in ruby. It's a gem for managing 3 things:

1. Compiling `.proto` definitions to ruby
2. Provide a Socket-RPC mechanism for calling services
3. Provide RPC interop between ruby and other protobuf-rpc aware implementations for different languages (e.g. [protobuf-socket-rpc][])

So let's dive in and see how to work with all three.

## 1. Compile `.proto` definitions to ruby

Protocol Buffers are great because they allow you to clearly define data storage or data transfer packets. Google officially supports Java, C++, and Python for compilation and usage. Let's make it ruby aware!

Let's say you have a `defs.proto` file that defines a User message.

```
package mycompany;
message User {
  required string first_name = 1;
  required string last_name = 1;
}

Now let's compile that definition to ruby:

$ rprotoc defs.proto -o ./lib
```

The previous line will take whatever is defined in defs.proto and output ruby classes to the `./lib` directory, obeying the package directive. Assuming that's all defs.proto had defined, `./lib` should now look like this:

```
- lib
  |- mycompany
      |- defs.pb.rb
```

And `defs.pb.rb` should look like this:

```ruby
module Mycompany
  class User
    optional :string, :first_name, 1
    optional :string, :last_name, 2
  end
end
```

You can then use that class just like normal:

```ruby
require 'lib/mycompany/user.pb'

# dot notation reading/writing fields
user = Mycompany::User.new
user.first_name = "Lloyd"
user.last_name = "Christmas"
user.first_name     # => "Lloyd"

# or pass in the fields as a hash to the initializer
user = Mycompany::User.new :first_name => "Lloyd", :last_name => "Christmas"
user.first_name     # => Lloyd
user.last_name     # => Christmas
```

------------------

## 2. RPC

RPC is one of many technologies that tries to solve the problem of getting smaller pieces of data from one place to another. Many will argue for or against RPC and its usefulness, but I'm not going to do that here. Google's Protocol Buffers relies on RPC and that's why you're here.

Any discussion about RPC leads to a discussion about clients and servers and the remote procedures themselves. For our purposes, we'll talk about a `Client` (process that is calling the server/service), a `Service` (the remote procedure), and a `Server` (the process that manages one or more services). We'll start with the Service first.

### Services

Services are simply classes that have endpoint methods defined. Here's what one looks like in protobuf:

```
message UserRequest {
  optional string email = 1;
}
message UserList {
  repeated User users = 1;
}
service UserService {
  rpc Find (UserRequest) returns (UserList);
}
```

And the equivalent ruby stub for the service (generated with `rprotoc`):

```ruby
# lib/mycompany/user_service.rb
module Mycompany
  class UserService < Protobuf::Rpc::Service
    rpc :find, UserRequest, UserList
  end
end
```

Recognize that the extra messages would actually have gone into the `defs.pb.rb` file while the service stub would receive it's own file at `user_service.rb`.

**Important Note: The *stubbed* class here is a *stub*. You should not alter it directly in any way as it will break your definition. Read on to learn how to use this stub.**

Did you read the note above? Go read it. I'll wait.

Ok, now that you have a compiled service stub, you'll want to require it from `lib` and implement the methods. You'll notice when you compile the stub there is a large comment at the top of the file. You can use this code comment to start your real implementation. Go ahead and copy it to your services directory (probably `app/services` if we're in rails).

```ruby
# app/services/user_service.rb
require 'lib/mycompany/user_service'
module Mycompany
  class UserService
  
    # request -> Mycompany::UserRequest
    # response -> Mycompany::UserResponse
    def find
      # request.email will be the unpacked string that was sent by the client request
      User.find_by_email(request.email).each do |user|
        # must only use a proto instance of Mycompany::User when appending to the `users` field
        response.users << user.to_proto
      end
    end
    
  end
end
```

Simply implement the instance method for the defined rpc. No other methods will be allowed in the class (even helpers or private methods). An implicit `request` and `response` object are provided for you, pre-instantiated, and in the case of the request, already are populated with the data that was sent by the client.

If you need to create your own response object (a valid case), be sure to assign it back to the instance by using `self.response = your_response_obj`. The object you assign **MUST** be of the defined return type, in this case `Mycompany::UserList`. Any other type will result in an error.

Triggering an error from the service is simple:

```ruby
#...
def find
  if request.email.blank?
    rpc_failed 'Unable to find user without an email'
  else
    # query/populate response
  end
end
#...
```

This means that the client's `on_failure` callback will be invoked instead of the `on_success` callback. Read more below on client callbacks.

I find it very convenient to use a CRUD-style interface when defining certain data services, though this is certainly not always the case.

### Servers

A service is nothing without being hooked up to a socket. It's the nerdy kid waiting by the telephone for someone to call without knowing that the phone company disconnected their house. Sad and pathetic. So hook the phone lines!

```
$ rpc_server -o myserver.com -p 9939 -e production -l ./log/protobuf.log config/environment.rb
```

The previous call will start an EventMachine server running on the given host and port which will load your application into memory. You certainly don't have to run rails or any other framework, just make sure you have some kind of file that will load your services all into memory. The server doesn't know where you put your code, so tell it.

Be aware that server needs to be able to translate the socket stream of bytes into an actual protobuf request object. If the definition for that request object aren't known to the server, you're going to have a long day getting this going. It's necessary to store all your definitions and their generated classes in a shared repository (read: gem) that both client and server have access to in their respective load paths.

Once the server starts, you should see it as a running process with `ps`. Sending a KILL, QUIT, or TERM signal to the pid will result in shutting the server down gracefully.

```
$ ps aux | grep rpc_server
1234 ... rpc_server myservice.com:9939

$ kill -QUIT 1234
rpc_server shutdown
```

### Clients

A lot of work has gone into making the client calls simple and easy to use yet still powerful. Clients have a DSL that feels very ajax-ish, mostly because of the nature of EventMachine, but I also think it works quite well.

```ruby
# require the defs from the shared gem/repo
require 'sharedgem/mycompany/user.pb'
require 'sharedgem/mycompany/user_service'

# Create a request object for the method we are invoking
req = Mycompany::UserRequest.new(:email => 'jeff@gmail.com')

# Use the UserService class to generate a client, invoke the rpc method
# while passing the request object
Mycompany::UserService.client.find(req) do |c|
  # This block will be executed (registering the callbacks)
  # before the request actualy occurs.
  # the `c` param in this block is the `.client` object
  # that is generated from the call above
  
  # Register a block for execution when the response
  # is deemed successful from the service. Accepts
  # the unpacked response as its only parameter
  c.on_success do |response|
    response.users.each do |u|
      puts u.inspect
    end
  end
  
  # Register a block for execution when the response
  # is deemed a failure. This can be either a client-side
  # or server-side failure. The object passed the to the
  # block has a `message` and a `code` attribute
  # to aid in logging/diagnosing the failure.
  c.on_failure do |err|
    puts 'It failed: ' + err.message
  end
end
```

Many different options can be passed to the `.client` call above (such as `:async => true` or `:timeout => 600`). See the `lib/protobuf/rpc/client.rb` and `lib/protobuf/rpc/service.rb` files for more documentation. It hsould be noted that the default behavior of `UserService.client` is to return a blocking client. The nature of using Client calls within an framework like Rails demands a blocking call if the response of a web request is dependent on data returned from the service.

-------------

## 3. RPC Interop

The main reason I wrote this gem was to provide a ruby implementation to google's protobuf that worked on the RPC layer with a Java Service layer that was already running [protobuf-socket-rpc][], the supported socket rpc library for protobuf from Google. The [old gem][] did not provide a very robust RPC implementation and it most certainly did not work with the Java stack.

--------------

## Accreditation & Caveats

It must be noted a large amount of the code in this library was taken from the [ruby-protobuf][old gem] gem. Its authors and I were unable to reach a communication point to be able to merge all of my RPC updates in with their master. Unfortunately I just simply couldn't use their RPC code and so I've decided to diverge from their codeset. I take no credit whatsoever for the (de)serialization and `rprotoc` code generation original work, though I have modified it slightly to be more compliant with my understanding of the pb spec. I want to say thanks to the original devs for the good work they did to get me most of the way there. The code was initially diverged at their 0.4.0 version.

It should also be noted that there are many more features I haven't really shown here, so please let me know if you have any questions on usage or support for various features. Happy protobufing.

-- BJ Neilsen, [@localshred][], [rand9.com][]

  [google-pb]: http://code.google.com/p/protobuf "Google Protocol Buffers"
  [protobuf-socket-rpc]: http://code.google.com/p/protobuf-socket-rpc/ "Google's official Socket-RPC library for protobuf"
  [old gem]: https://github.com/macks/ruby-protobuf "Macks ruby-protobuf on github"
  [@localshred]: http://twitter.com/localshred "Follow on twitter @localshred"
  [rand9.com]: http://rand9.com "Blog"
