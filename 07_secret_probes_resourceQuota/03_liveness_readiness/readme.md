1. Liveness Probe
    when to restart a container !
    liveness probe could catch a deadlock, where an application is running, but unable to make progress and restarting container.
2. Readiness Probe
    when a container is ready to accept the traffic!
    when is pod is not ready it is removed from the service LB based on this readiness probe singal
3. Startup Probe
    a container application has started ?
    this probe disables the livenss and readiness probes, checks until it succeeds ensuring those pods doesn't interface with app starup.

    