# Contribuição

Cada integrante deve usar sua própria conta GitHub e manter os commits associados ao seu nome e e-mail.

1. Crie uma branch para a alteração: `git switch -c feat/nome-da-alteracao`.
2. Mantenha as mudanças concentradas em uma funcionalidade ou correção.
3. Execute `flutter analyze` e `flutter test`.
4. Faça um commit com uma mensagem que descreva a alteração.
5. Envie a branch e abra um pull request, explicando o comportamento e como foi verificado.

Evite incluir arquivos gerados de compilação, configurações locais ou chaves de assinatura. Para distribuir APKs, use a seção Releases do GitHub.

Exemplos de mensagens:

```text
feat: adiciona persistência de clientes
fix: corrige busca por nome com acentos
docs: atualiza instruções de execução
```

O histórico deve representar contribuições reais. Não altere datas ou autores para simular a participação dos integrantes.
