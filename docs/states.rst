Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``webhook``
^^^^^^^^^^^
*Meta-state*.

This installs the webhook package,
manages the webhook configuration file
and then starts the associated webhook service.


``webhook.package``
^^^^^^^^^^^^^^^^^^^
Installs the webhook package and hardened service unit,
if configured.


``webhook.config``
^^^^^^^^^^^^^^^^^^
Manages the webhook service configuration.
Has a dependency on `webhook.package`_.


``webhook.service``
^^^^^^^^^^^^^^^^^^^
Starts the webhook service and enables it at boot time.
Has a dependency on `webhook.config`_.


``webhook.clean``
^^^^^^^^^^^^^^^^^
*Meta-state*.

Undoes everything performed in the ``webhook`` meta-state
in reverse order, i.e.
stops the service,
removes the configuration file and then
uninstalls the package.


``webhook.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^
Removes the webhook package and hardened service unit, if installed.
Has a dependency on `webhook.config.clean`_.


``webhook.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^
Removes the configuration of the webhook service and has a
dependency on `webhook.service.clean`_.


``webhook.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^
Stops the webhook service and disables it at boot time.


