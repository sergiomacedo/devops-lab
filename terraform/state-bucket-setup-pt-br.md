# Guia de Configuração do Backend de Estado Terraform

Ao provisionar qualquer nova infraestrutura usando Terraform (ou Tofu), estabelecer um mecanismo de armazenamento de backend seguro e confiável é um passo crítico para rastrear o estado dos recursos.

Nesta configuração, definimos um bucket Amazon S3 para hospedar os arquivos de estado remotos e utilizamos o DynamoDB para garantir a consistência de bloqueio atômico em implantações concorrentes.

**Aviso de Melhor Prática:**
Armazenar o estado remoto em serviços como S3 é altamente recomendado. Commitar localmente arquivos `terraform.state` diretamente em um repositório Git não deve ser feito de forma alguma.

## Estrutura de Diretórios (`terraform/setup`)
**Aviso de Alias:** Para simplificar ao longo deste guia, usaremos a abreviação `tf` para nos referirmos genericamente tanto ao Terraform quanto ao Tofu. O fluxo de trabalho operacional permanece idêntico, independentemente da ferramenta que você está utilizando. Recomendamos configurar um alias para `tf` apontando para sua utilidade instalada preferida.

O procedimento operacional padrão exige navegar até o diretório de configuração:
1.  **Pré-requisito:** Verifique se o serviço Floci está em execução (este é um pré-requisito obrigatório).
2.  **Planear (`plan`):** Navegue até o subdiretório `./setup` e execute `tf plan`. Isso valida a configuração e verifica quaisquer configurações incorretas contra sua infraestrutura de destino sem realizar alterações.
3.  **Aplicar (`apply`):** Execute `tf apply` no subdiretório `./setup`. Isso provisionará os recursos definidos em seu código para o backend remoto.