podman build --no-cache --rm --file Containerfile --tag lineageos:demo .
podman run --interactive --tty lineageos:demo
