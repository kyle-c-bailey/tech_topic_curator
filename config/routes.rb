Rails.application.routes.draw do
  resources :feeds do
    collection do
      get 'word_aggregator'
      post 'clear_entries'
    end
    member do
      get 'entries'
    end
  end
  resources :entries, only: [:index, :show]
  resources :categories
  resources :context_categories
  root 'feeds#index'
end
