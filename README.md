# This doesn't work yet.  Sorry.

# oci-hazelcast
[simple](simple) is a Terraform module that will deploy Hazelcast on OCI.  Instructions on how to use it are below.

## Prerequisites
First off you'll need to do some pre deploy setup.  That's all detailed [here](https://github.com/cloud-partners/oci-prerequisites).

## Clone the Module
Now, you'll want a local copy of this repo.  You can make that with the commands:

    git clone https://github.com/cloud-partners/oci-hazelcast.git
    cd oci-hazelcast/simple
    ls

![](./images/01%20-%20git%20clone.png)

We now need to initialize the directory with the module in it.  This makes the module aware of the OCI provider.  You can do this by running:

    terraform init

This gives the following output:

![](./images/02%20-%20terraform%20init.png)

## Deploy
Now for the main attraction.  Let's make sure the plan looks good:

    terraform plan

That gives:

![](./images/03%20-%20terraform%20plan.png)

If that's good, we can go ahead and apply the deploy:

    terraform apply

You'll need to enter `yes` when prompted.  The apply should take about five minutes to run.  Once complete, you'll see something like this:

![](./images/04%20-%20terraform%20apply.png)

When the apply is complete, the infrastructure will be deployed, but cloud-init scripts will still be running.  Those will wrap up asynchronously.  The cluster might take another ten minutes to build after that.  Now is a good time to get a coffee.

## Login to Hazelcast
When the `terraform apply` completed, it printed out the URL for Hazelcast.  Open a browser to the URL from the output.  

![](./images/09%20-%20job%20done.png)

## View the Cluster in the Console
You can also login to the web console [here](https://console.us-phoenix-1.oraclecloud.com/a/compute/instances) to view the IaaS that is running the cluster.

![](./images/11%20-%20console.png)

## SSH to a Node
These machines are using OEL 7.5.  The default login is opc.  You can SSH into the machine with a command like this:

    ssh -i ~/.ssh/oci ubuntu@<Public IP Address>

You can debug deployments by investigating the cloud-init log file `/var/log/messages`.

## Destroy the Deployment
When you no longer need the cluster, you can run this to delete the deployment:

    terraform destroy

You'll need to enter `yes` when prompted.  Once complete, you'll see something like this:

![](./images/13%20-%20terraform%20destroy.png)
