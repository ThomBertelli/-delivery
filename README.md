# Delivery

Projeto desenvolvido durante o programa Quero Ser Dev da LSWA.

## Visão Geral

Este projeto é uma plataforma de entrega de alimentos que conecta restaurantes a consumidores. A aplicação é dividida em três partes principais:

* Delivery: Uma aplicação backend desenvolvida em Ruby on Rails para gerenciar pedidos e entregas.
* Consumy: Uma aplicação frontend desenvolvida em Vue.js para permitir que os usuários façam pedidos de restaurantes.
* Vendy: Uma aplicação fronted desenvolvida em Vue.js para que os restaurantes possam oferecer seus produtos e receber pedidos.


## Tecnologias Utilizadas

* Backend: Ruby on Rails
* Frontend: Vue.js,Tailwind CSS, PrimeVue
* Componentes:
* Banco de Dados: SQL Lite
* Autenticação: Devise (para Rails)
* API: JSON API para comunicação entre o backend e o frontend
* Fila de Tarefas: Sidekiq
* Eventos em Tempo Real: Server-Sent Events (SSE)

## Funcionalidades

### Comprador

* Cadastro e autenticação
* Excluir conta, as informações do usuário são substituídos por placeholders para garantir a privacidade
* Visualizar lojas com paginação
* Ordenar lojas por nome
* Listar produtos com paginação
* Ordenar por nome ou preço
* Realizar pagamento do pedido

### Lojista

* Cadastro e autenticação
* Excluir conta, as informações do usuário são substituídos por placeholders para garantir a privacidade
* Criar, Visualizar, Atualizar e Deletar(soft-delete) lojas
* Criar, Visualizar, Atualizar e Deletar(soft-delete) produtos
* Adicionar uma logo a loja
* Adicionar imagem do produto
* Desabilitar loja sem excluir a loja deixa de ser exibida para os compradores
* Desabilitar produtos sem exluir
* Listar histórico de pedidos com paginação
* Aceitar ou Rejeitar pedido
* Informar que o pedido saiu para entrega


### Demo

https://github.com/ThomBertelli/delivery/assets/72208322/8fc29b24-a12b-4de0-958a-229d033ba006


### Links

[Consumy](https://github.com/ThomBertelli/consumy) <br>
[Vendy](https://github.com/ThomBertelli/vendy) <br>
[Delivery](https://github.com/ThomBertelli/delivery) <br>



