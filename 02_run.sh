#!/bin/bash -e

CONTAINER_NAME="jenkins"
IMAGE_NAME="puc-sre/jenkins"
IMAGE_VERSION="latest"

# Verificar se a imagem Docker está presente localmente; puxar se não estiver
if [[ "$(docker images -q ${IMAGE_NAME}:${IMAGE_VERSION} 2> /dev/null)" == "" ]]; then
  echo "Imagem não encontrada localmente. Puxando ${IMAGE_NAME}:${IMAGE_VERSION}..."
  docker pull ${IMAGE_NAME}:${IMAGE_VERSION}
fi

# Parar e remover o contêiner Jenkins existente, se houver
echo "Parando e removendo o contêiner Jenkins existente, se houver..."
docker stop $CONTAINER_NAME || true
docker rm $CONTAINER_NAME || true

# Executar o contêiner Jenkins
echo "Iniciando o contêiner Jenkins..."
docker run --name $CONTAINER_NAME -p 8080:8080 -p 50000:50000 -d ${IMAGE_NAME}:${IMAGE_VERSION}

# Mensagem de conclusão
echo -e "\nJenkins está agora em execução. Acesse em: http://localhost:8080/"

# Capturar sinais para garantir a remoção adequada do contêiner ao sair
trap 'docker stop $CONTAINER_NAME && docker rm $CONTAINER_NAME' SIGINT
