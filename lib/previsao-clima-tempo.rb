#!/bin/env ruby
# encoding: utf-8

require "previsao-clima-tempo/version"
require "previsao-clima-tempo/previsao_dia"
require 'open-uri'
require "nokogiri"

class PrevisaoClimaTempo 
  
  
  attr_reader       :codCity
  
  def initialize(option)
    raise TypeError unless option.kind_of? Hash
    raise ArgumentError unless option.has_key? :codCity

    @codCity = option[:codCity]
  end
  
  
  
  # Devolve a previsão para a data informada,
  # no máximo a data atual + 13 dias
  #
  # Example:
  #   >> PrevisaoClimaTempo.day("02-03-2012".to_date)
  #
  # Arguments:
  #   date: (Date)
  #
   def day(date)
     
     days = self.days(14)
     
     day = Object
     
     days.each do |dayEach|
       break day = dayEach if dayEach.dia == date.strftime("%d-%m-%Y")   
     end
     
     day
      
   end
   
   
  # Devolve uma coleção de objetos,
  # no máximo a data atual + 13 dias
  #
  # Example:
  #   >> PrevisaoClimaTempo.days(4)
  #
  # Arguments:
  #   qtdDays: (Integer)
  #
   def days(qtdDays)
     
     days = Array.new
   
      urlPadrao    = "http://servicos.cptec.inpe.br/XML/cidade/7dias/#{@codCity}/previsao.xml"
      
      urlEstendida = "http://servicos.cptec.inpe.br/XML/cidade/#{@codCity}/estendida.xml"
      
      loadDays(urlPadrao,days,qtdDays)
      
      if(qtdDays > 4)
        
        loadDays(urlEstendida,days,qtdDays)
        
      end
      
      days
      
   end
   
   
  # Devolve um objeto com
  # as condiões do tempo do 
  # dia seguinte
  #
  # Example:
  #   >> PrevisaoClimaTempo.tomorrow()
  #
  # Arguments:
  #
   def tomorrow()
      
      self.day(Time.now + 1.days)
      
   end
   
   
  # Devolve um objeto com
  # as condiões do tempo do 
  # dia atual
  #
  # Example:
  #   >> PrevisaoClimaTempo.now()
  #
  # Arguments:
  #
   def now()
      
      self.day(Time.now)
      
   end
      
   
  # Devolve uma coleção de hashs
  # com as cidades compreendidas 
  # pelo clima tempo
  #
  # Example:
  #   >> PrevisaoClimaTempo.cities()
  #
  # Arguments:
  #
   def cities()
      
      url = "http://servicos.cptec.inpe.br/XML/listaCidades"
      
      cities = Array.new
      
      request ||= request(url)
      
      request.xpath('//cidades/cidade').each do |cidadePath|
     
         cidade = Hash.new
         
         cidade[:id]   = cidadePath.at_xpath('id').text
         cidade[:uf]   = cidadePath.at_xpath('uf').text
         cidade[:nome] = cidadePath.at_xpath('nome').text
         
         cities << cidade
      
      end
      
      cities
      
   end
   
   private
  # Devolve o doc xml
  #
  # Example:
  #   >> PrevisaoClimaTempo.request(url)
  #
  # Arguments:
  #   url: (String)
  #
  def request(url)
      begin
        
         Nokogiri::XML(open(url))
      
      rescue SocketError => e
            raise "Request failed, without connection to server."
      end
   end
   
     
   
  # Devolve uma coleção de objetos,
  # no máximo a data atual + 13 dias
  #
  # 
  #
  # Arguments:
  #   url:   (String)
  #   days: (Integer)
  #   limit: (Integer)
  #
   def loadDays(url,days,limit)
      
      previsoes ||= request(url)
      
      previsoes.xpath('//cidade/previsao').each do |previsao|
     
        days << assign(previsao) if days.size < limit 
      
      end
      
      days
      
   end
    
         
   
  # Efetua o assign do objeto PrevisaoDia
  #  
  #  
  # Example:
  #   >> PrevisaoClimaTempo.assign(previsao)
  #
  # Arguments:
  #
   def assign(previsao)
     
     PrevisaoDia.new(previsao.at_xpath('dia').text,
                     previsao.at_xpath('tempo').text,
                     previsao.at_xpath('maxima').text,
                     previsao.at_xpath('minima').text,
                     previsao.at_xpath('iuv') ? previsao.at_xpath('iuv').text : "Nao informado.")
     

     
   end
  
end
