class Kredis::Types::Set < Kredis::Types::Proxy
  def elements
    smembers
  end

  def add(elements)
    sadd elements if Array(elements).any?
  end
  alias << add

  def remove(elements)
    srem elements if Array(elements).any?
  end

  def includes?(element)
    sismember(element)
  end

  def size
    scard
  end

  def take
    spop
  end
end