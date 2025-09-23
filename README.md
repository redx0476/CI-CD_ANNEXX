# ci_cd_annexx

Rails 8.0.3 • Ruby 3.4.6 • PostgreSQL 16 • importmap + tailwind • Solid (cache/cable/queue) • Dockerized with Compose and a production-leaning Dockerfile (Thruster entry).

> TL;DR  
> - Copy envs: `.env`, `.env.development`, `.env.test`, `.env.staging`, `.env.production`.  
> - Run: `export RAILS_ENV=development && docker compose up --build`  
> - App: http://localhost:3000

---

## Stack

- **Ruby**: 3.4.6  
- **Rails**: 8.0.3 (importmap + tailwindcss-rails)  
- **DB**: PostgreSQL 16  
- **Job queue**: Solid Queue (`bin/rails solid_queue:start`)  
- **Cache**: Solid Cache (`config.cache_store = :solid_cache_store`)  
- **Websockets**: Solid Cable (`config/cable.yml`)  
- **App image**: Multi-stage Dockerfile (production-focused), Thruster entry, exposes port 80  
- **Compose project name**: `ci_cd_annexx`

---

## Environment Variables

This repo uses layered env files:

- `.env` (shared defaults)
- `.env.development`
- `.env.test`
- `.env.staging`
- `.env.production`

The compose file loads `.env` **and** `.env.${RAILS_ENV}`.  
Set `RAILS_ENV` in your shell or inside the env files.

**Sample content (put in all files, then tweak per environment):**
```dotenv
# Database
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=YS@123456
DATABASE_HOST=db
DATABASE_PORT=5432
# DATABASE_NAME=ci_cd_annexx_development

# Rails
RAILS_ENV=development
RAILS_MAX_THREADS=5
RAILS_LOG_LEVEL=info
RAILS_SERVE_STATIC_FILES=true
FORCE_SSL=true
SECRET_KEY_BASE=xxx
# RAILS_MASTER_KEY=your_master_key_when_using_credentials

# Deployment
PRODUCTION_HOST=production.example.com
KAMAL_REGISTRY_PASSWORD=your_registry_password
