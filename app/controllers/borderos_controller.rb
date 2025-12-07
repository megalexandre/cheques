class BorderosController < ApplicationController
  # POST /borderos/preview
  def preview
    bordero_preview_form = BorderoPreviewForm.new(params)

    if bordero_preview_form.valid?
      render json: bordero_preview_form.to_h, status: :ok
    else
      render json: { errors: bordero_preview_form.errors.full_messages }, status: :bad_request
    end
  end
end
