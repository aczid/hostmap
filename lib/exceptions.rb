module HostMap

  #
  # Custom exceptions.
  #
  module Exception

    #
    # The result enumerated is a not valid result.
    #
    class EnumerationError < ArgumentError
      include Exception

      def initialize(opts = [])
        @opts = opts
      end

      def to_s
        "The found enumeration is a not valid result: #{@opts.join(', ')}"
      end
    end

    #
    # The supplied target is not valid.
    #
    class TargetError < ArgumentError
      include Exception

      def initialize(args)
        @args = args
      end

      def to_s
        "The supplied target is not valid: #{@args}"
      end
    end

  end
end