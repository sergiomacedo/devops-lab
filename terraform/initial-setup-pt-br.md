# Guia de Configuração Inicial (Initial Setup Guide)

## Backend de Estado do Terraform

Ao provisionar qualquer nova infraestrutura usando Terraform (ou Tofu), estabelecer um mecanismo de armazenamento de backend seguro e confiável é o primeiro passo crítico para rastrear o estado dos recursos.

Nesta configuração, definimos um bucket Amazon S3 para hospedar os arquivos de estado remotos e utilizamos o DynamoDB para garantir consistência de bloqueio atômico em implantações concorrentes.

**Aviso de Melhores Práticas:**
Armazenar o estado remoto em serviços como S3 é altamente recomendado. Nunca se deve fazer *commit* de arquivos `terraform.state` locais diretamente em um repositório Git.


## Configuração Inicial do IAM AWS (IAM Setup)

O Floci não implementa todas as chamadas de API para gerenciamento de clusters EKS e não permite que o usuário *root* padrão faça login no k3s, que é o backend que simula um cluster EKS.

Para evitar uma situação de "causa e efeito" (chicken-and-egg) ao criar o cluster EKS, precisamos configurar um novo usuário e sua política antecipadamente.

Em um ambiente real, as opções fornecidas pelo módulo terraform do AWS EKS criarão os papéis (*roles*) e políticas necessárias.

## Estrutura de Diretórios (`terraform/setup`)
**Nota sobre Alias de Ferramentas:** Para simplificar este guia, usaremos a abreviação `tf` para nos referirmos genericamente tanto ao Terraform quanto ao Tofu. O fluxo operacional permanece idêntico independentemente da ferramenta que você estiver usando. Recomendamos configurar um alias para `tf` apontando para a utilidade instalada de sua preferência.

O procedimento operacional padrão exige navegar até o diretório de configuração:
1. **Pré-requisito:** Verifique se o serviço Floci está em execução (este é um pré-requisito obrigatório).
2. **Planejar (`Plan`):** Mude de diretório e execute `tf plan` dentro do diretório `./setup`. Isso valida a configuração e verifica possíveis configurações incorretas contra sua infraestrutura de destino sem fazer alterações.
3. **Aplicar (`Apply`):** Mude de diretório e execute `tf apply` dentro do diretório `./setup`. Isso provisionará os recursos definidos em seu código para o backend remoto.
4. **Verificar (`Check`):** Após aplicar, você pode verificar a criação do bucket com `aws s3 ls`.
