# protobuf

[![Gem Version](https://badge.fury.io/rb/protobuf.png)](http://badge.fury.io/rb/protobuf)
[![Build Status](https://secure.travis-ci.org/localshred/protobuf.png?branch=master)](https://travis-ci.org/localshred/protobuf)

___See [CHANGES.md](https://github.com/localshred/protobuf/blob/master/CHANGES.md) for up-to-date 
 API changes.___

Protobuf is an implementation of [Google's protocol buffers][google-pb] in ruby, version 2.5.0 is currently supported.

---

## Install

You will need to install protobuf from your favorite package manager
or from source. This gem currently supports protobuf <= 2.5.0.

### OSX Install

```shell
$ brew install protobuf
```

### Ubuntu
```shell
$ sudo apt-get install -y protobuf
```

### Gem Install

Once the protobuf package is installed, install this gem with rubygems/bundler.
_Please note that this will void your warranty as it were. If you compiled with
a custom protobuf package and are having issues it may be difficult to troubleshoot._

```shell
$ gem install protobuf
```

------

## Generating ruby classes from `.proto` files

Protocol Buffers are great because they allow you to clearly define data storage
or data transfer packets. Google officially supports Java, C++, and Python for
compilation and usage. Let's make it ruby aware!

Let's say you have a `defs.proto` file that defines a User message.

```protobuf
package foo;
message User {
  optional string first_name = 1;
  optional string last_name = 2;
}
```

Now let's compile that definition to ruby:

```shell
$ protoc defs.proto --ruby_out ./lib
```

The previous line will take whatever is defined in `defs.proto` and
output ruby classes to the `./lib` directory, obeying the package
directive. Your `./lib` should now look like this:

```
- lib
  |- foo
      |- defs.pb.rb
```

The generated file `defs.pb.rb` should look something like this:

```ruby
module Foo
  class User < ::Protobuf::Message; end

  class User
    optional ::Protobuf::Field::StringField, :first_name, 1
    optional ::Protobuf::Field::StringField, :last_name, 2
  end
end
```

__Note:__ The generator will pre-define all message/enum classes empty and then
re-open to apply the defined fields. This is to prevent field dependency errors.

The generated class is now just a plain old ruby object. You can use it however you wish.

```ruby
require 'lib/foo/user.pb'

# dot notation reading/writing fields
user = Foo::User.new
user.first_name = "Lloyd"
user.last_name = "Christmas"
user.first_name     # => "Lloyd"

# or pass in the fields as a hash to the initializer
user = Foo::User.new :first_name => "Lloyd", :last_name => "Christmas"
user.first_name     # => Lloyd
user.last_name     # => Christmas
```

### Message (de)serialization

Every message object comes ready for serialization or deserialization.
Use `serialize_to_string` to write out the byte-string for the message.
Use `parse_from_string` on a new message instance to inflate the
byte-string back to a message in ruby.

```ruby
user = Foo::User.new(:first_name => 'Bob')
bytes = user.serialize_to_string
puts bytes #=> binary representation of this message object

inflated_user = Foo::User.new.parse_from_string(bytes)
inflated_user == user #=> true
```

## Callings Services with RPC

Google's Protocol Buffers provides support for Services with RPC.

For our purposes, we'll talk about a `Client` (process that is calling
the server/service), a `Service` (the remote procedure), and a `Server`
(the process that manages one or more services). We'll start with the Service first.

### Services

Services are simply classes that have endpoint methods defined. Here's what
one looks like in protobuf:

```protobuf
package foo;
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
# lib/foo/user.pb.rb
module Foo
  # UserRequest and UserList Class definitions not shown (see above for generated output of classes).

  class UserService < ::Protobuf::Rpc::Service
    rpc :find, UserRequest, UserList
  end
end
```

__Important Note: The UserService class here is a *stub*. You should not
provide your implementation in this generated file as subsequent generations
will wipe out your implmentation. Read on to learn how to use this stub.__

Now that you have a generated service stub, you'll want to require it
from `lib` and provide the implementation. Create a service implementation file
in your project. In rails I'd put this in `app/services/foo/user_service.rb`.

```ruby
# app/services/foo/user_service.rb
require 'lib/foo/user.pb'

# Reopen the class and provide the implementation for each rpc method defined.
module Foo
  class UserService

    # request -> Foo::UserRequest
    # response -> Foo::UserResponse
    def find
      # request.email will be the unpacked string that was sent by the client request
      users = []
      User.find_by_email(request.email).each do |user|
        users << user.to_proto
      end
      
      respond_with(:users => users)
    end

  end
end
```

Simply implement the instance method for the defined rpc. You can provide
any other methods in this class as helpers, but only those defined in the
proto file will be callable by remote clients. Every request made by a client
will provide a non-empty request of the defined type. The server creates a new
service instance for every request, so you should not be constrained to just
the endpoint method. This is similar to rails controllers where only methods
defined by the routes file are hooked up to HTTP requests, but it's very common
to implement private methods to aid in code quality and simpilicity.

Every instance has a `request` and `response` object used for fulfilling the call,
again, similar to a rails controller action. You should never attempt to modify the
`request` object. The `response` object however should be modified or replaced
entirely. If you need to create your own response object (a valid case), simply use
`respond_with(new_response)`. The returned object should conform to one of three properties:

1. Response should be of same type as defined by the rpc definition (in this case, `Foo::UserList`), or
2. Response should be a hash, respond to `to_hash`, or respond to `to_proto_hash`. The hash will be used to construct an instance of the defined type and should therefore conform to the appropriate fields for that type.
3. Response should respond to the `to_proto` method. The object returned by `to_proto` should be an instance of the defined response type.

If at any time the implementation encounters an error, the client can be
instructed of the error using `rpc_failed`:

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

This means that the client's `on_failure` callback will be invoked instead
of the `on_success` callback. Read more below on client callbacks. One drawback
to the `rpc_failed` approach is that it does not short-circuit the rest of
the method. This means that you must explicitly return from the method if
you do not wish the remainder to be executed.

### Service Filters

Service Filters provides ActionController-style filter support to service
instances, specifically adding `before_filter`, `after_filter`, and `around_filter`.

```ruby
require 'lib/foo/user.pb'

class Foo::UserService
  before_filter :start_request_timer
  after_filter :end_request_timer
  around_filter :benchmark_request

  # Provide a list of rpc methods to call (or exclude calling) for the given filter(s).
  # The following two filters are essentially equivalent.
  before_filter :verify_user_present, :only => [ :update, :delete ]
  before_filter :verify_user_present, :except => [ :find, :create ]

  # Using if/unless filters options to achieve the same goal, reporting a login after the login has been processed.
  # Note that you can provide a method name or lambda, but you must return a boolean value.
  after_filter :report_login, :only => :login, :if => :user_found?
  after_filter :report_login, :only => :login, :if => lambda { |service| service.response.user_guid.present? }
  after_filter :report_login, :only => :login, :unless => :user_missing?
  after_filter :report_login, :only => :login, :unless => lambda { |service| service.response.user_guid.empty? }

  #... rpc instance methods

  private

  def start_request_timer
    @time_start = Time.now
  end

  def end_request_timer
    @time_end = Time.now
    log_info { ... }
  end

  def benchmark_request
    Benchmark.benchmark do
      yield
    end
  end
end
```

#### Halting execution of rpc request inside a filter

__Around Filters__ – Inside of an around filter, if you wish to halt
request processing and return, simply do not `yield` the block. Since the
filter is implemented as an instance method, you can use `rpc_failed`
or `respond_with` just like you can in the endpoint methods.

__Before Filters__ – Returning `false` from a before filter will cancel
any other filter calls which would run afterwards, as well as canceling
invocation of the service method. _Note: You must actually return `false`,
not just a "falsey" value such as `nil`._

__After Filters__ – No request shortcutting.

#### Filter options

The following options can be applied to any of the filters as the final
argument in the filter configuration. (See example above).

__:if__ – The object supplied to `:if` can either be a symbol/string
indicating the instance method to call, or, an object that responds to `call`.
The method or callable should return true or false indicating if the
filter should be invoked or not. Akin to the `if` keyword.

__:unless__ – The opposite of the `:if` option is `:unless`. Accepts
the same object types. The method or callable should return true or
false indicating if the filter should be invoked or not. Akin to the
`unless` keyword.

__:only__ – A string/symbol or Array of strings/symbols values that
reference instance methods. The names of these methods should be the
rpc method you wish to invoke the filter for. Methods not identified
in this list would not have the filter applied.

__:except__ – The opposite of the `:only` option. A string/symbol or
Array of strings/symbols values that reference instance methods. The
names of these methods should be the rpc method you wish to skip
invokation of the given filter. Methods not identified in this list
would have the filter applied.

### Servers

Services need to be hooked up to a socket to be called by clients.
Use the provided program `rpc_server`:

```
$ rpc_server -o myserver.com -p 9399 -l ./log/protobuf.log ./config/environment.rb
```

The previous call will start a Socket server running on the given
host and port which will load your application into memory. You
certainly don't have to run rails or any other framework, just
make sure you have some kind of file that will load your services
all into memory. The server doesn't know where you put your code,
so tell it.

Be aware that the server needs to be able to translate the socket
stream of bytes into an actual protobuf request object. If the
definition for that request object aren't known to the server,
you're going to have a long day getting this going. It's necessary
to store all your definitions and their generated classes in a
shared repository (read: gem) so that both client and server have
access to the ruby classes in their respective load paths.

Once the server starts, you should see it as a running process
with `ps`. Sending a KILL, QUIT, or TERM signal to the pid will
result in shutting the server down gracefully.

```
$ ps aux | grep rpc_server
1234 ... rpc_server myserver.com:9399

$ kill -QUIT 1234
rpc_server shutdown
```

### Clients

Calling a service with a clients feels very ajaxy. If you prefer
a simpler syntax I highly recommend using [ActiveRemote](https://github.com/liveh2o/active_remote)
which was developed in conjunction with this library to make 
interacting with a remote service feel identical to using an
ActiveRecord model. Seriously, it's wicked cool.

```ruby
# require the defs from the shared gem/repo
require 'sharedgem/foo/user.pb'

# Create a request object for the method we are invoking
req = Foo::UserRequest.new(:email => 'jeff@gmail.com')

# Use the UserService class to generate a client, invoke the rpc method
# while passing the request object.
# We could also simply pass a hash to find.
Foo::UserService.client.find(req) do |client|
  # This block will be executed (registering the callbacks)
  # before the request actualy occurs.
  # the `client` param in this block is the object
  # that is created by `Foo::UserService.client`.

  # Register a block for execution when the response
  # is deemed successful from the service. Accepts
  # the unpacked response as its only parameter.
  c.on_success do |response|
    response.users.each do |user|
      puts user.inspect
    end
  end

  # Register a block for execution when the response
  # is deemed a failure. This can be either a client-side
  # or server-side failure. The object passed to the
  # block has a `message` and a `code` attribute
  # to aid in logging/diagnosing the failure.
  c.on_failure do |error|
    puts 'It failed: ' + error.message
  end
end
```

Many different options can be passed to the `.client` call above
(such as `:timeout => 600`). See the `lib/protobuf/rpc/client.rb`
and `lib/protobuf/rpc/service.rb` files for more documentation.

### Dynamic Service Discovery (ZMQ Only)
It is possible to setup the RPC server and client in a way that
allows servers/services to be dynamically discovered by client processes.

#### In the client
```ruby
ServiceDirectory.start do |config|
  config.port = 53000
end

# If your server also runs this code, it will default to the
# given port when sending beacons and have its own service
# directory. You can prevent this code from running on the
# server if needed:
unless defined?(::Protobuf::CLI)
  ServiceDirectory.start do |config|
    config.port = 53000
  end
end
```

#### Starting the server with dynamic discovery enabled
```
$ rpc_server --broadcast-beacons --beacon-port 53000 ...
```

The client will listen on the specified port for beacons broadcast
by servers. Each beacon includes a list of services provided by the
broadcasting server. The client randomly selects a server for the
desired service each time a request is made.

__CAUTION:__ When running multiple environments on a single network,
e.g., qa and staging, be sure that each environment is setup with
a unique beacon port; otherwise, clients in one environment ___will___
make requests to servers in the other environment.

Check out the source for Protobuf::ServiceDirectory for more details.

## 3. RPC Interop

The main reason I wrote this gem was to provide a ruby implementation
to google's protobuf that worked on the RPC layer with a Java Service
layer that was already running [protobuf-socket-rpc][], the supported
socket rpc library for protobuf from Google. Other ruby protobuf
implementations I've used did not provide this kind of support.

## Accreditation & Caveats

It must be noted that this gem was started originally as a fork of
the [ruby-protobuf][old gem] gem. Its authors and I were unable to
reach a communication point to be able to merge all of my RPC updates
in with their master. Unfortunately I just simply couldn't use their
RPC code and so I forked the code. Myself and others have significantly
changed the internals of the gem, including the rpc implementation, the
message/field implementation, and the compiler implementation. These
changes were made to address glaring performance and quality issues
in the code. The code was initially diverged at their 0.4.0 version.

It should also be noted that there are many more features I haven't
really shown here, so please let me know if you have any questions
on usage or support for various features. Happy protobufing.

-- BJ Neilsen, [@localshred][]

  [google-pb]: http://code.google.com/p/protobuf "Google Protocol Buffers"
  [protobuf-socket-rpc]: http://code.google.com/p/protobuf-socket-rpc/ "Google's official Socket-RPC library for protobuf"
  [old gem]: https://github.com/macks/ruby-protobuf "Macks ruby-protobuf on github"
  [@localshred]: http://twitter.com/localshred "Follow on twitter @localshred"
