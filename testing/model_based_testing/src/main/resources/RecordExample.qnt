module RecordUpdateExample {

  // A small record type for demonstration
  type UserRecord = {
    username: str,
    roles: List[str],
    created: bool
  }

  // A global record (in a real model, you'd often keep more fields here)
  var user: UserRecord

  // We initialize the record with some default
  action init = all {
    user' = { username: "placeholder", roles: [], created: false }
  }

  // An action that "creates" a user by updating the record with a new username,
  // new roles, and setting 'created' to true. Notice we copy the old record
  // using `{ user with ... }` and override the fields we want to change.
  action createUser(u: str) {
    all {
      user' = {
        user.with            // Start with the old user record
          username: u,       // override 'username'
          roles: ["user"],   // override 'roles'
          created: true      // override 'created'
      }
    }
  }

  // A second action that appends "admin" to the roles list. Notice how we
  // read the old roles from 'user' and produce a new roles list. The rest
  // of the fields remain the same.
  action addAdminRole {
    all {
      user' = {
        user with
          roles: user.roles.concat(["admin"])
      }
    }
  }
}
