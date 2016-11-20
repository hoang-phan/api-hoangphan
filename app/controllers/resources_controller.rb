class ResourcesController < ApplicationController
  before_action :set_default_response_format

  def index
    render json: resources
  end

  def show
    render json: resource
  end

  def create
    save resource_scope.new(resource_params)
  end

  def update
    resource.assign_attributes(resource_params)
    save resource
  end

  def destroy
    resource.destroy
    render json: resource
  end

  protected

    def resources
      @resources ||= resource_scope.all
    end

    def resource_klass
      @resource_klass ||= controller_name.singularize.camelize.constantize
    end

    def resource
      @resource ||= @resource_scope.find(params[:id])
    end

    def resource_scope
      resource_klass
    end

    def resource_key
      controller_name.singularize
    end

    def resource_params
      params.require(resource_key).permit(*permitted_params)
    end

    def permitted_params
      resource_klass.column_names - %w(created_at updated_at)
    end

    def save(resource)
      if resource.save
        render json: resource
      else
        render json: { errors: resource.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    end
end
