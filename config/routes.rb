Rails.application.routes.draw do
  resources :feeds do
    collection do
      get 'word_aggregator'
    end
    member do
     resources :entries, only: [:index, :show]
    end
  end
  root 'feeds#index'
end
