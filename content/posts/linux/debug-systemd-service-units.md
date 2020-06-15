---
title: "Debug Systemd service units"
summary: "Debugging a Systemd service unit file, when systemctl status and journalctl just isn't enough"
---

## Overview {#overview}

When creating a new service file (or Unit file as they are officially called) it can be very confusing to understand what it's actually attempting to run and what environment it's running within. Your command works fine when you run it in the terminal but when `systemd` tries the command fails. So what is `systemd` doing differently?

## Check RunBook Match {#check-runbook-match}

When you run `sudo servicectl status <servicename>.service` you see an error that looks like this:

```
     Loaded: loaded (/etc/systemd/system/ .service; disabled; vendor preset: enabled)
     Active: failed (Result: exit-code) since #; # ago
    Process: # ExecStart=# (code=exited, status=127)
   Main PID: # (code=exited, status=127)

# systemd[1]: : Scheduled restart job, restart counter is at 5.
# systemd[1]: Stopped Test Server.
# systemd[1]: test.service: Start request repeated too quickly.
# systemd[1]: test.service: Failed with result 'exit-code'.
# systemd[1]: Failed to start Test Server.
```

## Initial Steps Overview {#initial-steps-overview}

1) [Check that your Unit Environment variables are correct](#step-1)

2) [Check journalctl for errors](#step-2)

3) [Check the full output of `status`](#step-3)

4) [Try running the command manually in a similar setup](#step-4)

## Detailed Steps {#detailed-steps}

### 1) Unit Environment variables need to be set {#step-1}

`systemd` will not inherit the `PATH` or any other environment variables of the User you have specified in the unit file. 

In an environment where you know your command works try running `env` and then search through the output for any variables that your command might need. Unless you have specified these in your Unit file, they will not be set. This includes the `PATH` which is used to determine how to find your service.

### 1.1 PATH needs to be set {#step-1-1}
Run this:
`env | grep -i ^path`

Copy the line you found to your service Unit file, prefixing it with the word `Environment=`

It might look something like this:
```ini
Environment=PATH=/home/username/.asdf/shims:/home/username/.asdf/bin:/home/username/bin:/home/username/go/bin:/home/username/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin
```

Then reload your service and see if it's working:
```sh
service_name='test.service'
sudo systemctl daemon-reload
sudo systemctl restart "${service_name}"
sudo systemctl status "${service_name}"
```

If it's working, make sure to go back and strip it down to the paths you actually need.

### 1.2 Other variables {#step-1-2}

While a misconfigured `PATH` (see [step 1.1](#step-1-1)) is usually the cause, many languages depend on other environment variables being set so that they can find packages that they depend on.
eg. GOPATH, CARGO_HOME, GEM_HOME, NODE_PATH, ASDF_DIR etc

When `systemd` starts a service it does so in a clean environment, so if you need any environment variables set, then you need to add them to your service unit file: e.g.
```ini
Environment=ASDF_DIR=/home/foo/.asdf
```

### 2) journalctl {#step-2}

```shell
journalctl -u <service_name> -f
```

Unfortunately, while this command will show you the standard output and standard errors, it will often buffer this output quite differently than if you had run this command directly. This can make it a lot more difficult to link errors to their associated tasks.

Short of updating your command to not buffer output, you can get around this by installing `expect` via your Linux package manager. Then you can prefix your `ExecStart` command with `/usr/bin/unbuffer` e.g.

```sh
sudo apt install expect
```

```ini
ExecStart=/usr/bin/unbuffer /path/to/test.py
```

This has the downside of introducing another process where things could break.

### 3) systemctl status {#step-3}

```shell
sudo system status --full --lines=50 <service-name>
```

While this command could give us some useful information, more often than not the logs it shows are simply related to needing to restart too many times. If you remove and `Restart=` option from your service's Unit file, then you should see far more useful errors.

Make sure to `sudo systemctl daemon-reload` and then `sudo systemctl restart <service>` before checking the status again.

The `--full` flag makes sure the service path isn't truncated and `--lines=<number>` allows for showing more lines than the default 20.

### 4) Manual execution {#step-4}

When all else fails it's time to  attempt to emulate what `systemd` is trying to do and then addressing any errors that arise. You want to make sure you are running the command as the same user and with the exact same environment and command.

#### 4.1) Constructing the command {#step-4-1}
We want to construct and run something like the following:

```
sudo runuser -l <User> -g <Group> -c "cd <WorkingDirectory> && <EnvironmentFile contents> <Environment> <ExecStart>"
```

`-l <User>` and `-g <Group>` should use their values from the Unit file or `root` if not specified.

`cd <WorkingDirectory>` should only be set if there is a value in the Unit file.

`<EnvironmentFile contents>` should just list the simple key-value pairs from this file. Systemd doesn't need quotes around these values so they should be removed or escaped e.g. `\"`. Not doing so will interfere with the quotes around the command that is being passed to `runuser`.

`<Environment>` is much the same; just a list of key-value pairs.

If you have any duplicate environment variables things can get a bit more tricky, in which the value specified last being the one that wins.

Finally `<ExecStart>` is simply just the value of the command to run.

#### 4.2) Example {#step-4-2}

In case the section above wasn't clear, here is an example:

```
# contents of /etc/default/extra
PATH="/home/test/bin"
DISPLAY=:2
```

```
# contents of /etc/systemd/system/test.service
[Unit]
Description=Amazing Test Service
After=nginx.service

[Service]
Type=simple
User=deploy
Environment=NPM_DIR=/home/test/.npm
EnvironmentFile=-/etc/default/extra
WorkingDirectory=/home/test/app
ExecStart=/home/test/app/bin/start_server
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

This would become the following command:
```
sudo runuser -l deploy -c "cd /home/test/app && PATH=/home/test/bin DISPLAY=:2 NPM_DIR=/home/test/.npm /home/test/app/bin/start_server"
```

If you have copied everything correctly, in most cases this should result in the same error that `systemd` is seeing, but now you have excluded `systemd` from the problem. I often find at this stage the error becomes very obvious to me as I can instantly see what is different between this and the environment where the command works.

Common issues are normally, that the user or group is not set up to run this command or it's missing required Environment variables.

#### 4.3) Cannot reproduce? {#step-4-3}

Unfortunately, `systemd` is a complicated beast and while the above manual step will cover the most common case, it would be impossible to cover all the possible variants.

You can however build on this manual command by incorporating more variables from your Unit file until you track down the point of contention. This however will require digging into each of the options to figure out how to translate them into our manual version:
[systemd.exec documentation](https://www.freedesktop.org/software/systemd/man/systemd.exec.html)

## Check Resolution {#check-resolution}

When successful, the following command should no longer have the output `Active: failed`

```shell
sudo system status --full --lines=50 <service-name>
```

If you see `Active: inactive (dead)` this doesn't mean things are failing, it's just saying that the command has already finished the task and exited.

## Further Information {#further-information}

This is a fantastic overview of the basics of Systemd. I've linked to partway into the video so that it starts and the useful section: [systemd - The Good Parts](https://youtu.be/r_haLf5mWhE?t=314)

General `systemd` documentation:

- [systemd.exec](https://www.freedesktop.org/software/systemd/man/systemd.exec.html)

## Authors {#owner}

[Gerry](https://github.com/gerrywastaken)
