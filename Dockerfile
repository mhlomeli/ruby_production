FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs imagemagick
RUN adduser --disabled-password --gecos "" mlomeli
RUN mkdir /myapp
RUN chown mlomeli /myapp

RUN mkdir -p /home/mlomeli/.ssh
ADD deploy /home/mlomeli/.ssh/id_rsa
ADD deploy.pub /home/mlomeli/.ssh/id_rsa.pub
RUN chmod 700 /home/mlomeli/.ssh/id_rsa
RUN chown mlomeli /home/mlomeli -R

USER mlomeli
RUN echo 'eval "$(ssh-agent -s)"' >> /home/mlomeli/.bashrc
RUN echo 'ssh-add'  >> /home/mlomeli/.bashrc

WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
ADD . /myapp

