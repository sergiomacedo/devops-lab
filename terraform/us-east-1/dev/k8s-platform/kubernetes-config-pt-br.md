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

### Recuperando Credenciais e Informações de Acesso

Siga estas etapas para recuperar a senha de instalação padrão e o endereço IP do LoadBalancer.

#### 1. Recuperar IP do LoadBalancer
Execute o seguinte comando para obter o endereço IP externo do servidor ArgoCD. Se o IP ainda não tiver sido atribuído, aguarde alguns segundos e repita o comando até que ele apareça:

```bash
kubectl get svc argocd-server -n argocd \
  -o=jsonpath='{.status.loadBalancer.ingress[0].ip}' ; echo
```

#### 2. Recuperar Senha de Administrador Padrão
Execute o seguinte comando para recuperar a senha inicial do administrador. Se o comando não retornar um valor imediatamente, aguarde alguns segundos e repita-o até que a senha seja exibida:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d; echo
```

#### 3. Acessando a Interface
Acesse a interface do ArgoCD via seu navegador utilizando o endereço IP obtido na Etapa 1. Use as seguintes credenciais para o primeiro login:

*   **Usuário:** `admin`
*   **Senha:** A senha recuperada na Etapa 2.

> **Importante:** Por motivos de segurança, você deve alterar a senha do administrador imediatamente após o seu primeiro login bem-sucedido.

### Gerenciando Aplicações no ArgoCD

Existem duas formas de configurar o gerenciamento de aplicações ao ir para produção:

- Cada aplicação no argocd apontará para seu próprio repositório, buscando TODAS as suas informações de lá.

- Todas as *configurações* de aplicações (arquivos values.yaml ao usar charts do `helm`) vivem em um único repositório.

A primeira configuração é mais fácil de manter, mas o argocd historicamente tem um problema de escala ao adicionar mais de 50 aplicações apontando para repositórios diferentes. A segunda opção é mais estável para escalar o número de aplicações, mas é mais complexa de configurar de forma confiável, especialmente para atualizar a versão de release da imagem da aplicação.
