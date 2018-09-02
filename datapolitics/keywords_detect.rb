require 'curb'
require 'base64'
require 'pry'
require 'json'

index_name = "datapolitics"
default_dataspec = "DpDocument"
annotators_to_run = [ 
                      {
                        annotator_name: "HighscoreAnnotator",
                        fields_to_check: ["brochure_text"],
                        input_params: {
                          number_of_keywords: 1000
                        },
                        output_param_name: "Keywords Found",
                        output_param_icon: "codewords"
                      },
                      {
                        annotator_name: "RakeAnnotator",
                        fields_to_check: ["brochure_text"],
                        input_params: {
                          number_of_keywords: 100
                        }
                      },
                      {
                        annotator_name: "TfidfKeywordAnnotator",
                        fields_to_check: ["brochure_text"],
                        input_params: {
                          num_keywords_per_document: 5}
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

