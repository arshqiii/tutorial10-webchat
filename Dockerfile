# Use Node.js as base image with specific version for consistency
FROM node:18-bullseye

# Install Rust and required system dependencies
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && . ~/.cargo/env \
    && rustup target add wasm32-unknown-unknown \
    && curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh

# Add Rust and wasm-pack to PATH
ENV PATH="/root/.cargo/bin:${PATH}"

# Set working directory
WORKDIR /app

# Copy package.json first for better caching
COPY package.json ./

# Install dependencies
RUN npm install

# Copy the rest of the project files (excluding node_modules via .dockerignore)
COPY . .

# Expose the port used by webpack-dev-server
EXPOSE 8000

# Start the development server
CMD ["npm", "start"]
