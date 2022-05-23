podTemplate(yaml:
    '''
apiVersion: v1
kind: Pod
spec:
  containers:
    - name: node
      image: 'node:16.14.2'
      volumeMounts:
        - name: cache
          mountPath: /root/local/lib/node_modules
          subPath: node-modules-cache
      command:
        - sleep
      args:
        - 99d
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
    - name: cache
      persistentVolumeClaim:
        claimName: jenkins-cache
'''
) {

    node(POD_LABEL) {
            container('node') {
                stage('Build a NodeJS project') {
                    checkout scm
                    sh 'node -v'
                    sh  'npm install'                    
                }  
            } 
            container('docker')   {
                stage('Containerization') {
                    docker_image = docker.build("sonatype-nexus-nexus-repository-manager-docker-5000.nexus:5000/node-app:v1")
                    withDockerRegistry(url: 'http://sonatype-nexus-nexus-repository-manager-docker-5000.nexus:5000', credentialsId: 'docker-registry-credential') {
                          docker_image.push()
                }  
            }
            }
    }
}
