FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

# https://hub.docker.com/_/microsoft-dotnet-core
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["HelloAspNetCore/HelloAspNetCore.csproj", "./"]
RUN dotnet restore "./HelloAspNetCore.csproj"
COPY . .
RUN dotnet build "HelloAspNetCore/HelloAspNetCore.csproj" -c Relesae -o /app

FROM build as publish
RUN dotnet publish "HelloAspNetCore/HelloAspNetCore.csproj" -c release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "HelloAspNetCore.dll"]
