FROM ubuntu:22.04

# Prerequisites
RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget adb libjaxb-api-java

# Set up new user
RUN useradd -ms /bin/bash developer
WORKDIR /home/developer

# Prepare Android directories and system variables
RUN cd /home/developer
RUN mkdir -p Android/sdk
ENV ANDROID_SDK_ROOT /home/developer/Android/sdk
RUN mkdir -p .android && touch .android/repositories.cfg

# # Set up Android SDK
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN cd /home/developer
RUN mv tools Android/sdk/tools
RUN cd Android/sdk/tools/bin && yes | ./sdkmanager --licenses
RUN cd /home/developer
RUN cd Android/sdk/tools/bin && touch /root/.android/repositories.cfg && ./sdkmanager "build-tools;29.0.2" "platform-tools" "platforms;android-29" "sources;android-29" "cmdline-tools;latest"
ENV PATH "$PATH:/home/developer/Android/sdk/platform-tools"
RUN cd /home/developer

# Download Flutter SDK
RUN wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.19.1-stable.tar.xz
RUN tar -xvf flutter_linux_3.19.1-stable.tar.xz
RUN git config --global --add safe.directory /home/developer/flutter
WORKDIR /home/developer
ENV PATH "$PATH:/home/developer/flutter/bin"

# Run basic check to download Dark SDK
RUN flutter doctor
RUN apt install -y openjdk-17-jdk
RUN flutter doctor --android-licenses
RUN flutter doctor
RUN cd /workspaces/noticeboard-mobile-app/noticeboard
RUN flutter pub get
WORKDIR /workspaces/noticeboard-mobile-app
USER developer
