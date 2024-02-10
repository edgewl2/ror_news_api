class Api::V1::Articles::SourcesController < ApplicationController

  before_action :set_source, only: [:show, :update, :destroy]

  def index
    @sources = Source.all

    render json: @sources, status: :ok
  end

  def show
    if @source.present?
      render json: @source, status: :ok
    else
      render json: @source.errors, status: :not_found
    end
  end

  def create
    @source = Source.new(source_params)

    if @source.new_record? && @source.save
      render json: @source, status: :created, location: @source
    else
      render json: { error: @source.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @source.update(source_params)
      render json: @source, status: :accepted
    else
      render json: { error: @source.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @source.destroy

    render json: { error: "Article destroyed" }, status: :no_content
  end

  private
  def set_source
    @source = Source.find(params[:id])
  rescue => e
    Rails.logger.error "Error: #{e.message}"
    render json: { error: "Cannot found the source with id: #{params[:id]}" }, status: :bad_request
  end

  def source_params
    params.require(:source)
          .permit(:name,
                  :description,
                  :url,
                  :category,
                  :language,
                  :country
          )
  end
end
