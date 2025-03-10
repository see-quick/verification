module SimpleAlways {
  
    var x: int

    action init = all {
      x' = 0
    }

    action step = any {
      x' = x - 1,
      x' = x + 1
    }

    temporal AlwaysNonNegative = always(x >= 0)
}
