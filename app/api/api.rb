# -*- coding: utf-8 -*-

class API < Grape::API
  format :json
  include Quiz::V1::Apis
end