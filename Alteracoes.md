**Alterei:**

1. Uso de uma etapa de construção para reduzir a quantidade de camadas.
2. Refatoração da estrutura do Dockerfile para instalar pacotes e criar usuários apenas uma vez.
3. Utilização de argumentos de compilação para permitir a personalização das versões do Jenkins.
4. Remoção do ambiente `JAVA_OPTS` para economizar camadas e reduzir o tamanho da imagem.
5. Remoção da variável `IMAGE_VERSION` e do código relacionado, pois não parece ser necessário com essas mudanças.
**Usando ARG para especificar a versão do Jenkins:**
6. Certifique-se de que o argumento JENKINS_VERSION seja usado de maneira consistente. No seu Dockerfile, você está usando JENKINS_VERSION para definir a versão na URL do Jenkins, mas você também poderia usá-lo diretamente no nome do arquivo ou em qualquer outro lugar que seja necessário.
**Combinação de etapas:**
7.  Ao instalar pacotes e executar comandos, você pode combinar várias instruções RUN em uma para reduzir o número de camadas criadas na imagem Docker. Isso ajuda a reduzir o tamanho final da imagem.
**Limpeza do cache do APK:**
8.  Após a instalação dos pacotes com o APK, é uma boa prática realizar a limpeza do cache do APK para reduzir o tamanho da imagem. Isso é feito para evitar que o cache do APK seja incluído na imagem final.

**Criei os scripts 01_build.sh e 02_run.sh.**
**Este script para o ./01_build.sh faz o seguinte:**
./01_build.sh fernanda, ele irá construir a imagem com o nome puc-sre/jenkins:latest usando o padrão "latest" para a tag.

**Este script para o ./02_run.sh faz o seguinte:**
Para qualquer contêiner Jenkins existente, ele é parado e removido.
Um novo contêiner Jenkins é iniciado usando a imagem puc-sre/jenkins:latest e é mapeado para a porta 8080 do host.
Uma mensagem informativa é exibida indicando que o Jenkins está em execução e pode ser acessado em http://localhost:8080/.

Variáveis: Usei as variáveis CONTAINER_NAME, IMAGE_NAME, e IMAGE_VERSION para tornar o script mais flexível e fácil de manter.
Uso de Variáveis: Substituí o uso direto de "jenkins" pelo uso da variável $CONTAINER_NAME para garantir consistência.
Argumentos do Docker Run: Substituí jenkins:tag por ${IMAGE_NAME}:${IMAGE_VERSION} para garantir que a versão correta da imagem seja usada.
Lidando com Contêiner Existente: Ajustei a lógica de parada e remoção do contêiner anterior para evitar usar o operador lógico && para executar ambas as operações, mesmo que uma delas falhe.