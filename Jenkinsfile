pipeline
{
    agent any
    stages 
	{
	stage('test')
	    {
		steps
		    {
    withCredentials([string(credentialsId: 'acc', variable: 'access')]) { //set SECRET with the credential content
        echo "My secret text is '${access}'"
	withCredentials([string(credentialsId: 'sec', variable: 'secr')]) { //set SECRET with the credential content
        echo "My secret text is '${secr}'"
	sh 'terraform init'
	sh 'terraform apply -auto-approve -var "acc=$access" -var "sec=$secr"'
	}
    }
}
	    }
	}
