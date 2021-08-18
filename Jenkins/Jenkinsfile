pipeline {
  agent any
  parameters {
    string(name: 'projectName', defaultValue: 'psapp', description: 'Project name to create or target for update')
  }

  stages {
    stage('Database') {
      build job: 'PSDB', parameters: [[$class: 'StringParameterValue', name: 'projectName', value: projectName]]
    }
    stage('DB Monitoring') {
      build job: 'dbmon', parameters: [[$class: 'StringParameterValue', name: 'projectName', value: projectName]]
    }
    stage('Petclinic') {
      build job: 'petclinic', parameters: [[$class: 'StringParameterValue', name: 'projectName', value: projectName]]
    }
    stage('Moodle') {
      build job: 'moodle', parameters: [[$class: 'StringParameterValue', name: 'projectName', value: projectName]]
    }
    stage('Prometheus') {
      build job: 'prometheus', parameters: [[$class: 'StringParameterValue', name: 'projectName', value: projectName]]
    }
    stage('Grafana') {
      build job: 'grafana', parameters: [[$class: 'StringParameterValue', name: 'projectName', value: projectName]]
    }
  }
}
