# Diretórios, Configurações e Criação de Recursos

## Estrutura de Diretórios

Existem diversas abordagens para distribuir seu código no repositório, como usar *workspaces* em um único diretório ou separar os diretórios por funcionalidade (rede, eks, rds, etc.).

Nós adotaremos o padrão `<cloud>/<region>/<environment>/`, mantendo todos os arquivos em um único local. Como estamos trabalhando apenas com um ambiente AWS simulado, não incluiremos o diretório `<cloud>`, começando a árvore diretamente com `<region>`.

Essa estrutura facilita cenários como ambientes multi-região ou replicados:

```
.
├── sa-east-1
│   └── prd
│       └── <arquivos terraform>
└── us-east-1
    ├── dev
    │   └── <arquivos terraform>
    └── prd
        └── <arquivos terraform>
```

À medida que o número de recursos em um único diretório cresce, o tempo para um `tf plan` pode se tornar excessivamente longo. Nesse caso, pode ser necessário mudar a estrutura de diretórios para `<region>/<environment>/<function>`, o que exigirá o uso de recursos como `terraform_remote_state` ou ferramentas como `terragrunt`, mas isso não será abordado neste guia.

## Ambientes (Environment)

Cada ambiente deve conter, no mínimo, um arquivo Terraform com todas as configurações relativas ao *backend* e aos provedores necessários, sendo o nosso caso o `tf_config.tf`.

Para este projeto específico, este arquivo contém duas definições cruciais: onde o arquivo de estado será armazenado e qual *role* (função) será usada para gerenciar o cluster Kubernetes.

**1. Bucket S3 do Backend**
```hcl
    key            = "us-east-1/dev/terraform.tfstate"
```
Cada arquivo de estado será salvo em seu próprio diretório dentro do bucket S3. Se criarmos um novo ambiente ou uma nova região, o caminho *deve* ser refletido na chave de backend S3. O `terragrunt` permite uma configuração transparente, criando os arquivos nos locais corretos, mas, novamente, isso não será coberto aqui.

**2. Alias do Provedor e Assunção de Função (Assume Role)**
```hcl
  alias  = "eks-manager"
  assume_role {
    role_arn     = "arn:aws:iam::111111111111:role/EKSClusterAdmin"
    session_name = "terraform-eks"
```

Esta configuração especial cria um novo provedor AWS que será referenciado como `eks-manager`. É necessário neste laboratório porque o `floci` não permite que o usuário *root* padrão tenha acesso à simulação EKS baseada em k3s.

## Criando os Recursos

Considerando que o `floci` está ativo e a configuração inicial foi concluída, você deve ser capaz de executar `tf plan` para verificar quais recursos serão criados e `tf apply` para criá-los.

* **Nota:** Você pode acessar o painel do `floci` e ver efetivamente os recursos criados lá, como se fosse o console da AWS. Acesse `http://localhost:4566/` no seu navegador e clique em `Open Floci UI` (Abrir UI Floci).
