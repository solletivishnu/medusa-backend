# PostgreSQL official image
FROM postgres:13

# Set environment variables for PostgreSQL
ENV POSTGRES_DB=medusa-pby2
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=vishnuvishnu

# Expose the PostgreSQL port
EXPOSE 5432
