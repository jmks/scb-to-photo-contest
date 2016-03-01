PhotoContest::Application.routes.draw do
  root to: "root#index"

  devise_for :judges, controllers: { sessions: 'judges/sessions' }, skip: [:registrations]
  devise_for :contestants, controllers: { registrations: 'registrations' }

  static_pages = %w{ prizes judges rules about terms contest judging_criteria }
  static_pages.each do |page|
    get "/#{page}", to: "root#".concat(page), as: page
  end
  post '/contact', to: 'root#contact', as: 'contact'

  get '/contestant', to: 'contestants#index', as: 'contestant_index'

  # TODO: move to photos collection, but keep path helper name?
  get '/photos/flora',      to: 'photos#flora',      as: 'flora'
  get '/photos/fauna',      to: 'photos#fauna',      as: 'fauna'
  get '/photos/landscapes', to: 'photos#landscapes', as: 'landscapes'

  resources :contests, only: [:new, :create]

  resources :photos do
    collection do
      get 'page/:page', action: 'index', as: 'page'
    end

    member do
      post "/comment",        action: "comment",        as: "new_comment"
      post "/vote",           action: "vote",           as: "vote"
      post "/report_comment", action: "report_comment", as: "report_comment"
    end
  end

  scope "/photo_entry" do
    get  '/',       to: 'photo_entry#workflow', as: 'workflow_photo_entry'
    get  '/new',    to: 'photo_entry#new',      as: 'new_photo_entry'
    post '/',       to: 'photo_entry#create',   as: 'photo_entry'
    get  '/order',  to: 'photo_entry#order',    as: 'order'
    get  '/verify', to: 'photo_entry#verify',   as: 'verify'
    post '/verify_orders', to: 'photo_entry#verify_orders', as: 'verify_orders'
    get  '/share',  to: 'photo_entry#share',    as: 'share_photos'
  end

  # tags
  get '/tags', to: 'tag#index', as: 'tags'

  # admin
  get  '/admin',                   to: 'admin#index',           as: 'admin_root'
  post '/admin/confirm_photo/:id', to: 'admin#confirm_photo',   as: 'admin_confirm_photo'
  post '/admin',                   to: 'admin#add_judge',       as: 'admin_add_judge'
  post '/admin/mark_exhibitor',    to: 'admin#mark_exhibitor',  as: 'admin_mark_as_exhibitor'

  # judges
  get  '/judges/index',     to: 'judges#index',           as: 'judge_root'
  post '/judges/shortlist', to: 'judges#shortlist_photo', as: 'judge_shortlist'
  post '/judges/shortlist_remove', to: 'judges#remove_from_shortlist', as: 'judge_shortlist_remove'

  # judge scoring
  get  '/judges/photo_score/:id', to: 'judge_score#score_photo',           as: 'photo_score'
  post '/judges/photo_score/:id', to: 'judge_score#save_photo_score',      as: 'save_photo_score'
  post '/judges/photo_score',     to: 'judge_score#finalize_photo_scores', as: 'finalize_photo_scores'

  # winner
  get    "/winners",                      to: "winners#index",          as: "winners"
  post   '/winners/assign_winner',        to: 'winners#assign_winner',  as: 'assign_winner'
  delete '/winners/remove_winner/:prize', to: 'winners#remove_winner',  as: 'remove_winner'
  post   '/winners/notify_winners',       to: 'winners#notify_winners', as: 'admin_notify_winners'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
