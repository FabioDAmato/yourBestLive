require 'rails_helper'

describe CittaController , :type => :controller do
	describe 'get index' do
        context "user request the index" do
            it "makes the array of cities available to the view" do
                #Arrange
                c = [double(:city),double(:city)]
                allow(City).to receive(:all) {c}
                #Act
                get :index
                #Assert
                expect(assigns(:citta)).to eq(c)
            end

            it "should select the index template for rendering" do
                #Act
                get :index
                #Assert
                expect(response).to render_template :index
            end
        end
    end



describe 'get show' , :type => :controller do
        context "user request a drum in database" do
            before do
                @citta = FactoryBot.create(:city)
                    
            end
            it "makes the cityselected available" do
                #Arrange
                allow(City).to receive(:find) { @citta }
                #Act
                get :show, params: {id: @citta.id }
                #Assert
                expect(assigns(:citta)).to eq(@citta)
            end
        end
    end



describe 'get new' do
        context 'user logged in' do
            before do
                @user = FactoryBot.create(:user)
                sign_in @user
            end
            it "should create an object to initialize the template fields" do
                #Act
                get :new
                #Assert
                expect(assigns(:citta)).not_to eq(nil)
            end 
            
            it "should select the new template for rendering" do
                #Act
                get :new
                #Assert
                expect(response).to render_template :new
            end
        end
    end
end 

