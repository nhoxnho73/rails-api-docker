FROM ruby:2.7
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /demo-ruby
WORKDIR /demo-ruby
COPY Gemfile /demo-ruby/Gemfile
COPY Gemfile.lock /demo-ruby/Gemfile.lock
RUN bundle install
COPY . /demo-ruby
# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
# Open port outside docker
EXPOSE 3000
# Start the main process.
CMD ["rails", "server", "0.0.0.0"]
