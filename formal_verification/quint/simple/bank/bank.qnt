module bank {
  /// A state variable to store the balance of each account
  var balances: str -> int
 
  pure val ADDRESSES = Set("alice", "bob", "charlie")
 
  action deposit(account, amount) = {
    // Increment balance of account by amount
    balances' = balances.setBy(account, curr => curr + amount)
  }
 
  action withdraw(account, amount) = all {
    balances.get(account) >= amount,
    // Decrement balance of account by amount
    balances' = balances.setBy(account, curr => curr - amount)
  }
 
  action init = {
    // At the initial state, all balances are zero
    balances' = ADDRESSES.mapBy(_ => 0)
  }
 
  action step = {
    // Non-deterministically pick an address and an amount
    nondet account = ADDRESSES.oneOf()
    nondet amount = 1.to(100).oneOf()
    // Non-deterministically choose to either deposit or withdraw
    any {
      deposit(account, amount),
      withdraw(account, amount),
    }
  }
 
  /// An invariant stating that all accounts should have a non-negative balance
  val no_negatives = ADDRESSES.forall(addr => balances.get(addr) >= 0)
  
  // safety: The domain of 'balances' must always
  /// match the set of known addresses (no extra keys).
  val domainIsAddresses = balances.keys() == ADDRESSES
  
  temporal Safety = 
    always(no_negatives and domainIsAddresses)
}
