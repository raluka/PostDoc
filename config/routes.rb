Rails.application.routes.draw do
  root 'mailboxes#index'
  resources :mailboxes
  resources :emails, only: [:show] do
    member do
      get '/preview', to: 'emails#body_preview'
    end
  end

  scope :v3 do
    post '/mail/send', to: 'api/emails#create'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
