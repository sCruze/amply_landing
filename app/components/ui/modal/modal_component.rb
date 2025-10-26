# frozen_string_literal: true

class Ui::Modal::ModalComponent < ViewComponent::Base
  SCHEMES        = %i[dark light].freeze
  HEADER_LAYOUTS = %i[split row none].freeze
  SIZES          = %i[sm md lg xl].freeze

  renders_one :header_top
  renders_one :header_bottom
  renders_one :header_row
  renders_one :footer
  renders_one :body

  attr_reader :id, :title, :scheme, :header_layout, :size, :data, :modal_class, :dialog_class

  def initialize(
    id:,
    title: nil,
    scheme: :dark,
    header_layout: :split,
    size: :md,
    modal_class: nil,
    dialog_class: nil,
    data: {}
  )
    @id            = id
    @title         = title
    @scheme        = SCHEMES.include?(scheme) ? scheme : :dark
    @header_layout = HEADER_LAYOUTS.include?(header_layout) ? header_layout : :split
    @size          = size
    @modal_class   = modal_class
    @dialog_class  = dialog_class
    @data          = default_data.merge(data)
  end

  # корневые классы модалки (ui-нотация)
  def modal_classes
    [
      "ui-modal",
      "ui-modal--#{scheme}", # ui-modal--dark | ui-modal--light
      "ui-modal--#{size}",   # ui-modal--sm|md|lg|xl
      modal_class
    ].compact.join(" ")
  end

  # классы диалога
  def dialog_classes
    ["ui-modal__dialog", dialog_class].compact.join(" ")
  end

  private

  def default_data
    {
      controller: "modal",
      action: "click->modal#close keydown@window->modal#keydown",
      modal_open_class_value: "is-open",
      modal_close_on_esc_value: true,
      modal_close_on_bg_value: true,
      modal_lock_scroll_value: true,
      modal_auto_open_value: false,
      modal_target: "modalWrapper"
    }
  end
end
