##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf/message'
require 'protobuf/rpc/service'

module Example

  ##
  # Message Classes
  #
  class ReverseRequest < ::Protobuf::Message; end
  class ReverseResponse < ::Protobuf::Message; end


  ##
  # Message Fields
  #
  class ReverseRequest
    required :string, :input, 1
  end

  class ReverseResponse
    required :string, :reversed, 1
  end


  ##
  # Service Classes
  #
  class ReverseService < ::Protobuf::Rpc::Service
    rpc :reverse, ::Example::ReverseRequest, ::Example::ReverseResponse
  end

end

