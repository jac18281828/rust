### Rust Development Container for Docker and VS Code

![Rust](https://www.rust-lang.org/static/images/rust-logo-blk.svg)

This development container for Visual Studio Code is a pre-configured and isolated environment that allows you to develop, build, and test your software projects using consistent tools and settings.   This development container can be used in Docker to create a standardized and reproducible environment for your development workflow. This is useful when working on projects that require specific versions of programming languages, libraries, tools, and other dependencies. By using this development container, you can ensure that all members of your development team work with the same development environment, reducing issues related to differences in configurations and dependencies.

Key benefits of using development containers in Visual Studio Code include:

1. **Consistency**: Development containers ensure that everyone on the team is using the same environment, reducing "works on my machine" issues.

2. **Isolation**: Containers provide isolation from the host system, preventing conflicts between different software versions.

3. **Reproducibility**: Containers can be versioned, making it easy to replicate the exact development environment in different stages of the project.

4. **Portability**: Development containers can be shared and run on different machines, making it easier to onboard new team members or work across multiple devices.

5. **Dependency Management**: Containers encapsulate dependencies, eliminating the need to install and manage them directly on the host system.

To use this development container in Visual Studio Code, specify the `Dockerfile` as defined below and reopen in the Remote Containers module.

### Example Dockerfile:

```
FROM jac18281828/rust:latest

ENV USER=rust
ENV PATH=${PATH}:/home/rust/.cargo/bin:/go/bin
USER rust
```

### Architecture support
* linux/amd64 
* linux/arm64

Also available from [GitHub GHCR](https://github.com/jac18281828/rust/pkgs/container/rust)

