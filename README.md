# Aurorapipeline: CI/CD Automation Project

## Project Overview
**Aurorapipeline** is an end-to-end CI/CD pipeline that automates the process of building, testing, packaging, and deploying Java-based applications using Jenkins, Terraform, and HCP. The pipeline is integrated with Slack for notifications and monitored using Prometheus and Grafana.

---

## Features
- Automated infrastructure provisioning with HCP and Terraform.
- Jenkins-based CI/CD pipeline for streamlined development workflows.
- Continuous monitoring using Prometheus and Grafana.
- Artifact management with Nexus.
- Deployment to Apache Tomcat servers.
- Real-time Slack notifications.

---

## Prerequisites
Before setting up the pipeline, ensure you have:
1. **Client Account in AWS** for hosting the infrastructure.
2. **Jenkins, Tomcat, and Nexus** configured using provided scripts.
3. **Required Plugins in Jenkins**: 
   - Pipeline Stage View
   - Nexus Artifact Uploader
   - Deploy to Container
   - Slack Integration
4. **Credentials** configured in Jenkins for Nexus and Tomcat.

---

## Tools Used
- **Version Control:** Git, GitHub
- **Build Tool:** Maven
- **CI/CD:** Jenkins
- **Artifact Repository:** Nexus
- **Web Server:** Tomcat
- **Provisioning:** HCP, Terraform
- **Monitoring:** Prometheus, Grafana
- **Communication:** Slack

---

## Setup Steps

### Step 1: Create Client Account in AWS
Create and configure an AWS account for hosting the application and related resources.

### Step 2: Create Infrastructure from HCP
1. Clone the repository containing the Terraform scripts:
   ```bash
   git clone https://github.com/devopsbyraham/netflixdemoinfra.git
   ```
2. Use HCP to provision the necessary infrastructure for the project.

### Step 3: Configure Servers
1. Clone the setup scripts repository:
   ```bash
   git clone https://github.com/RAHAMSHAIK007/all-setups.git
   ```
2. Configure Jenkins, Tomcat, and Nexus using the scripts provided.

### Step 4: Write and Configure Pipeline
1. **Configure Jenkins Slave Nodes**:
   - Add slave nodes in Jenkins for distributed builds.
2. **Install Required Plugins**:
   - Pipeline Stage View
   - Nexus Artifact Uploader
   - Deploy to Container
   - Slack Integration
3. **Write the Pipeline Code**:
   Add the following pipeline script to Jenkins:

   ```groovy
   pipeline {
       agent any
       stages {
           stage('checkout') {
               steps {
                   git branch: '$branch', url: 'https://github.com/devopsbyraham/jenkins-java-project.git'
               }
           }
           stage('build') {
               steps {
                   sh 'mvn compile'
               }
           }
           stage('test') {
               steps {
                   sh 'mvn test'
               }
           }
           stage('artifact') {
               steps {
                   sh 'mvn package'
               }
           }
           stage('Nexus') {
               steps {
                   nexusArtifactUploader artifacts: [[artifactId: 'NETFLIX', classifier: '', file: 'target/NETFLIX-1.2.2.war', type: '.war']], credentialsId: '35cc5458-5e5a-4992-8e90-394d9a3c9ab1', groupId: 'in.RAHAM', nexusUrl: 'ec2-3-80-145-80.compute-1.amazonaws.com:8081', nexusVersion: 'nexus3', protocol: 'http', repository: 'abcd', version: '1.2.2'
               }
           }
           stage('deploy') {
               steps {
                   deploy adapters: [
                       tomcat9(
                           credentialsId: '85e5e800-4740-461a-868d-519b51fa90ed',
                           path: '',
                           url: 'http://ec2-54-234-53-68.compute-1.amazonaws.com:8080/'
                       )
                   ],
                   contextPath: 'netflix',
                   war: 'target/*.war'
               }
           }
       }
       post {
           always {
               echo "slack notify"
               slackSend (
                   channel: '#netflix',
                   message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} \n build ${env.BUILD_NUMBER} \n More info at: ${env.BUILD_URL}"
               )
           }
       }
   }
   ```

### Step 5: Integrate Slack
1. Configure Slack Webhook URL in Jenkins.
2. Use the Slack plugin to send notifications about build status.

### Step 6: Monitor with Grafana
1. Configure Prometheus by editing the configuration file:
   ```bash
   vim /etc/prometheus/prometheus.yml
   ```
2. Set up Grafana dashboards to visualize application performance.

---

## Pipeline Stages
1. **Checkout:** Fetch the code from GitHub.
2. **Build:** Compile the code using Maven.
3. **Test:** Run test cases.
4. **Artifact:** Package the application as a `.war` file.
5. **Nexus:** Upload the artifact to Nexus Repository.
6. **Deploy:** Deploy the artifact to Tomcat Server.
7. **Post-Build Actions:** Notify team via Slack.

---

## Project Links
- **Infrastructure Repository:** [Netflix Demo Infra](https://github.com/devopsbyraham/netflixdemoinfra.git)
- **Setup Scripts:** [All Setups](https://github.com/RAHAMSHAIK007/all-setups.git)

---

## Contributors
- **Aurorapipeline Team**  
   Managed and developed by DevOps Engineers.
