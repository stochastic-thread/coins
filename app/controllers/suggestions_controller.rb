class SuggestionsController < ApplicationController
	autocomplete :user, :name, :display_value => :show_name
end
