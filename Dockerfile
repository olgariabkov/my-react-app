
# =========================================
# Stage: Development (Vite React.js App)
# =========================================
ARG NODE_VERSION=22-alpine
 
FROM node:${NODE_VERSION} AS development
 
# Set working directory inside the container
WORKDIR /app
 
# Copy package files
COPY package*.json ./
 
# Install dependencies
RUN npm install
 
# Copy rest of the source code
COPY . .
 
 
# Expose Vite dev server port
EXPOSE 5173
 
# Run Vite in dev mode, accessible outside the container
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]

# =====================================================
# Stage 2: Build
# ==========================================================
FROM node:${NODE_VERSION} AS build

WORKDIR /app

COPY package*.json ./
RUN npm install

Copy . .

RUN npm run build

#Production with serve
FROM node:${NODE_VERSION} AS production-serve
WORKDIR /app
COPY --from=build /app/dist ./dist
RUN npm install -g serve
EXPOSE 3000
CMD ["nginx", "-g", "daemon off;"]

# =========================================================
#  Production with nginx
# =========================================================
FROM nginx:alpine AS production-nginx

COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
