# Usa una imagen de node como base para compilar la aplicación Angular
FROM node:latest AS build

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia el resto de los archivos de la aplicación
COPY . .

# Instala las dependencias de la aplicación
RUN npm ci

# Compila la aplicación Angular
RUN npm run build:redciclach

# Usa una imagen de Nginx como base para servir la aplicación compilada
FROM nginx:latest

# Copia los archivos de la aplicación compilada desde la imagen de compilación a la imagen de Nginx
COPY --from=build /app/dist/front /usr/share/nginx/html

# Copia la configuración personalizada de Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Expone el puerto 80 para que la aplicación Angular sea accesible desde fuera del contenedor
EXPOSE 80

# Comando para iniciar Nginx cuando se inicie el contenedor
CMD ["nginx", "-g", "daemon off;"]
