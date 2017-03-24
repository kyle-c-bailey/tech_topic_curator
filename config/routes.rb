Rails.application.routes.draw do
  resources :feeds do
    collection do
      get 'word_aggregator'
    end
    member do
      get 'entries'
    end
  end
  resources :entries, only: [:index, :show]
  resources :categories
  root 'feeds#index'
end
