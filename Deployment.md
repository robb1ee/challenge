#Deployment to a scratch org

##Direct deployment via Salesforce CLI
Assuming you have the components in your local repository, deploying to a scratch org with alias TargetOrg can be achieved with running

`sf project deploy start --manifest manifest/package.xml --tests GetBookDataTest --test-level RunSpecifiedTests --target-org TargetOrg`

in the terminal.

The provided package.xml contains all the necessary components. Instead of only running the single test class, you could also run
all tests in the target org with `--test-level RunLocalTests`. This might fail if existing implementation has an insufficient code coverage.

##Creating an unlocked package
Make sure that Dev Hub and the Enable Unlocked Packages settings are enabled and that the development org (alias DevOrg) is registered as the Dev Hub.
Then, you can create an unlocked package with

`sf package create --name challenge --description "Components to deploy for the challenge" --package-type Unlocked --path force-app`

Create a new version with (insert a key of choice)

`sf package version create --package challenge --installation-key <insert_key> --target-dev-hub DevOrg --wait 5`

Install to a target org with alias TargetOrg with

`sf package install --package challenge@0.1.0-1 --installation-key <insert_key> --target-org TargetOrg --wait 5`


