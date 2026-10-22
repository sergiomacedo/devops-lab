# Floci Lab - Configuração Local do Emulador de Serviços AWS em Português Brasileiro

Este diretório contém as instruções necessárias para rodar o Floci, um emulador local para serviços AWS e serviços de orquestração de containers, permitindo que você teste fluxos de trabalho sem precisar credenciais da nuvem real ou incorrer em custos.

## 🚀 Como Começar

### Passo 1: Iniciar Floci usando Docker Compose
Usamos o `docker-compose.yml` fornecido para subir todos os serviços necessários (incluindo o emulador local cluster engine).

1.  **Executar a pilha:**
    ```bash
    docker compose up -d
    ```

2.  **Verificar status:**
    Aguarde alguns minutos para que todos os contêineres inicializem. Você pode verificar os logs:
    ```bash
    docker compose logs floci
    ```

### Passo 2: Configurar Credenciais AWS para o Endpoint Floci

Para garantir que suas ferramentas locais (como `aws cli`, Python SDKs) se comuniquem com o emulador local do Floci (`http://localhost:4566`) e não com a nuvem real da Amazon, você deve configurar as variáveis de ambiente e os arquivos de credenciais.

#### A. Definir Variáveis de Ambiente (Método Recomendado)
Definir estas variáveis no seu terminal é a maneira mais confiável de redirecionar todo o tráfego:
```bash
export AWS_ENDPOINT_URL="http://localhost:4566"
# Opcional: Definir uma região padrão se necessário para consistência nos testes
export AWS_DEFAULT_REGION="us-east-1" 
```

#### B. Configurar `~/.aws/config` (Se variáveis de ambiente forem ignoradas)
Para alguns aplicativos, você pode precisar definir explicitamente o endpoint no seu arquivo de configuração AWS localizado em `~/.aws/config`.

Adicione ou modifique a seção do perfil relevante:
```ini
[default]
region = us-east-1
# Isso direciona todos os serviços AWS para usar o emulador local Floci
endpoint_url = http://localhost:4566
```

#### C. Configurar `~/.aws/credentials` (Template)
Este arquivo deve conter credenciais de teste placeholder para múltiplas contas AWS. O nome da seção `[profile]` especifica o ID da conta (ex: [account-1]). Você pode criar novos perfis com IDs diferentes de Access Key para simular a conexão com várias contas ou ambientes AWS. **IMPORTANTE:** Todos os valores de `aws_access_key_id` DEVEM ter 12 dígitos, simulando um ID de Conta AWS real.

**Arquivo:** `~/.aws/credentials` (IDs de acesso devem simular um ID de Conta AWS de 12 dígitos)

```ini
[default]
aws_access_key_id = 111111111111
aws_secret_access_key = test
```

---
## 💡 Dicas
*   **Parar Floci:** Quando terminar, pare os serviços com: `docker compose down`
*   **Acessando Cluster Local:** Depois de configurado, suas ferramentas deverão ser capazes de interagir com o ambiente local fornecido pelo Floci.