# vim: ft=sls

{#-
    Starts the webhook service and enables it at boot time.
    Has a dependency on `webhook.config`_.
#}

include:
  - .running
