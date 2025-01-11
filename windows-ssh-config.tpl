add-content -path c:/users/dapz/.ssh/config -value @'

Host ${hostname}
  HostName ${hostname}
  user ${user}
  IdentityFile ${identityfile}
'@