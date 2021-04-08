Rails.application.routes.draw do
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'login', to: 'application#login'
  get 'line_redirect', to: 'application#line_redirect'
end
