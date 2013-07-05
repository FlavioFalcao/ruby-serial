class Class

  attr_reader :dont_rubyserial_lst
  attr_reader :rubyserial_only_lst

  # Mark some attributes to not be serialized
  #
  # Parameters::
  # * *lst* (<em>list<Symbol></em>): List of attributes symbols
  def dont_rubyserial(*lst)
    lst = [lst] if (!lst.is_a?(Array))
    @dont_rubyserial_lst = [] if (!defined?(@dont_rubyserial_lst))
    @dont_rubyserial_lst.concat(lst.map { |var_name| "@#{var_name.to_s}".to_sym })
    @dont_rubyserial_lst.uniq!
  end

  # Mark some attributes to be serialized
  #
  # Parameters::
  # * *lst* (<em>list<Symbol></em>): List of attributes symbols
  def rubyserial_only(*lst)
    lst = [lst] if (!lst.is_a?(Array))
    @rubyserial_only_lst = [] if (!defined?(@rubyserial_only_lst))
    @rubyserial_only_lst.concat(lst.map { |var_name| "@#{var_name.to_s}".to_sym })
    @rubyserial_only_lst.uniq!
  end

end
