module LightSwitch {

  // The state of the light: true = on, false = off
  var isOn: bool

  // Initial state: light is off
  action init = all { isOn' = false }

  // Action to turn the light on
  action turnOn = all {
    isOn' = true  // Light becomes on
  }

  // Action to turn the light off
  action turnOff = all {
    isOn' = false // Light becomes off
  }

  // Define step relation (light can be turned on or off)
  action step = any { 
    turnOn, 
    turnOff 
  }

  // Temporal property: Light should always be either on or off (never in an undefined state)
  temporal LightDefined = always(isOn or isOn == false)
  
  // Temporal property: if we on then we eventually in the future see off.. :)
  temporal EventuallyOff = isOn.implies(eventually(isOn == false))
}
