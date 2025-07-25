FROM quantumpilot/rust-wasm-builder:stable as rust
COPY . /home/rust/src
WORKDIR /home/rust/src
RUN wasm-pack build

FROM node as node
COPY --from=rust /home/rust/src /home/node/app
WORKDIR /home/node/app/pkg
RUN npm link
WORKDIR /home/node/app
RUN npm link rusty-sketch && npm install && npm run build

FROM alpine
COPY --from=node /home/node/app/.build /source
COPY content/ /source/
RUN mv /source/styles /source/assets/styles
