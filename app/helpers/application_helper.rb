module ApplicationHelper

  def switch_locale_label
    (I18n.locale.to_sym == :ru ? :en : :ru).to_s.upcase
  end

  def date_at(value, delimetr = '-')
    if value.nil?
      delimetr
    else
      value.strftime('%d.%m.%Y')
    end
  end

  def meta_title
    if @meta_title.nil?
      "Koder Lab"
    else
      @meta_title
    end
  end

  def meta_description
    if @meta_description.nil?
      ""
    else
      @meta_description
    end
  end

  def meta_keywords
    if @meta_keywords.nil?
      ""
    else
      @meta_keywords
    end
  end

  def self.translit(string)
    replacements = {
      "А" => "A",  "а" => "a",
      "Б" => "B",  "б" => "b",
      "В" => "V",  "в" => "v",
      "Г" => "G",  "г" => "g",
      "Д" => "D",  "д" => "d",
      "Е" => "Ye", "е" => "e",
      "Ё" => "Yo", "ё" => "yo",
      "Ж" => "Zh", "ж" => "zh",
      "З" => "Z",  "з" => "z",
      "И" => "I",  "и" => "i",
      "Й" => "Y",  "й" => "y",
      "К" => "K",  "к" => "k",
      "Л" => "L",  "л" => "l",
      "М" => "M",  "м" => "m",
      "Н" => "N",  "н" => "n",
      "О" => "O",  "о" => "o",
      "П" => "P",  "п" => "p",
      "Р" => "R",  "р" => "r",
      "С" => "S",  "с" => "s",
      "Т" => "T",  "т" => "t",
      "У" => "U",  "у" => "u",
      "Ф" => "F",  "ф" => "f",
      "Х" => "Kh", "х" => "kh",
      "Ц" => "Ts", "ц" => "ts",
      "Ч" => "Ch", "ч" => "ch",
      "Ш" => "Sh", "ш" => "sh",
      "Щ" => "Shch","щ" => "shch",
      "Ы" => "Y",  "ы" => "y",
      "Э" => "E",  "э" => "e",
      "Ю" => "Yu", "ю" => "yu",
      "Я" => "Ya", "я" => "ya",
      "Ь" => "",   "ь" => "",
      "Ъ" => "",   "ъ" => ""
    }

    clean_string = string.gsub(/[^0-9A-Za-zА-Яа-я\s]/, '').tr(' ', '-')
    transliterated = clean_string.each_char.map { |char| replacements[char] || char }.join
    transliterated.gsub(/-{2,}/, '-')
  end


end
