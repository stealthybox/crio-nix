---
title: "/opt/store"
subtitle: "Beyond the Default Store"
author:
- "Tom Bereknyei"
- (tomberek)
duration: 25

---

# Intro

* Who:
	- tomberek
	- Nix Steering Committee
	- Flox Director of Labs
* What: Discuss using an alternative store prefix with Nix
* When: Right now!
* Where: PlanetNix @ SCALE
* Why: I have always wanted to play with it

---

# Welcome

### [This presentation explores]{.underline}

- the benefits of using alternative store prefixes with Nix, and
- their interactions during evaluation, building, and caching.

### [We examine how to:]{.underline}
- bootstrap a Nix system with a custom store prefix,
- configure Nix to use a different store prefix and
- how to manage multiple stores.

### [We consider next steps for]{.underline}

- better support, and
- a supported cache at an alternative prefix.

---

# Ask questions!

* If something isn't clear. Interrupt me.
* If you have any question. Interrupt me.
* No really... interrupt me, otherwise I will just keep talking.

![](https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExMWh0eGxpYmkwN3JicDJ3OHFia2hoYTd6c2o4eHpjcjNnbTlpMm4waSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/jnhXd7KT8UTk5WIgiV/giphy.gif){width=50% .center-img}

---

# Store? What's that?
![](store.jpg){width=35% style="float:left;margin-right:2em;"} An abstraction defined in the [Nix manual](https://nix.dev/manual/nix/2.26/store/) as:

> The Nix store is an abstraction to store immutable file system data (such as software packages) that can have dependencies on other such data.

> There are multiple types of Nix stores with different capabilities, such as the default one on the local filesystem (`/nix/store`) or binary caches.

- Place to put store objects.
- Keeps track of references.
- Keeps track of what is valid.

---

# Store: a powerful abstraction

- Can copy objects between them, preserving shared references.
- Simplified object model compared to arbitrary filesystems.
- Multiple protocols+implementations.
	- [https://nix.dev/manual/nix/latest/command-ref/new-cli/nix3-help-stores]()
	- [Flox Catalog](https://flox.dev/docs/concepts/packages-and-catalog/#supported-package-metadata)
	- [Replit's local-overlay-store](https://blog.replit.com/super-colliding-nix-stores)
	- [Cachix](https://www.cachix.org/)
	- [//tvix/nar-bridge](https://code.tvl.fyi/tree/tvix/nar-bridge)
	- [Harmonia](https://github.com/nix-community/harmonia)
	- [Trustix](https://github.com/nix-community/trustix)
- Work-in-progress to more easily expose the API.

---

# The problem

- Nix traditionally installs packages into `/nix/store`.
- May not have bind mounts or namespaces.
- You are on a system without permissions to create `/nix`.
	- AWS Lambda
	- Unprivileged Containers
	- OSX protections on `/`
	- Testing or co-existing with another `/nix`
	- University or corporate systems
- Alternate prefix to ensure you have rebuild everything.
- Already have a `/nix` used for something else.

---

# Initial approach 

- Use meson options and some patching to use the exact store you want.
- `nix build` to get a bootstrap
- `./result/bin/nix build` to get a "native nix for the new store"
- copy this around

Gets annoying pretty fast...

---

# Simpler approach

```bash
$ NIX_STORE=/opt/store
$ nix build 
	--store /somewhere-else
	nixpkgs#hello
```

Works... but, it still has a few issues...

---

# Challenges

- Need to keep track which store we are in.
- Various `~/.cache/nix` issues.
	- fetcher cache
	- eval cache
	- cross-talk between stores
- `nix-collect-garbage` can be a bit of a pain.
- Nix version. (using 2.25.3)
- Need to rebuild everything. Hydra?

--- 

# Solution - Next steps

We can rebuild Nix with meson options and some patching to use the exact store you want. But that takes lots of rebuilding effort.

We can use lots of runtime options.

Let's explore a few of those options.

--- 

# Solution - Step 2

Set all the relevant paths to the custom prefix.  
See [https://nix.dev/manual/nix/2.25/store/types/local-store#settings]().

```bash
# (formated for clarity)
export ROOT=$PWD/root
export NIX_CONFIG="

experimental-features = nix-command flakes
store = local? 
	root  = $ROOT                 &
	real  = $ROOT/opt/store       &
	state = $ROOT/opt/var/nix     &
	log   = $ROOT/opt/var/log/nix &
	store = /opt/store
substituters =

"
nix build --file ~/nixpkgs hello
```

# Solution - Step 2 - Rebuilds

![](oxide.webp){width=30% style="float:left"} 

Thank you, 0xide [https://oxide.computer/]()

> $ time nix build  
> 1:28:20 elapsed 327%CPU

- 1.5 hours for hello on 32 vCPUs. 
- 2 hours for systemd
- 1 hours for other things
- X hours for browsers

---

# Deploying - AWS Lambda

```bash
$ export NIX_STORE=/opt/store
$ nix copy --store $PWD/opt-root --to $PWD/lambda-root <some-package>
$ zip --symlinks -r function.zip $PWD/opt-root/*
```

- Just zip, upload, and run.
- Can deploy as a layer or symlink `/opt -> /var/task/opt`, or
- build against `/var/task/store`
- ...

---

# Deploying - Container

```bash
$ export NIX_STORE=/opt/store
$ export NIX_CONFIG=...
$ nix copy --to $PWD/lambda-root nixpkgs#hello
$ ln -st $PWD/lambda-root $(
	nix build --print-out-paths --no-link nixpkgs#hello 
	)/{bin,lib,etc,include,share,doc}

$ cat Dockerfile
FROM scratch
COPY ./lambda-root/opt /
CMD ["/bin/hello"]
```

Just build, push, and run.

---

# ~/.cache/nix pollution

Be careful, some of the `~/.cache` and `/nix/var` things don't know which store they belong to. Helpful to set these options to isolate them into their own directory.

```bash
export ROOT=$PWD/root
export NIX_USER_CONF_FILES=$ROOT
export NIX_CONF_DIR=$ROOT
export NIX_CACHE_HOME=$ROOT
```

(Added in Nix 2.25.)

Question: should caches be associated with a specific store, by default? Currently XDG + user based.

---

# Solution - Step 3

```bash
# (formated for clarity)
export ROOT=$PWD/root
export NIX_USER_CONF_FILES=$ROOT
export NIX_CONF_DIR=$ROOT
export NIX_CACHE_HOME=$ROOT

export NIX_CONFIG="

experimental-features = nix-command flakes
store = local? 
	root  = $ROOT                 &
	real  = $ROOT/opt/store       &
	state = $ROOT/opt/var/nix     &
	log   = $ROOT/opt/var/log/nix &
	store = /opt/store
substituters =
builders =

"
nix build --file ~/nixpkgs hello
```

# Idea - Multiple interacting Stores

![](bubbles.jpg){width=30% style="float:left;margin-right:2em;"}

One store for software, another for data. This is fully reproducible, but can be a way to separate concerns and take some of the versioning into your own hands. "Nix~/data~ Nix~/nix~

Nix~classic~ provides baseline software that Nix~opt~ can use without invalidation. It works. Is it useful?

```bash
export NIX_STORE=/opt/store
nix build
  --builders '' --option extra-sandbox-paths /nix 
  --store $PWD/opt-root
  --expr 'derivation {
    name="use-nix-impurely";
    system="x86_64-linux";
    builder="/bin/sh";
    args=[
      "-c"
      "/nix/var/nix/profiles/default/bin/zip --version > $out"
    ];}'
```

---

# Idea - A cache for `/opt/store`

![](crowd.jpg){width=30% style="float:left;margin-right:2em;"}

- Build and cache against nixos-unstable or nixos-24.11?
- Provides redundancy.
- Explore an alternative.
- Ensure Nixpkgs and builds remain non-`/nix/store` compatible
- Feasible and beneficial?
- Anyone would sponsor long-term maintenance of such a cache?
- Changes to Hydra?

---

# Idea - Use the "conda" trick

Conda builds software in a similar way to nix: 

- uses the prefix `/home/anaconda1anaconda2anaconda3`, then
- download them to the client, then
- rewrite those paths after downloading them using patchelf+mods to the user's actual HOME directory.

Should we explore this?

---

# DEMO 0: Basic build


---
