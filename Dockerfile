FROM scratch
COPY todo-crd /
ENTRYPOINT ["/todo-crd"]
