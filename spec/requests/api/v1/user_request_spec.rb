require 'rails_helper'
require 'shoulda/matchers'

describe 'User', type: :request do

    let(:params) do
        {
        user: {
            fullname: Faker::Name.name_with_middle,
            surname: Faker::Name.first_name,
            email: Faker::Internet.email,
            phone: '+5581999999999',
            password: '123456',
            password_confirmation: '123456'
        }
        }
    end

    let(:user) { create(:user) }

    describe 'GET /users' do
        before { get api_v1_users_path }
        
        it 'returns status 200' do
            expect(response).to have_http_status(200)
        end
    end

    describe 'GET /users/:id' do
        context 'when user exists' do
            before { get api_v1_user_path(user.id) }

            it 'returns status 200' do
                expect(response).to have_http_status(200)
            end
            it 'fullname, surmane and email be_kind_of String' do
                response_body = JSON.parse(response.body)

                expect(response_body.fetch('fullname')).to be_kind_of(String)
                expect(response_body.fetch('surname')).to be_kind_of(String)
                expect(response_body.fetch('email')).to be_kind_of(String)
                expect(response_body.fetch('phone')).to be_kind_of(String)
            end
        end
        
        context 'when User does not exist' do
            it 'raises RecordNotFound when not found' do
                expect { get api_v1_user_path(0) }.to raise_error(ActiveRecord::RecordNotFound)
            end
        end
    end

    describe 'POST /users' do
        let(:created_user) { User.last }

        context 'when fullname, surname, email and phone is VALID' do
            let(:json) { JSON.parse(response.body, symbolize_names: true) }

            before { post api_v1_users_path, params: params }

            it 'returns http status 201' do
                expect(response).to have_http_status(201)
            end
            it 'creates an user' do
                expect(created_user.fullname).to eq(json.dig(:fullname))
            end
        end

        context 'when fullname, surname, email or phone is INVALID' do
            it 'returns 422 with invalid fullname' do
                post api_v1_users_path, params: { user: { fullname: nil } }
                expect(response).to have_http_status(422)
            end
            it 'returns 422 with invalid email' do
                post api_v1_users_path, params: { user: { email: 'email_without_format.com' } }
                expect(response).to have_http_status(422)
            end
            it 'returns 422 with invalid phone' do
                post api_v1_users_path, params: { user: { phone: '+558199999999' } }
                expect(response).to have_http_status(422)
            end
            it 'do not create an user' do
                expect { created_user.name }.to raise_error(NoMethodError)
            end
        end
    end

    describe 'PUT /users/:id' do
        context 'when user exists' do
            it 'returns 200 with valid name' do
                put api_v1_user_path(user.id), params: { user: { fullname: Faker::Name.name_with_middle } }
                expect(response).to have_http_status(200)
            end
            it 'returns 200 with valid email' do
                put api_v1_user_path(user.id), params: { user: { email: Faker::Internet.email } }
                expect(response).to have_http_status(200)
            end
            it 'returns 200 with valid phone' do
                put api_v1_user_path(user.id), params: { user: { phone: '+5581999999999' } }
                expect(response).to have_http_status(200)
            end
            it 'returns 422 with invalid fullname' do
                put api_v1_user_path(user.id), params: { user: { fullname: nil } }
                expect(response).to have_http_status(422)
            end
            it 'returns 422 with invalid email' do
                put api_v1_user_path(user.id), params: { user: { email: 'email_without_format.com' } }
                expect(response).to have_http_status(422)
            end
            it 'returns 422 with invalid phone' do
                put api_v1_user_path(user.id), params: { user: { phone: '+558199999999' } }
                expect(response).to have_http_status(422)
            end
        end
        context 'when user does not exists' do
            it 'raises RecordNotFound when not found' do
                expect { put api_v1_user_path(User.find(0)), params: params }.to raise_error(ActiveRecord::RecordNotFound)
            end
        end
    end
    describe 'DELETE' do
        context 'when user exists' do
            it 'returns 200' do
                delete api_v1_user_path(user.id)
                expect(response).to have_http_status(204)
            end
        end
        context 'when user does not exist' do
            it 'raises RecordNotFound when not found' do
                expect { delete api_v1_user_path(User.find(0)) }.to raise_error(ActiveRecord::RecordNotFound)
            end
        end
    end
end