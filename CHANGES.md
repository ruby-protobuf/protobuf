2.8.10
---------

- Allow passing a file extension to compile/clean rake tasks. [#143, @localshred]

2.8.9
---------

- Deprecated Protobuf::Lifecycle module in favor of using ActiveSupport::Notifications. [#139, @devin-c]
- Modify `$LOAD_PATH` inside descriptors.rb to make it easier for other libraries to write their own compiler plugins using our pre-compiled descriptors. [#141, @localshred]
- Add protobuf:clean and protobuf:compile rake tasks for use in external libraries to compile source definitions to a destination. [#142, @localshred]

2.8.8
---------

- ServiceDirectory beacons broadcast on same ip as listening clients. [#133, @devin-c]

2.8.7
---------

- Fire ActiveSupport load hooks when RPC Server and Client classes are loaded. [#126, @liveh2o]
- Prevent infinite loop when doing service lookup from directory. [#125, @brianstien]

2.8.6
---------

- Fix string/byte encoding issue when unicode characters present. Reported by @foxban. This was also backported to v2.7.12. [#120]

2.8.5
----------

- Fix issue where ServiceDirectory lookups were failing when given a class name, breaking the directory load balancing. (#119)

2.8.4
----------

- Fix issue where frozen strings assigned in a repeated field would cause encoding runtime errors. (#117)

2.8.3
----------

- Add Deprecation warning when requiring `protobuf/evented`. Version 3.x will not support the eventmachine transport layer for client or server.

2.8.2
----------

- Remove the <4.0 version constraint on ActiveSupport.

2.8.1
----------

- Improve `ServiceDirectory` lookup speed ~10x, lookups now done in constant time (devin-c).
- Add Timestamp to end of rpc stat log (represents ending time of request processing).
- Set `request_size` in the rpc stat within ZMQ Worker (previously missing).
- Ensure `request_size` and `response_size` are set on rpc stat for client requests.

2.8.0
-----------

- New compiler supports protobuf compilation/runtime with protoc <= v2.5.0 (c++ compiler removed). [#109]
- Deprecated rprotoc in favor of protoc. [0bc9674]
- Added service dynamic discovery to the ZMQ connector and server. [#91, @devin-c]
- No longer creating `-java` platform gem due to removal of c++ compiler.
- Added WTFPL license.

2.7.12
-----------

- Backport string/byte encoding issue when unicode characters present. [code: #122, original issue: #120]

2.0.0
-----------

#### `rprotoc` changes

* New option `--ruby_out` to specify the output directory to place generated ruby files. If not provided, ruby code will not be generated.
* Extends `libprotoc` to hook in directly to google's provided compiler mechanism.
* Removed all previous compiler code including the racc parser, node visitors, etc.
* See `protoc --help` for default options.

#### `rprotoc` generated files changes

* Import `require`s now occur outside of any module or class declaration which solves ruby vm warnings previously seen.
* Empty inherited Message and Enum classes are pre-defined in the file, then reopened and their fields applied. This solves the issue of recursive field dependencies of two or more types in the same file.
* Generated DSL lines for message fields include the fully qualified name of the type (e.g. `optional ::Protobuf::Field::StringField, :name, 1`)
* Support for any combination of `packed`, `deprecated`, and `default` as options to pass to a field definition.
* Services are now generated in the corresponding `.pb.rb` file instead of their own `*_service.rb` files as before.

#### `rpc_server` changes

* Removed `--env` option. The running application or program is solely in charge of ensuring it's environment is properly loaded.
* Removed reading of `PB_CLIENT_TYPE`, `PB_SERVER_TYPE` environment variables. Should use mode switches or custom requires (see below) instead.
* Removed `--client_socket` in favor of using mode switches. This also means client calls made by the `rpc_server` will run as the same connector type as the given mode (socket, zmq, or evented).
* Removed `--pre-cache-definitions` switch in favor of always pre-caching for performance.
* Removed `--gc-pause-serialization` since using `--gc-pause-request` in conjunction was redundant.
* Removed `--client-type` in favor of mode switches.
* Removed `--server-type` in favor of mode switches.
* Added mode switch `--evented`.
* Added `--threads` to specify number of ZMQ Worker threads to use. Ignored if mode is not zmq.
* Added `--print-deprecation-warnings` switch to tell the server whether or not to print deprecation warnings on field usage. Enabled by default.
* See `rpc_server help start` for all options and usage. Note: the `start` task is the default and not necessary when running the `rpc_server`.

#### Message changes

* `Message#get_field` usage should now specify either `Message#get_field_by_name` or `Message#get_field_by_tag`, depending on your lookup criteria.
* Support for STDERR output when accessing a message field which has been defined as `[deprecated=true]`. Deprecated warnings can be skipped by running your application or program with `PB_IGNORE_DEPRECATIONS=1`.
* Significant internal refactoring which provides huge boosts in speed and efficiency both in accessing/writing Message field values, as well as serialization and deserialization routines.
* Refactor `Message#to_hash` to delegate hash representations to the field values, simply collecting the display values and returning a hash of fields that are set. This also affects `to_json` output.

#### Enum changes

* Add `Enum.fetch` class method to polymorphically retrieve an `EnumValue` object.
* Add `Enum.value_by_name` to retrieve the corresponding `EnumValue` to the given symbol name.
* Add `Enum.enum_by_value` to retrieve the corresponding `EnumValue` to the given integer value.

#### RPC Service changes

* `async_responder` paradigm is no longer supported.
* `self.response=` paradigm should be converted to using `respond_with(object)`.
* Significant internal changes that should not bleed beyond the API but which make maintaining the code much easier.

#### RPC Client changes

* In the absence of `PB_CLIENT_TYPE` environment var, you should be requiring the specific connector type specifically. For instance, if you wish to run in zmq mode for client requests, update your Gemfile: `gem 'protobuf', :require => 'protobuf/zmq'`.
* `:async` option on client calls is no longer recognized.

####  Other changes

* Moved files out of `lib/protobuf/common` folder into `lib/protobuf`. Files affected are logger, wire\_type, util. The only update would need to be the require path to these files since the modules were always `Protobuf::{TYPE}`.
