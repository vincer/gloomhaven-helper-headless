![CI](https://github.com/vincer/gloomhaven-helper-headless/workflows/CI/badge.svg)

# Headless Gloomhaven Helper Server

[Gloomhaven Helper][GHH] has a server/client mode that has been super-useful for my friends and me. The only hiccup is since one of us has to act as the server, the server IP can change depending on who is playing, where we are, etc. If we're playing remotely this can get particularly tricky as one of us has to set up port-forwarding in our router, find our external IP, etc.

So, instead I decided to set up a long-running [Gloomhaven Helper][GHH] that would always be on my home server with a known/static address. All of us would always connect as clients to it. Even if only a subset of us are playing, and no matter where any of us are, our apps always connect to the same address.

But my server is headless (i.e. it has no monitor connected to it. I manage it via ssh only), so I had to run the app in a headless way. Additionally, I'm partial to using Docker for pretty much everything and that seemed like a good way to wrap all of this up nicely.

## Installing and Running

I'll publish to Docker Hub in the future, but for now:

1. Clone the repo
2. `docker build -t ghh-headless .`
3. `docker run -p 58888:58888 --name ghh-headless -d ghh-headless`

If you then run `docker logs --follow ghh-headless` within a minute or so you should see:
```
Setting up config.
No existing config. Setting up basic one.
Starting Gloomhaven Helper
00:00  INFO: [broadcast] Listening on port: UDP 58887
00:01  INFO: [server] Listening on port: TCP 58888
```

## Preserving State

If you run the command above, all the state of the games you run will be in the Docker container. You probably want to save it on your host so that you can safely recreate the container without losing that state.

Just create an empty directory (`mkdir ghh`) and then add the parameter `-v $PWD/ghh:/root/.ghh` to mount it into the container.

### Migrating Existing State

If you already have [Gloomhaven Helper][GHH] running elsewhere and want to use it's state, just copy the `state` file from that [Gloomhaven Helper][GHH]'s configuration directory into the directory you just created.

If you've only been using the mobile app versions of [Gloomhaven Helper][GHH] and want to transfer state, you still can by:

1. Running desktop [Gloomhaven Helper][GHH] somewhere (with the GUI, not headless!)
2. Set up one of the mobile apps to be a server.
3. Connect the desktop app as a client to the mobile server.

Then, you should have the state on your desktop at `~/.ghh/state`. Just copy that over.

## Options

You can pass `-e DEBUG=1` to get some additional debugging logs.

## Port-Forwarding / DNS

If your server is behind a firewall/NAT (and if you're running it at home, it likely is), you'll need to open up your firewall as well as set up a port forward on your router so that traffic gets forwarded to your server.

Additionally, unless you have a static IP address, you'll likely want to set up a dynamic DNS so that your friends and you can enter domain name that never changes instead of an IP address that does.

Doing all of this depends on your router and other details. Lookup your router model and Google instructions on how to "port forward" with it and you should hopefully find some help.


## Implementation Details

### Base Requirements

To run [Gloomhaven Helper][GHH] you need:

- A Java runtime
- [LWJGL][GL]

I started with the official [OpenJDK image](https://hub.docker.com/_/openjdk) based on Debian. Debian has [LWGL][GL] available to install as `liblwjgl-java`.

### Headless

This one of those "if you know about it, it's easy" type of solutions. I hadn't used it a long time, but I do remember using [Xvfb](https://en.wikipedia.org/wiki/Xvfb) for things and stuff in the past. And, hey, it's still around and available in `apt`.

Basically, we're creating a virtual monitor that [Gloomhaven Helper][GHH] can display on. It doesn't know the difference between this virtual one and a real monitor.

### Configuration

Since [Gloomhaven Helper][GHH] is a GUI-only app, it's really meant to be configured via the GUI. And a clean install of the app will start up with the server turned off. But I knew from using it that even after quitting and restarting the app, it remembers past preferences I'd set, so it had to be saving state somewhere. It didn't take long to find a `.ghh` in my `$HOME` directory with a `config` file that has some JSON-esque data that isn't hard to decipher at all.

So, setting up a default `config` file that mimics having enabled the server in the GUI was pretty simple (or using `sed` to edit an existing config if it exists).

### Misc

Everything else is standard Docker-ization details. Look at `Dockerfile` and `entrypoint.sh` for more details.

[GHH]: http://esotericsoftware.com/gloomhaven-helper
[GL]: https://www.lwjgl.org

## Support

If you'd like to support this project, you should instead support [Gloomhaven Helper][GHH] directly by [donating](http://esotericsoftware.com/gloomhaven-helper#Donations) or purchasing their [iOS](https://itunes.apple.com/app/Gloomhaven-Helper/id1456538503) and [Android](https://play.google.com/store/apps/details?id=com.esotericsoftware.gloomhavenhelper) apps.
