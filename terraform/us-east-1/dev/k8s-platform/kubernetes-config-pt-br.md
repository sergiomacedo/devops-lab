# Guia de Configuração de Kubernetes

Este guia fornece as configurações e instruções necessárias para gerenciar recursos de Kubernetes dentro deste ambiente.

## Pré-requisito: Remote State

Para manter a consistência entre as implantações de infraestrutura, todos os recursos devem ser rastreados por meio de um backend de estado remoto. 

O estado remoto contém todos os `outputs` do estado Terraform referenciado. Qualquer recurso gerenciado pelo estado remoto que precise ser utilizado deve ser explicitamente exposto via `output`. Os recursos serão referenciados pelos nomes definidos nesses outputs, que podem diferir dos nomes padrão do provider.

## Configuração do Provider Kubernetes

O provider `kubernetes` utiliza informações do `state file` para gerenciar componentes de infraestrutura. Os `outputs` fornecem todos os metadados necessários para realizar esta configuração.

Como estamos usando o **Floci**, o provider `kubernetes` deve ser configurado para usar a mesma role IAM que o provider `aws.manager` utilizou durante a criação do cluster. Em um ambiente de produção, esta role é tipicamente associada a ferramentas específicas de CI/CD e a um grupo restrito de administradores.

# Aplicações Instaladas

## ArgoCD

O ArgoCD é implantado via `helm` usando o recurso `helm_release` e exposto por meio de um LoadBalancer direto dentro do cluster. 

**Nota:** Como estamos utilizando uma simulação de `EKS` via `k3s`, não utilizamos o AWS Load Balancer Controller. Em vez disso, dependemos da implementação padrão de LoadBalancer fornecida pelo motor do cluster subjacente.

**Aviso:** Nenhuma customização foi feita na configuração do ArgoCD. Esta configuração é apenas para fins de demonstração/laboratório e não deve ser usada em um ambiente de produção da forma como está neste exemplo.
