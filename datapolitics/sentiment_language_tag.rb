require 'curb'
require 'base64'
require 'pry'
require 'json'

index_name = "datapolitics"
default_dataspec = "DpNews"
annotators_to_run = [ {
                        annotator_name: "SentimentAnnotator",
                        fields_to_check: ["article_text"]
                      },
                      {
                        annotator_name: "LanguageAnnotator",
                        fields_to_check: ["article_text"]
                      }
                     ]

docs_to_process = {
  run_over: "unprocessed",
  field_to_search: "catalyst_sentiment"
}


   c = Curl::Easy.http_post("http://localhost:9004/annotate",
                            Curl::PostField.content('default_dataspec', default_dataspec),
                            Curl::PostField.content('index', index_name),
                            Curl::PostField.content('docs_to_process', JSON.generate(docs_to_process)),
                            Curl::PostField.content('input-params', JSON.generate(annotators_to_run)))

