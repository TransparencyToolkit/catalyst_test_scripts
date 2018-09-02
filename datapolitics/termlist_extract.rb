require 'curb'
require 'base64'
require 'pry'
require 'json'

index_name = "datapolitics"
default_dataspec = "DpNews"
annotators_to_run = [ 
                      {
                        annotator_name: "TermlistAnnotator",
                        fields_to_check: ["article_text"],
                        input_params: {
                          term_list: File.read("country_names.json"),
                          case_sensitive: false},
                        output_param_name: "Countries Mentioned",
                        output_param_icon: "countries"
                      },
                      {
                        annotator_name: "NormalizedTermlistAnnotator",
                        fields_to_check: ["article_text"],
                        input_params: {
                          term_list: File.read("normalized_topics.json"),
                          case_sensitive: false},
                        output_param_name: "Normalized Topics Discussed",
                        output_param_icon: "document-topic"
                      }
                     ]

docs_to_process = {
  run_over: "all",
}


   c = Curl::Easy.http_post("http://localhost:9004/annotate",
                            Curl::PostField.content('default_dataspec', default_dataspec),
                            Curl::PostField.content('index', index_name),
                            Curl::PostField.content('docs_to_process', JSON.generate(docs_to_process)),
                            Curl::PostField.content('input-params', JSON.generate(annotators_to_run)))

