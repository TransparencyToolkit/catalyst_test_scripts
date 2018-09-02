require 'curb'
require 'base64'
require 'pry'
require 'json'

index_name = "datapolitics"
default_dataspec = "DpDocument"
annotators_to_run = [ 
                      {
                        annotator_name: "EmailAnnotator",
                        fields_to_check: ["brochure_text"],
                      },
                      {
                        annotator_name: "PhoneAnnotator",
                        fields_to_check: ["brochure_text"],
                      },
                      {
                        annotator_name: "UrlAnnotator",
                        fields_to_check: ["brochure_text"]
                      },
                      {
                        annotator_name: "IpAnnotator",
                        fields_to_check: ["brochure_text"]
                      }
                     ]

docs_to_process = {
  run_over: "matching_query",
  field_to_search: "brochure_text",
  filter_query: "data"
}


   c = Curl::Easy.http_post("http://localhost:9004/annotate",
                            Curl::PostField.content('default_dataspec', default_dataspec),
                            Curl::PostField.content('index', index_name),
                            Curl::PostField.content('docs_to_process', JSON.generate(docs_to_process)),
                            Curl::PostField.content('input-params', JSON.generate(annotators_to_run)))

