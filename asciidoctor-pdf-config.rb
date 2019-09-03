#
# asciidoctor-pdf 設定
#

# 日本語を含む SVG出力
Prawn::Svg::Font::GENERIC_CSS_FONT_MAPPING.merge!(
    'sans-serif' => 'KaiGen Gothic JP'
)
