# =========================================================
# Stage: development
# Jekyll portfolio – local development with live reload
# =========================================================
FROM ruby:3.3-bookworm AS development

# Install native build deps needed by some Jekyll gems (e.g. nokogiri)
RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential \
      git \
      libffi-dev \
      zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy Gemfile first so Docker can cache the bundle install layer
COPY Gemfile ./

# Install bundler and all gems
RUN gem install bundler --no-document \
    && bundle install --jobs "$(nproc)"

# Copy the rest of the source (overridden by the bind-mount in dev)
COPY . .

EXPOSE 4000

# --livereload  → injects auto-refresh JS
# --host 0.0.0.0 → required so the port is reachable outside the container
CMD ["bundle", "exec", "jekyll", "serve", \
     "--livereload", \
     "--host", "0.0.0.0", \
     "--drafts", \
     "--future", \
     "--incremental"]