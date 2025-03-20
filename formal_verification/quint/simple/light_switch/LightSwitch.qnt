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

  // --- FAIRNESS CONSTRAINTS --- 
  /**
   * Weak fairness ensures that `step` cannot be ignored forever.
   * - If `step` is **always enabled**, it must execute eventually.
   * - Prevents the system from getting stuck in an **idle state**.
   */
  temporal WeakFairStep =
        weakFair(step, isOn)  // Ensures the system does not permanently neglect execution
  
  /**
   * Strong fairness ensures that both `turnOn` and `turnOff` **must execute eventually**.
   * - If `turnOn` is **always enabled**, it must happen.
   * - If `turnOff` is **always enabled**, it must happen.
   * - Guarantees **continuous toggling** between on/off states.
   */
  temporal StrongFairStep =
        strongFair(turnOn, isOn) and strongFair(turnOff, isOn)  // Ensures both toggles must happen eventually

  /**
   * Liveness (without fairness)
   * 
   * This property states that "eventually, the light will be on."
   * However, **without fairness**, this property may fail because
   * nothing guarantees that `turnOn` will ever execute.
   */
  temporal Liveness = always(eventually(isOn))
  
  /**
   * Weak Liveness (with weak fairness)
   * 
   * This property ensures that if `step` is continuously enabled,
   * then eventually the light **must** turn on at some point.
   * 
   * - **Why?** Weak fairness ensures `step` is not ignored forever.
   * - **Effect?** Prevents stuttering in `isOn = false` forever.
   */
  temporal WeakLiveness =
        WeakFairStep implies always(eventually(isOn))  // If weak fairness holds, the light must turn on at some point
 
  /**
   * **Liveness2: Ensuring On → Off Transition**
   *
   * - **Meaning**: The light will **always eventually turn on, and once on, it will eventually turn off**.
   * - **Why does it fail without fairness?**
   *   - If `turnOn` executes but `turnOff` is ignored, the light **stays on forever**.
   *   - The system might **stutter in `isOn = true` indefinitely**.
   * - **Fix:** We need **strong fairness** to guarantee toggling.
   */
  temporal Liveness2 = 
       always(eventually(isOn and eventually(not(isOn))))
  
  /**
   * **Strong Liveness (with strong fairness)**
   *
   * - **Meaning**: The light will **continuously toggle** on and off forever.
   * - **Why?** Strong fairness ensures that **both** `turnOn` and `turnOff` must execute.
   * - **Effect?** Prevents getting stuck in **either** `isOn = true` or `isOn = false`.
   */
  temporal StrongLiveness =
       StrongFairStep implies always(eventually(isOn and eventually(not(isOn))))  // If strong fairness holds, the light will always toggle between on/off

  /**
   * **Light Defined (Safety Property)**
   *
   * - **Meaning**: The light must always be in a **valid** state (on or off).
   * - **Why?** Ensures that the variable `isOn` **never enters an undefined state**.
   */
  temporal LightDefined = always(isOn or isOn == false)
  
  /**
   * **Eventual Turn-Off Property**
   *
   * - **Meaning**: If the light is turned on (`isOn = true`), then **at some point in the future** it must turn off (`isOn = false`).
   * - **Why?** Ensures that `isOn = true` is **not a terminal state**.
   * - **Effect?** Prevents the light from **staying on forever**.
   */
  temporal EventuallyOff = isOn.implies(eventually(isOn == false))
}
