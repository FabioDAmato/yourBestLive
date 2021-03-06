class LocaliController < ApplicationController
	def index
		@citta = params[:citta]
		if @citta.blank?
			@locale = Locale.search(params[:search])
			if @locale.blank?
				flash[:alert] = "Non sono stati trovati locali nel database"
			end
		else
			@locale = Locale.search(params[:search]).where("citta = ?", @citta)
			if @locale.blank?
				flash[:alert] = "Non sono stati trovati locali nella città di: " + @citta
			end
		end
		
	end
	
	def new
		@l=Locale.pluck(:nlocale)
		@c=City.pluck(:nomecity)
		if user_signed_in?
			@locale = Locale.new
		else
        	redirect_to locali_index_path, alert: "Effettua l'accesso per registrare un locale"
        end
	end

	def show
		require 'net/http'
		@locale = Locale.find_by_id(params[:id])
		if @locale.blank?
			redirect_to locali_index_path, alert: "Questo locale non è presente nel database"
		else
			url = "https://maps.googleapis.com/maps/api/geocode/json?address="+ @locale.indirizzo + " " + @locale.citta + " italia&key=AIzaSyC0fhD6OKoePfBR6GTaT-9wZUYa6AtiOdM"
			uri = URI(url)
			response = Net::HTTP.get(uri)

			parsed= JSON.parse(response)
			@lat= parsed["results"][0]["geometry"]["location"]["lat"].to_s
			@lng= parsed["results"][0]["geometry"]["location"]["lng"].to_s

			@map= "https://maps.googleapis.com/maps/api/staticmap?center="+ @lat +","+ @lng + "&size=1600x500&key=AIzaSyDzzFvndZ9uTXk_CwO-xHgozi9EO9DFaqw&zoom=17&markers="+ @lat +","+ @lng
		end
	end

	def create
		@locale = Locale.new(locale_params)
		if @locale.save
			flash[:notice] = "locale creato"
			redirect_to action: "index"
		else flash[:notice] = "locale errato"
			render action: "new"
		end
	end

	private
	def locale_params
		params.require(:locale).permit(:nlocale, :indirizzo, :backline, :pagamento, :capacita, :genere, :telefono, :citta, images: [])
	end
end
