Rails.application.routes.draw do
  namespace :api do
    resources :series, only: [:index, :create] do
      resources :samples, only: [:index, :create] do
        collection do
          get :peaks
        end
      end
    end
  end
  root :to => redirect('/api/series')
end
