class ApplicationController < ActionController::Base

  allow_browser versions: :modern

  before_action :set_locale


  def init_paginate(per_page)
    @page = params[:page].to_i
    @page = 1 if @page < 1
    @per_page = params[:per_page].to_i
    @per_page = per_page if @per_page < 1
  end

  private
    def set_locale
      I18n.locale = params[:locale].presence_in(%w[en ru]) || I18n.default_locale
    end

    def default_url_options
      { locale: I18n.locale == I18n.default_locale ? nil : I18n.locale }
    end

  protected

    def init_meta(slug)
      @page_static = Page.find_by(slug: slug)
      @meta_title = @page_static.meta_tag.title
      @meta_description = @page_static.meta_tag.description
      @meta_keywords = @page_static.meta_tag.keywords
      @h1 = @page_static.h1
      @description = @page_static.description
    end
end
