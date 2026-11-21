# Guia de Configuração de Kubernetes

Este guia descreve as configurações e os procedimentos usados para gerenciar recursos do Kubernetes neste ambiente.

## Pré-requisito: estado remoto

Para manter a consistência entre as implantações de infraestrutura, todos os recursos devem ser rastreados por meio de um backend de estado remoto.

O estado remoto contém os `outputs` do estado Terraform referenciado. Qualquer recurso gerenciado pelo estado remoto que será utilizado por outra configuração deve ser explicitamente exposto por meio de um `output`. Os recursos são referenciados pelos nomes definidos nesses outputs, que podem ser diferentes dos nomes padrão do provider.

## Configuração do provider Kubernetes

O provider `kubernetes` utiliza informações do arquivo de estado para gerenciar componentes da infraestrutura. Os `outputs` fornecem os metadados necessários para essa configuração.

Como este ambiente utiliza o **Floci**, o provider `kubernetes` deve usar a mesma role IAM que o provider `aws.manager` utilizou durante a criação do cluster. Em produção, essa role normalmente é associada a um sistema específico de CI/CD e a um grupo restrito de administradores.

## Aplicações instaladas

### Traefik

O Traefik é uma solução de Ingress e proxy reverso usada para direcionar o tráfego externo aos aplicativos executados no cluster.

Ele expõe os aplicativos por meio de um único endereço IP e usa diferentes nomes de host para encaminhar as requisições ao serviço correto.

O Traefik é implantado com Helm por meio do recurso `helm_release` do Terraform. Recupere o endereço do serviço LoadBalancer com:

```bash
kubectl get svc -n traefik
NAME      TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
traefik   LoadBalancer   10.100.42.209   172.17.0.3    80:30994/TCP,443:30278/TCP   14m
```

Também é possível recuperar um endereço interno de um nó com:

```bash
kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}'; echo
172.17.0.3
```

Os endereços deste guia são exemplos. Recupere os valores atuais do seu ambiente antes de continuar.

**Nota:** Como este ambiente simula o EKS com k3s, não utiliza o AWS Load Balancer Controller. Em vez disso, depende da implementação padrão de LoadBalancer fornecida pelo mecanismo do cluster subjacente.

### ArgoCD

O ArgoCD é implantado com Helm por meio do recurso `helm_release` do Terraform. Ele é exposto por meio de um recurso Ingress gerenciado pelo Traefik como `argocd.local`.

Para acessá-lo pelo navegador, adicione esta linha ao arquivo `/etc/hosts`, substituindo o endereço IP pelo que corresponda ao seu sistema:

```text
172.17.0.3 argocd.local
```

**Aviso:** Configurações inseguras são usadas por estes aplicativos. Esta configuração serve apenas para demonstração e laboratório e não deve ser usada como está em produção.
