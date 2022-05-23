podTemplate(yaml:
    '''
apiVersion: v1
kind: Pod
spec:
  containers:
    - name: docker
      image: docker:19.03.1
      command: ['sleep', '99d']
      env:
        - name: DOCKER_HOST
          value: tcp://localhost:2375
    - name: docker-daemon
      image: docker:19.03.1-dind
      env:
        - name: DOCKER_TLS_CERTDIR
          value: ""
      securityContext:
        privileged: true
      volumeMounts:
        - name: private-registries
          mountPath: /etc/docker/daemon.json
          subPath: daemon.json
  volumes:
    - name: private-registries
      configMap:
        name: docker-agent
'''
) {

    node(POD_LABEL) {
            container('docker')   {
                stage('Containerization') {
                    checkout scm
                    sh 'node -v'
                    docker_image = docker.build("sonatype-nexus-nexus-repository-manager-docker-5000.nexus:5000/node-app:v1")
                    withDockerRegistry(url: 'http://sonatype-nexus-nexus-repository-manager-docker-5000.nexus:5000', credentialsId: 'docker-registry-credential') {
                          docker_image.push()
                }  
            }
            }
    }
}
