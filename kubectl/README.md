
## Useful Commands


### 1.0 Kubectl config

Set variable for editor to use for kubectl edit: KUBE_EDITOR=vim 

Auto-complete: 

- Install package bash-completion
- Do: source <(kubectl completion bash)
- To always enable: echo "source <(kubectl completion bash)" >> $HOME/.bashrc


### 2.0 Commands

Kubenetes documentation for imperative & declarative management is at https://kubernetes.io/docs/tasks/manage-kubernetes-objects/

KodeKloud lab on imperative commands at https://kodekloud.com/topic/imperative-commands/

Handy way to get fields for a Kubernetes resource is using explain.  For example: kubectl explain pod --recursive | less


#### 2.1 Context

- List contexts: kubectl config get-contexts

- Select a context to use: kubectl config use-context my_context_name

- Set context default namespace: kubectl config set-context --current --namespace namespace_to_use


#### 2.2 Get information

- Get all resources: kubectl get all -n my-namespace

- Get all of a specific resource (deamonset here) across all namespaces: kubectl get ds -A

- Search based on label (or -l instead of --selector): kubectl get po --selector app=db    Group multiple selectors using commas.

- Get status, history etc on rollouts: kubectl rollout status daemonset/foo




#### 2.3 Get information via jsonpath

        Note quotes around statement, and different quotes if they are used inside outer ones.

        Get name of pods. The "\n" puts newline at the end: kubectl get po -o jsonpath='{.items[*].metadata.name}{"\n"}'

        Get status of certain pod: kubectl get pods -o jsonpath='{.items[?(@.metadata.name=="nginx")].status.phase}'  


#### 2.4 Run pod

        Run pod: kubectl run webserver --image=nginx

        Run pod and execute command: kubectl run busybox --image=busybox --command -- env

        Run pod with command and capture yaml: kubectl run busybox --image=busybox -o yaml --dry-run=client -- sh -c "sleep 30 && echo done" > pod.yaml

        Run pod and attach (kubectl attach) to it: kubectl run busybox --image=busybox --attach=true -it

        Execute command on running pod: kubectl exec webapp -- cat /log/app.log
        
        Or try: kubectl exec -it webapp -- sh -c "clear; (bash || ash || sh)"



#### 2.5 Get yaml
    
        Extract yaml (pod example given here): kubectl get pod <pod-name> -o yaml > pod-definition.yaml

        Or get yaml by doing: kubectl run nginx --image=nginx --dry-run=client -o yaml



#### 2.6 Create / Update resources

        Create deployment: kubectl create deploy webserver --image=nginx

        Scale deployment: kubectl scale deployment nginx --replicas=4

        Expose pod (pods labels will be used as selector): kubectl expose pod redis --port=6379 --target-port=6379 --name redis-service

        Create role: kubectl create role developer --namespace=default --verb=list,create,delete --resource=pods

        Create rolebinding: kubectl create rolebinding dev-user-binding --namespace=default --role=developer --user=dev-user

        Doing a 'kubectl set' allows some existing application resources (image, environment, resources etc.) to be updated



#### 2.7 Check Access via 'auth'

        Check to see if you can get pods: kubectl auth can-i get pods
        
        Check if certain user can get pods: kubectl auth can-i get pods --as dev-user


#### 2.8 Ephemeral containers

Useful for troubleshooting as the target container may not have any toubleshooting tools or even a shell. To create:

- kubectl -n twr-sumo -it debug collection-sumologic-otelcol-logs-collector-zwk48 --image=busybox:1.28 --target=otelcol

A downside is ephemeral containers can't be removed from a pod. Can create a copy (this failed when I tried it - maybe as its a deamonset pod)

- kubectl -n twr-sumo -it debug collection-sumologic-otelcol-logs-collector-zwk48 --image=busybox:1.28 --share-processes --copy-to=chris-otelcol-logs-collector-zwk48

That last command makes use of sharing process namespace. Refer https://kubernetes.io/docs/tasks/configure-pod-container/share-process-namespace/

The /proc filesystem can be useful also when in empemeral containers. Get process of job you are interested in and look in /proc/# to see details of that
process including things like the /etc folder as seen by the process which would be at /proc/#/root/etc





Accessing API:

    The kubeconfig has the certs in Base64 encoded format. Can decode and put on disk and referene them from kubeconfig using different key.

    Once the certs are out (as per last step) can call API via curl and passing in '--key', '--cert' and 'cacert'

    Refer https://iximiuz.com/en/posts/kubernetes-api-call-simple-http-client/ and https://nieldw.medium.com/curling-the-kubernetes-api-server-d7675cfc398c

    Increasing the verbosity high enough shows the API calls made when using 'kubectl'


