class SuggestionsController < ApplicationController
	autocomplete :user, :name
end
