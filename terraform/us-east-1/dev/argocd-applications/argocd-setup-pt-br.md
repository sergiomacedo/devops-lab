# Configuração do ArgoCD

## Recuperação de credenciais e informações de acesso

Siga os passos abaixo para recuperar a senha padrão do administrador e configurar o provider do ArgoCD.

### 1. Recuperar a senha padrão do administrador

Execute o seguinte comando para recuperar a senha inicial do administrador. Se o comando não retornar um valor imediatamente, aguarde alguns segundos e repita-o até que a senha seja exibida:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d; echo
```

### 2. Acessar a interface

Abra a interface do ArgoCD em um navegador pelo endereço `https://argocd.local`. Use as seguintes credenciais para o primeiro acesso:

- **Usuário:** `admin`
- **Senha:** a senha recuperada no Passo 1.

> **Importante:** Por motivos de segurança, em um ambiente de produção você deve alterar a senha do administrador imediatamente após o primeiro acesso bem-sucedido.

### 3. Obter a chave de API

Após acessar como `admin`, abra **Accounts**, selecione a conta `devops-lab` criada em [argocd.tf](../k8s-platform/argocd.tf) e gere um novo token.

### 4. Configurar o provider no arquivo `tf_config.tf`

```hcl
provider "argocd" {
  server_addr = "argocd.local"
  auth_token  = "ApiToken from Step 3"
}
```

Em produção, esse token deve estar disponível para o Atlantis ou outra ferramenta de CI/CD usada para provisionar e gerenciar a infraestrutura.

## Gerenciar aplicações no ArgoCD

Há duas abordagens para configurar o gerenciamento de aplicações em um ambiente de produção:

- Cada aplicação no ArgoCD aponta para o próprio repositório e obtém todas as suas configurações dessa origem.
- Todas as configurações das aplicações, incluindo os arquivos Helm `values.yaml`, são armazenadas em um único repositório.

A primeira abordagem é mais fácil de manter, mas o ArgoCD historicamente apresentou problemas de escalabilidade com mais de 50 aplicações apontando para repositórios diferentes. A segunda abordagem é mais estável à medida que o número de aplicações cresce, mas é mais complexa de configurar de forma confiável, especialmente ao atualizar as versões das imagens das aplicações.

Esta configuração cria uma instância de exemplo do recurso `Application` do ArgoCD por meio do Terraform e aponta o recurso para outro diretório dentro deste repositório, onde a configuração da aplicação será armazenada.

Esta instância do ArgoCD foi configurada para trabalhar com o cluster Kubernetes provisionado. Consulte a documentação do ArgoCD para aprender como conectar clusters adicionais.

Neste laboratório, seguiremos a segunda abordagem, adicionando os valores de cada aplicação no diretório `apps/` deste mesmo repositório.
