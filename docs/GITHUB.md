# Publicação no GitHub

Use a pasta que contém `pubspec.yaml` como raiz do repositório. Envie o código extraído do pacote, não o arquivo ZIP sozinho.

## Pelo terminal

1. Crie um repositório vazio chamado `metalhub` na sua conta GitHub. Não adicione outro README pelo site.
2. Na pasta do código-fonte, execute:

```sh
git init -b main
git add .
git status
```

3. Confira os arquivos selecionados. Configure seu nome e e-mail no Git, se necessário, e crie o primeiro commit:

```sh
git commit -m "Adiciona aplicativo MetalHub"
```

4. Copie o endereço do repositório criado no GitHub. No comando abaixo, substitua `URL_DO_REPOSITORIO` por esse endereço:

```sh
git remote add origin URL_DO_REPOSITORIO
git push -u origin main
```

## Pelo site

Crie o repositório, use **Add file → Upload files** e arraste os arquivos extraídos para a raiz. Inclua também a pasta oculta `.github` para habilitar o workflow. Se o seletor não exibir pastas ocultas, prefira o envio pelo Git.

## Depois do envio

- Abra o README e confira as imagens.
- Confira a execução do workflow na aba Actions.
- Convide os demais integrantes em Settings → Collaborators.
- Cada integrante deve usar a própria conta e enviar suas alterações.
- Publique APKs pela seção Releases, sem incluí-los no histórico do código.

O `.gitignore` exclui builds, caches, configurações locais e arquivos de assinatura. O pacote para publicação também omite identificadores pessoais de equipe de assinatura iOS. A equipe deve ser configurada no Xcode ao executar em aparelho físico.
