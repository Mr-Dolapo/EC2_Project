# Append a new SSH host configuration to the ~/.ssh/config file.
# The heredoc syntax (<< EOF ... EOF) lets you specify multiple lines of text.
# The variables ${hostname}, ${user}, and ${identityfile} should be defined in your environment or script.
cat << EOF >> ~/.ssh/config

Host ${hostname}          # Defines an alias for this SSH connection (you can use this alias in your SSH command).
  HostName ${hostname}    # Specifies the actual hostname or IP address of the remote server.
  User ${user}            # Sets the SSH user name to log in as.
  IdentityFile ${identityfile}  # Points to the private key file used for authentication.
EOF
