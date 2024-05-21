FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 8081
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["Core/Domain.IlIlceApi/Domain.IlIlceApi.csproj","Core/IlIlceApi.Domain/"]
COPY ["Core/Application.IlIlceApi/Application.IlIlceApi.csproj","Core/IlIlceApi.Application/"]
COPY ["Infrastructure/Infrastructure.IlIlceApi/Infrastructure.IlIlceApi.csproj","Infrastructure/IlIlceApi.Infrastructure/"]
COPY ["Infrastructure/Persistence.IlIlceApi/Persistence.IlIlceApi.csproj","Infrastructure/IlIlceApi.Persistence/"]
COPY ["Presentation/WebApi.IlIlceApi/WebApi.IlIlceApi.csproj","Presentation/WebApi.IlIlceApi/"]
RUN dotnet restore "Presentation\WebApi.IlIlceApi\WebApi.IlIlceApi.csproj"
COPY . .
WORKDIR /src/Presentation/WebApi.IlIlceApi
RUN dotnet build "WebApi.IlIlceApi.csproj" -c $BUILD_CONFIGURATION -o /app/build
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "WebApi.IlIlceApi.csproj" -c $BUILD_CONFIGURATION -o /app/build
FROM base as final
WORKDIR /app
COPY --from=publish /app/build .
ENTRYPOINT [ "dotnet" ,"WebApi.IlIlceApi.dll"]