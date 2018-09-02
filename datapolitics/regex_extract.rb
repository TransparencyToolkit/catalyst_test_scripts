require 'curb'
require 'base64'
require 'pry'
require 'json'

index_name = "datapolitics"
default_dataspec = "DpNews"
annotators_to_run = [ 
                      {
                        annotator_name: "RegexAnnotator",
                        fields_to_check: ["article_text"],
                        input_params: {
                          regex: '(?:A|a)naly\w*',
                          output_display_type: "Category"}
                      }
                     ]

docs_to_process = {
  run_over: "within_range",
  field_to_search: "publish_date",
  filter_query: "2018-03-08",
  end_filter_range: "2018-08-30"
}


   c = Curl::Easy.http_post("http://localhost:9004/annotate",
                            Curl::PostField.content('default_dataspec', default_dataspec),
                            Curl::PostField.content('index', index_name),
                            Curl::PostField.content('docs_to_process', JSON.generate(docs_to_process)),
                            Curl::PostField.content('input-params', JSON.generate(annotators_to_run)))

