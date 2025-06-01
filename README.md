# Conversor de Moedas

Um aplicativo Flutter para conversão de moedas em tempo real, com histórico de conversões realizadas.

## Funcionalidades

- Conversão de Real (BRL) para Dólar (USD) e Euro (EUR)
- Conversão em tempo real utilizando API de taxas de câmbio
- Interface amigável e intuitiva
- Armazenamento do histórico de conversões
- Visualização do histórico com data e hora das conversões
- Possibilidade de limpar o histórico

## Tecnologias Utilizadas

- Flutter
- Dart
- Provider (gerenciamento de estado)
- http (requisições à API)
- shared_preferences (armazenamento local)
- intl (formatação de datas e valores monetários)

## Screenshots

_Screenshots do aplicativo serão adicionados aqui_

## Como Usar

1. Clone este repositório:

```bash
git clone https://github.com/PedroLeuchs/conversorDeMoedas.git
```

2. Navegue até o diretório do projeto:

```bash
cd conversorDeMoedas
```

3. Instale as dependências:

```bash
flutter pub get
```

4. Execute o aplicativo:

```bash
flutter run
```

## API Utilizada

O aplicativo utiliza a API gratuita de taxas de câmbio do "Open Exchange Rates" para obter as cotações atualizadas das moedas.

## Estrutura do Projeto

- `/lib/models` - Modelos de dados
- `/lib/providers` - Gerenciadores de estado (Provider)
- `/lib/screens` - Telas do aplicativo
- `/lib/services` - Serviços para API e armazenamento
- `/lib/utils` - Utilitários e constantes

## Desenvolvido por

Pedro Leuchs - [GitHub](https://github.com/PedroLeuchs)

## Licença

Este projeto está sob a licença MIT. Consulte o arquivo LICENSE para mais detalhes.
