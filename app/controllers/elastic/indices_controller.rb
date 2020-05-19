class Elastic::IndicesController < ApplicationController
  def create
    Object.const_get(params["class_name"]).create_index
    redirect_back(fallback_location: root_path)
  end

  def switch_index
    Object.const_get(params["class_name"]).switch_alias(new_index_name: params["index_name"])
    redirect_back(fallback_location: root_path)
  end

  def import
    klass = Object.const_get(params["class_name"])
    klass.import_all_record(target_index: klass.index_name)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    Object.const_get(params["class_name"]).delete_index(params["index_name"])
    redirect_back(fallback_location: root_path)
  end
end
