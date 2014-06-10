require_relative "reverse.pb.rb"

module Example
  class ReverseService
    def reverse
      respond_with :reversed => request.input.reverse
    end
  end
end
