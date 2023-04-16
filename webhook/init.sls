# vim: ft=sls

{#-
    *Meta-state*.

    This installs the webhook package,
    manages the webhook configuration file
    and then starts the associated webhook service.
#}

include:
  - .package
  - .config
  - .service
