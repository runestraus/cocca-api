Rails.application.routes.draw do
  get '/site/sha', to: 'site#sha'

  resources :contacts, only: [:create, :update]
  resources :orders, only: [:create, :update]

  resources :hosts, only: [:create], id: /.*/ do
    resources :addresses, controller: :host_addresses, only: [:create]
  end

  resources :domains, only: [:update], id: /.*/ do
    resources :hosts, controller: :domain_hosts, only: [:create, :destroy]
  end

  resources :partners, only: [:create]
end
