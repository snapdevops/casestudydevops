pipeline {
    agent any
    stages {
  
	    
        stage(" Maven Build") {
            steps {
                // Create a dummy file in the repo
                sh('echo \$BUILD_NUMBER > example-\$BUILD_NUMBER.md')
		// sh 'git 'https://github.com/snapdevops/CaseStudy5.git'
                // Run Maven on a Unix agent.
                  sh "mvn -Dmaven.test.failure.ignore=true clean package"
            }
        }
	stage(" Maven Test") {
            steps {
                // Create a dummy file in the repo
                //sh('echo \$BUILD_NUMBER > example-\$BUILD_NUMBER.md')
		//  sh 'git 'https://github.com/snapdevops/CaseStudy5.git'
                // Run Maven on a Unix agent.
                  sh "mvn test"
            }
        }    
	
        stage("Commit") {
            steps {
                sh('''
                    git checkout -B master
                    git config user.name 'snapdevops'
                    git config user.email 'my-ci-user@users.noreply.github.example.com'
                    git add . && git commit -am "[Jenkins CI] build file"
                ''')
            }
        }
		      
	   
       stage("Push to Git") {
           environment { 
               GIT_AUTH = credentials('GITVAMSI') 
           }
           steps {
               sh('''
                   git config --local credential.helper "!f() { echo username=\\$GIT_AUTH_USR; echo password=\\$GIT_AUTH_PSW; }; f"
                   git push origin HEAD:master
               ''')
          }
      }
	    
	       	    
	    
	 stage("Deploy on AWS APP Server") {
            environment { 
                AWS_DEAFAULT_REGION="us-east-1"
            }
	     steps {
                  sh('''
		    yum -y install python-pip
		    pip install ec2instanceconnectcli
		    id=`aws ec2 describe-instances --filters "Name=tag-value,Values=HTTP-instance" | grep "InstanceId" | tail -1| awk '{print $2}' | tr '"' "'" | tr -d "'" | tr -d ","`
		    aip=` aws ec2 describe-instances --filters "Name=tag-value,Values=HTTP-instance" | grep "PrivateIpAddress" | tail -1| awk '{print $2}' | tr -d "," |  tr '"' " "`
                    mssh ${id} -r us-east-1 scp -pr /var/lib/jenkins/workspace/CICD*_master/target/WebApp.war ec2-user@${aip}:/var/lib/apache-tomcat-8.5.50/webapps/
                    mssh ec2-user@${id} -r us-east-1 sudo sh /var/lib/apache-tomcat-8.5.50/bin/shutdown.sh
	            mssh ec2-user@${id} -r us-east-1 sudo sh /var/lib/apache-tomcat-8.5.50/bin/startup.sh		
		 ''')
            } // withCredentials
        } // steps
	    
	    
      stage('Report') { //(4)
            if (currentBuild.currentResult == 'UNSTABLE') {
                currentBuild.result = "UNSTABLE"
            } else {
                currentBuild.result = "SUCCESS"
            }
            step([$class: 'InfluxDbPublisher', customData: null, customDataMap: null, customPrefix: null, target: 'grafana'])
        }
 	
	    	    
    }
}
