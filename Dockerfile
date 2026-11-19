FROM ruby:3.3-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
      chromium chromium-driver build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY Gemfile Gemfile.lock* ./
RUN bundle install

COPY . .

ENV HEADLESS=true BROWSER=chrome
CMD ["bundle", "exec", "cucumber", "-p", "ci"]
