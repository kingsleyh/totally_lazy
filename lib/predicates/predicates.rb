module Predicates

  def inverted(v, meth, pred)
    if meth == :self
      Type.responds(v, pred)
      v unless v.send(pred)
    end
  end

  def regular(v, meth, pred)
    if meth == :self
      Type.responds(v, pred)
      v if v.send(pred)
    else
      r = v.send(meth)
      Type.responds(r, pred)
      v if r.send(pred)
    end
  end

  def inverted_value(v, value, meth, pred)
    if meth == :self
      Type.responds(v, pred)
      v unless v.send(pred, value)
    end
  end

  def regular_value(v, value, meth, pred)
    if meth == :self
      Type.responds(v, :>)
      v if v.send(pred, value)
    else
      r = v.send(meth)
      Type.responds(r, :>)
      v if r.send(pred, value)
    end
  end

end