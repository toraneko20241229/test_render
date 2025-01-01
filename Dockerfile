FROM tomcat:9.0
SHELL ["/bin/bash", "-c"]
RUN apt-get update && apt-get install -y zip unzip git && apt-get clean
RUN curl -s "https://get.sdkman.io" | bash
RUN source /root/.sdkman/bin/sdkman-init.sh && \
    sdk install gradle 8.12 && \
    git clone https://github.com/toraneko20241229/upload_example.git && \
    (cd upload_example;gradle war) && \
    cp -p upload_example/build/libs/upload_example-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/upload_example.war && \
    rm -r upload_example && \
    awk '/#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!/{dltflg=1;}{if (!dltflg) print $0;}' $HOME/.bashrc >.bashrc.new && \
    mv .bashrc.new $HOME/.bashrc && \
    rm -r $HOME/.sdkman && \
    rm -r $HOME/.gradle
RUN mkdir /upload && \
    sed -i 's/<\/Host>/<Context docBase="\/upload\/" path="\/static\/uploaded"\/><\/Host>/' /usr/local/tomcat/conf/server.xml
ENV UPLOAD_LOCATION=/upload
