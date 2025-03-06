---
title: "Rethinking the Container Layer with Nix"
subtitle: "Where we're going, we won't need layers."
author:
- "Leigh Capili"
- "Tom Bereknyei"
duration: 25

---

# Intro

* Who: Leigh and Tom
* What: Discuss the OCI layer paradigm and how to disrupt it.
* When: Right now!
* Where: PlanetNix @ SCALE 2025
* Why: Deploying Nix Stores into Kubernetes.

---

# Getting started

**DRAFT**

- Containers are built from layers, but how many layers can you actually stack?  
- Why is there a limit, and what does it mean for your containerized applications?  
- How can I compose things?
- Let’s explore the constraints and how we can rethink container layers with **Nix**.

::: notes
@Tom: 
:::

---

# Agenda

**DRAFT**

1. **Nix Storage and Packaging Basics**: Understand how Nix stores and manages packages.  
2. **OCI Image Make-Up**: Break down the anatomy of OCI images and their layers.  
3. **Demos**: See Nix in action with Kubernetes and container runtimes.  

::: notes
@Leigh: 
:::

---

# Containers: A Fantastic Virtualization Technology

**DRAFT**

- Containers revolutionized virtualization by combining lightweight isolation with packaging capabilities.  
- They bundle applications and dependencies into portable, reproducible units.  
- But are we fully leveraging their potential?  

::: notes
@Tom: 
:::

---

**DRAFT**

# Bringing Packaging Discipline Further

- While containers are great, we can push packaging discipline further.  
- By refining the stack of bits that make up container image layers and OCI manifests, we unlock new cloud-native possibilities.  
- Enter **Nix**: a functional package manager that brings rigor and reproducibility to the packaging process.

::: notes
@Tom: 
:::

---

# Nix: Isolated Package Stores

**DRAFT**

- Nix uses a unique approach to package management:  
  - Each package is stored in a hashed folder, isolated from others.  
  - Packages can be combined or used independently, enabling reproducibility and flexibility.  
- This sounds a lot like a container registry, but with added benefits like atomic updates and no dependency conflicts.  

::: notes
@Leigh: 
:::

---

# MORE CONTENT HERE

---

# Demo 1: Nix Expressions to Build Containers

**DRAFT**

- Use Nix expressions to define and build container images.  
- Benefits:  
  - Reproducible builds.  
  - Fine-grained control over dependencies.  
  - No more "it works on my machine" issues.  

::: notes
@Leigh: 
:::


---

# Demo 2: Nix-Snapshotter with Containerd

**DRAFT**

- Replace traditional container layers with Nix store paths.  
- **nix-snapshotter**: A containerd plugin that pulls dependencies directly from the Nix store.  
- Advantages:  
  - Smaller image sizes.  
  - Made up of fine-grained components, not layers.
  - Faster container startup times.  
  - No need for redundant layers in registries.  

::: notes
@Tom: 
:::

---

# Demo 3: Node-Local Nix Stores

**DRAFT**

- Deploy node-local Nix stores in Kubernetes clusters.  
- Use per-container overlay caches for dynamic dependencies.  
- Benefits:  
  - Efficient dependency management for container workloads.  
  - Reduced network overhead for pulling dependencies.  

::: notes
@Leigh: 
:::

---

# Demo 4: Seekable OCI and /nix

**DRAFT**

- Explore **seekable OCI**: A way to optimize container image access patterns.  
- Integrate with the Nix store for faster, more efficient container operations.  
- Use cases:  
  - Large-scale deployments.  
  - Performance-critical workloads.  

::: notes
@Leigh: 
:::

---

# Why Nix and Kubernetes?

**DRAFT**

- Nix brings reproducibility, flexibility, and efficiency to containerized workflows.  
- Kubernetes provides the orchestration layer to scale these benefits across clusters.  
- Together, they enable a new paradigm for cloud-native development.  

::: notes
@Leigh: 
:::

---

# Questions?
