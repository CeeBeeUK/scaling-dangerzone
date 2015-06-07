require 'rails_helper'
describe ContactsController do
  describe 'GET #index' do
    let(:smith) { create(:contact, lastname: 'Smith') }
    let(:jones) { create(:contact, lastname: 'Jones') }
    context 'with params[:letter]' do
      before(:each) { get :index, letter: 'S' }
      it 'populates an array of contacts starting with the letter' do
        expect(assigns(:contacts)).to match_array([smith])
      end
      it 'renders the :index template' do
        expect(response).to render_template :index
      end
    end
    context 'without params[:letter]' do
      before(:each) { get :index }
      it 'populates an array of all contacts' do
        expect(assigns(:contacts)).to match_array([smith, jones])
      end
      it 'renders the :index template' do
        expect(response).to render_template :index
      end
    end
  end
  describe 'GET #show' do
    let(:contact) { create(:contact) }
    before :each do
      get :show, id: contact
    end
    it 'assigns the requested contact to @contact' do
      expect(assigns(:contact)).to eq contact
    end
    it 'renders the :show template' do
      expect(response).to render_template :show
    end
  end
  describe 'GET #new' do
    before(:each) { get :new }
    it 'assigns a new Contact to @contact' do
      expect(assigns(:contact)).to be_a_new(Contact)
    end
    it 'renders the :new template' do
      expect(response).to render_template :new
    end
  end
  describe 'GET #edit' do
    before(:each) do
      @contact = create(:contact)
      get :edit, id: @contact
    end
    it 'assigns the requested contact to @contact' do
      expect(assigns(:contact)).to eq @contact
    end
    it 'renders the :edit template' do
      expect(response).to render_template :edit
    end
  end
  describe 'POST #create' do
    before :each do
      @phones = [
        attributes_for(:phone),
        attributes_for(:phone),
        attributes_for(:phone)
      ]
    end
    context 'with valid attributes' do
      it 'saves the new contact in the database' do
        expect {
          post :create, contact: attributes_for(:contact,
            phones_attributes: @phones)
        }.to change(Contact, :count).by(1)
      end
      it 'redirects to contacts#show' do
        post :create, contact: attributes_for(:contact,
          phones_attributes: @phones
        )
        expect(response).to redirect_to contact_path(assigns[:contact])
      end
    end
    context 'with invalid attributes' do
      it 'does not save the new contact in the database' do
        expect{
          post :create,
               contact: attributes_for(:invalid_contact)
        }.not_to change(Contact, :count)
      end
      it 're-renders the :new template' do
        post :create,
             contact: attributes_for(:invalid_contact)
        expect(response).to render_template :new
      end
    end
  end
  describe 'PATCH #update' do
    before(:each) do
      @contact = create(:contact,
        firstname: 'Lawrence',
        lastname: 'Smith'
      )
    end
    context 'with valid attributes' do
      it 'locates the requested @contact' do
        patch :update, id: @contact, contact: attributes_for(:contact)
        expect(assigns(:contact)).to eq(@contact)
      end
      it 'updates the contact in the database' do
        patch :update, id: @contact,
              contact: attributes_for(:contact,
                                      firstname: 'Larry',
                                      lastname: 'Smith')
        @contact.reload
        expect(@contact.firstname).to eq('Larry')
        expect(@contact.lastname).to eq('Smith')
      end
      it 'redirects to the contact' do
        patch :update, id: @contact, contact: attributes_for(:contact)
        expect(response).to redirect_to @contact
      end
    end
    context 'with invalid attributes' do
      it 'does not update the contact' do
        patch :update, id: @contact,
              contact: attributes_for(:contact,
                                      firstname: 'Larry',
                                      lastname: nil)
        @contact.reload
        expect(@contact.firstname).not_to eq('Larry')
        expect(@contact.lastname).to eq('Smith')
      end
      it 're-renders the :edit template' do
        patch :update, id: @contact,
              contact: attributes_for(:invalid_contact)
        expect(response).to render_template :edit
      end
    end
  end
  describe 'DELETE #destroy' do
    before(:each) do
      @contact = create(:contact)
    end
    it 'deletes the contact from the database' do
      expect{
        delete :destroy, id: @contact
      }.to change(Contact,:count).by(-1)
    end
    it 'redirects to users#index' do
      delete :destroy, id: @contact
      expect(response).to redirect_to contacts_url
    end
  end
end
