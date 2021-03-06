module RubySerialTest

  # Define classes used by various test cases.
  # Those classes are data samples.
  module Common

    # Simple data container
    class DataContainer

      attr_accessor :attr1
      attr_accessor :attr2
      attr_accessor :attr3

      def initialize
        @attr1 = 'String attribute'
        @attr2 = 666
        @attr3 = [45, 75, 95]
      end

      def to_a
        [@attr1, @attr2, @attr3]
      end

      def ==(other)
        ((other.class == self.class) &&
                ((other.object_id == object_id) ||
                 (other.to_a == to_a)))
      end

      def eql?(other)
        to_a.eql?(other.to_a)
      end

      def hash
        to_a.hash
      end

    end

    # Generic data container that can have its instance variables set using a Hash
    class GenericContainer

      def fill(data_set, var_name_prefix = '')
        data_set.each do |var_name, var|
          instance_variable_set("@#{var_name_prefix}#{var_name}".to_sym, var)
        end
      end

      def to_a
        instance_variables.map { |var_name| instance_variable_get(var_name) }
      end

      def ==(other)
        ((self.class == other.class) && (to_a == other.to_a))
      end

    end

    # Simple data container with a constructor
    class DataContainerWithConstructor < DataContainer
      def initialize(attr1)
        super()
        @attr1 = attr1
      end
    end

    # Simple data container tracking when it is serialized
    class DataContainerWithOnDump < DataContainer

      dont_rubyserial :ondump_called

      def initialize
        super
        @ondump_called = false
      end

      def ondump_called?
        @ondump_called
      end

      def rubyserial_ondump
        @ondump_called = true
        # Create a new instance variable to be serialized
        @new_var = 'Variable set by ondump'
      end

    end

    # Simple data container tracking when it is deserialized
    class DataContainerWithOnLoad < DataContainer

      dont_rubyserial :onload_called

      def initialize
        super
        @onload_called = false
        @loaded_vars = nil
      end

      def onload_called?
        @onload_called
      end

      attr_reader :loaded_vars

      def rubyserial_onload
        @onload_called = true
        @loaded_vars = instance_variables.clone
      end

    end

    # Objects that can share the same reference when duplicated (even as Hash keys)
    DATA_SAMPLES_SHAREABLE = {
      'Array' => [1, 2, 3],
      'Hash' => { 1 => 2, 3 => 4 },
      'Object' => DataContainer.new,
      'ObjectWithConstructor' => DataContainerWithConstructor.new(256)
    }

    # Objects that can share the same reference when duplicated except when used as Hash keys
    DATA_SAMPLES_SHAREABLE_EXCEPT_AS_HASH_KEYS = {
      'String' => 'My test string'
    }.merge(DATA_SAMPLES_SHAREABLE)

    # All data samples to test
    DATA_SAMPLES = {
      'Fixnum' => 123_456,
      'Float' => 1.23456,
      'Symbol' => :TestSymbol,
      'Nil' => nil,
      'True' => true,
      'False' => false,
      'Encoding' => Encoding::UTF_8,
      'Range' => (42..64)
    }.merge(DATA_SAMPLES_SHAREABLE_EXCEPT_AS_HASH_KEYS)

    # Versions to be tested
    VERSIONS = [
      '1'
    ]

  end

end
