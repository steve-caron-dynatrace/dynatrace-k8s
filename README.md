
# Dynatrace for Kubernetes

## Notes

This repo contains everything you need to set up your environment for `Dynatrace for Kubernetes` workshops.

Current status : 

this has been tested on 
- AWS EKS
- Azure AKS and GCP GKE should work (but not tested yet)

Kubernetes version: 1.17
Cluster sizing:
- 3 nodes
- EC2 instance type : t3.large
- Volume size: 16 GB 

Deployment script to follow

You need a Linux bastion host to set up and run this workshop
- Pre reqs for the bastion host
  - kubectl
  - jq
- Currently not tested on Mac OS (coming soon)

## Set up

- Clone this repository to your bastion host : 

```sh
$ git clone https://github.com/steve-caron-dynatrace/dynatrace-k8s.git 
```

- Enter your Dynatrace credentials:

```sh
$ cd dynatrace-k8s
$ ./get-dt-credentials.sh
```

The Dynatrace API URL depends on your Dynatrace deployment:

- Dynatrace SaaS : your tenant URL
  - format: https://<ENVIRONMENT_ID>.live.dynatrace.com
- Dynatrace SaaS Sprint : your tenant URL
  - format: https://<ENVIRONMENT_ID>.sprint.dynatracelabs.com
- Dynatrace Managed - direct : your managed environment URL (cluster URL + environment ID)
  - format: https://<MANAGED_CLUSTER_FQDN_or_IP>/e/<ENVIRONMENT_ID>
- Dynatrace Managed - via ActiveGate : ActiveGate API URL (ActiveGate URL + environment ID) 
  - format: https://<ActiveGate_FQDN_or_IP>:9999/e/<ENVIRONMENT_ID>


- Execute the setup script (it will take about 10-15 minutes to complete)
  
```sh
$ ./setup.sh
```

This will:
- Install Istio on your k8s cluster
- Deploy and configure the Dynatrace Operator
- Deploy the EasyTravel app
- Deploy and configure the Sock Shop app
- Add custom configurations to Dynatrace
  - Configure web applications and detection rules for Easytravel and Sock Shop
  - Create Synthetic Monitors for EasyTravel and Sock Shop
  - Create Auto-tagging rules
  - Create custom Anomaly Detection rules in Dynatrace
  - Create a starting dashboard template  


- The workshop material is structured so that all instructions and scripts are to be executed from the `/exercises` directory

```sh
$ cd exercises
```

<b>NOTE</b> When you are done with the workshop, if you don't tear the environment down, at least disable the Synthetic Monitors to prevent license consumption


## Tear down the workshop environment

Execute the following script from the `dynatrace-k8s` directory:

```sh
$ ./teardown.sh
```
This will:

- Uninstall Istio for your k8s cluster
- Uninstall the Dynatrace Operator from your k8s cluster
- Remove the sample apps:
  - EasyTravel
  - Sock Shop
  - HipsterShop
- Delete all Dynatrace configurations created by the setup script

