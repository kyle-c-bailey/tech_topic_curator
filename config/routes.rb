Rails.application.routes.draw do
  resources :feeds do
    member do
     resources :entries, only: [:index, :show]
    end
  end
  root 'feeds#index'
end
