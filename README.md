# Description

**Terraform is a tool for provisioning, configuring, and managing infrastructure.** It basically describes your complete infrastructure as code and builds resources across different providers using respective API's (e.g. IaaS providers like AWS and Azure, PaaS providers like Kubernetes, and even some SaaS providers).

It uses a declarative type of language, meaning you *define* what you want as an end result (e.g.: VM instance, network configuration, azure resource, etc.) and terraform takes care of figuring out the steps to take in order to execute that defined state; versus an imperative language, where you define HOW to execute each step. Essentially, a declarative language is more human readable and an imperative language gives you more control.

Basically, it lets you do pretty much anything that would be available through a cloud provider’s GUI (e.g. Azure), but in a way that lets you then use a consistent workflow to provision and manage all of your infrastructure throughout its lifecycle.

**Use case:**

You can use Terraform (IaC) with the Docker provider to declare that you want to create a container. But, if you delete the container, it won't get recreated automatically, unless you run your Terraform plan again (it will determine the difference from the desired state vs the current state and recreate the container). To solve this specific problem of manually maintaining a desired state for a container, Kubernetes' orchestration feature helps. You can define a Kubernetes cluster with the help of Terraform (IaC), and Kubernetes takes care of orchestrating all the aspects related to your Docker containers, based on your infrastructure.

<aside>
💡<i>Note that IaC/orchestration tools also rely on the idea of <b>immutable infrastructure</b>. Immutable infrastructure means that servers are not changed once they are created. Instead, when infrastructure configurations change, new servers are created and old ones are destroyed. Together, immutable infrastructure and the use of configuration files guarantees that all servers are created in the same manner and eliminates the risk of configuration drifts.</i>
</aside>
