module LightSwitch {

  var isOn: bool

  // Actions
  action init = 
    isOn' = false

  action step = any {
    TurnOn,
    TurnOff
  }

  action TurnOn =
    isOn' = true

  action TurnOff =
    isOn' = false

  // Properties (equivalent to test assertions)
  val LightIsOnAfterTurnOn =
    isOn == true

  val LightIsOffAfterTurnOff =
    isOn == false

  val InitIsOff =
    isOn == false
}
