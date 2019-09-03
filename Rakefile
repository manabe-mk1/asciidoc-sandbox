require 'rake/clean'
require 'open3'
require 'csv'
require 'time'

Encoding.default_external = 'UTF-8'

task :default => 'pdf'

task :pdf => %w[pdf:history pdf:document]

namespace :pdf do
  task :history do
    FileUtils.mkdir('histories') unless FileTest.exist?('histories')
    git_log = "git log --reverse --pretty=format:%h,%s,%an,%ad contents"
    output, error, status = Open3.capture3(git_log)
    CSV.open('histories/contents.csv', 'w') do |file|
      CSV.parse(output).each do |row|
        hash = row[0]
        subject = ''
        name = row[2]
        time = row[3]
        xrefs = ''

        match = row[1].match(/\[\[(.*)\]\]((<<[^<>]*>>)*)(\([^()]*\))?/)
        unless match.nil?
          subject = match[1] unless match[1].nil?
          time    = match[4] unless match[4].nil?
          xrefs   = match[2]
                        .split(/<<([^<>]*)>>/)
                        .reject { |word| word.empty? }
                        .select { true }
                        .map { |word| "<<#{word}>>" }
                        .join('') unless match[2].nil?
        end

        aliases = {
            'git user' => '名前',
        }
        name = aliases[row[2]] if aliases.has_key?(name)

        date = Time.parse(time).strftime('%Y年%m月%d日')
        file << [date, subject, name, xrefs] unless subject.empty?
      end
    end
  end

  desc 'ドキュメント'
  task :document do
    sh "asciidoctor-pdf" <<
      " -r asciidoctor-diagram" <<
      " -r ./asciidoctor-pdf-config.rb " <<
      " -r asciidoctor-pdf-cjk-kai_gen_gothic -a pdf-stylesdir=. -a pdf-style=KaiGenGothicJP" <<
      " main.adoc -o document.pdf -a imagesdir=diagram -a imagesoutdir=diagram"
  end
end

CLEAN.include('./.asciidoctor')
CLEAN.include('./diagram')
CLEAN.include('./histories')
CLEAN.include('./document.pdf')
