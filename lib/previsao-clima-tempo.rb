#!/bin/env ruby
# encoding: utf-8

require "previsao-clima-tempo/version"
require "previsao-clima-tempo/previsao_dia"
require 'open-uri'
require "nokogiri"

class PrevisaoClimaTempo 
  
  
  attr_reader       :codCity, :lang, :lat, :long
  
  def initialize(option)
     
      raise TypeError     unless option.kind_of? Hash
      
      # @lang      = option.has_key? :lang    ? option[:lang]    : "br"
      @codCity ||= option[:codCity]
      @lat     ||= option[:lat]
      @long    ||= option[:long]
    
  end
  
  
  
  # Returns the forecast for the date informed,
  # maximum current date + 13 days from webservice
  #
  # Example:
  #   >> PrevisaoClimaTempo.new(:codCity => '314').day("02-03-2012".to_date)
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
   
   
  # Returns a collection of objects PrevisaoDia,
  # the maximum current date + 13 days from webservice
  # Example:
  #   >> PrevisaoClimaTempo.new(:codCity => '314').days(4)
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
   
   
  # Returns an object with
  # the conditions of weather
  # next day from webservice
  #
  # Example:
  #   >> PrevisaoClimaTempo.new(:codCity => '314').tomorrow
  #
  # Arguments:
  #
   def tomorrow()
      
      self.day(Time.now + 1.days)
      
   end
   
  # Returns an object with
  # the conditions of weather
  # next day from webservice
  #
  # Example:
  #   >> PrevisaoClimaTempo.new(:codCity => '314').tomorrow
  #
  # Arguments:
  #
   def byGeoPosition()
      
      days = Array.new
   
      url    = "http://servicos.cptec.inpe.br/XML/cidade/7dias/#{@lat}/#{@long}/previsaoLatLon.xml"
      
      loadDays(url,days,7)
      
      days
      
   end
   
   
  # Returns a hash of condtions of weather from page.
  # It's more complete than the webservice
  #
  # Example:
  #   >> PrevisaoClimaTempo.new(:codCity => '314').nowFromPage
  #
  # Arguments:
  #
   def nowFromPage
     request ||= requestHtml
     {
        :last_update => request.xpath("//span[@class='paragrafo-padrao']").text,
        :wind        => { :velocity  => request.xpath("//li[@class='dados-momento-li list-style-none'][4]/span[2]").text,
                         :direction => wind['br'][request.xpath("//li[@class='dados-momento-li list-style-none'][1]/span[2]").text]
                        },
        :moisture    => request.xpath("//li[@class='dados-momento-li list-style-none'][5]/span[2]").text,
        :condition   => request.xpath("//li[@class='dados-momento-li list-style-none'][2]/span[2]").text,
        :pression    => request.xpath("//li[@class='dados-momento-li list-style-none'][3]/span[2]").text,
        :temperature => request.xpath("//span[@class='left temp-momento top10']").text
     }
   end
   
  # Returns a hash of condtions of weather whith 5 days from page.
  # 
  # It's more complete than the webservice
  #
  # Example:
  #   >> PrevisaoClimaTempo.new(:codCity => '314').fullFromPage
  #
  # Arguments:
  #
   def fullFromPage
     
    request ||= requestHtml
    
    @previsoes = Hash.new
    count = 1
    
    until count > 5 do
         @previsoes[count] = {    
                                  :last_update                  => request.xpath("//p[@class='clear left paragrafo-padrao']").text[/(\d+)/]+":00",
                                  :date                         => request.xpath("//div[@class='box-prev-completa'][#{count}]//span[@class='data-prev']").text.strip+"/"+Time.now().year.to_s,
                                  :condition                    => request.xpath("//div[@class='box-prev-completa'][#{count}]/span[@class='left left5 paragrafo-padrao top10 fraseologia-prev']").text.strip,
                                  :wind                         => { :direction  => wind["br"][request.xpath("//div[@class='box-prev-completa'][#{count}]//li[@class='velocidade-vento-prev-completa list-style-none']//span//a[1]").text.strip],
                                                                     :velocity   => request.xpath("//div[@class='box-prev-completa'][#{count}]//li[@class='velocidade-vento-prev-completa list-style-none']//span//a[2]").text.strip},
                                  :probability_of_precipitation => { :volume     => request.xpath("//div[@class='box-prev-completa'][#{count}]//li[@class='prob-chuva-prev-completa list-style-none']/span//a[1]").text.strip,
                                                                     :percentage => request.xpath("//div[@class='box-prev-completa'][#{count}]//li[@class='prob-chuva-prev-completa list-style-none']/span//a[2]").text.strip},
                                  :moisture_relative_complete   => { :max => request.xpath("//div[@class='box-prev-completa'][#{count}]//li[@class='umidade-relativa-prev-completa list-style-none']/span[2]").text.strip,
                                                                     :min => request.xpath("//div[@class='box-prev-completa'][#{count}]//li[@class='umidade-relativa-prev-completa list-style-none']/span[3]").text.strip},
                                  :temperature                  => { :max => request.xpath("//div[@class='box-prev-completa'][#{count}]//span[@class='max']").text.strip,
                                                                     :min => request.xpath("//div[@class='box-prev-completa'][#{count}]//span[@class='min']").text.strip},
                                  :uv                           => request.xpath("//div[@class='box-prev-completa'][#{count}]//p[@class='left left10 top10 paragrafo-padrao uv-size']/span[1]").text.strip,
                                  :sunrise                      => request.xpath("//div[@class='box-prev-completa'][#{count}]//div[@class='por-do-sol']/span[3]").text.strip,
                                  :sunset                       => request.xpath("//div[@class='box-prev-completa'][#{count}]//div[@class='por-do-sol']/span[6]").text.strip
                              }
          
        count+=1
      end
      
      @previsoes
      
   end
   
  # Returns a hash of condtions of weather whith 5 days from page.
  # If today is 16-12-2013 returns 21,22,23,24,25 trends.
  # It's more complete than the webservice 
  #
  # Example:
  #   >> PrevisaoClimaTempo.new(:codCity => '314').trendsFromPage
  #
  # Arguments:
  #
   def trendsFromPage
     
     request ||= requestHtml
      
     @previsoes = Hash.new
     count = 1
        
     until count > 5 do
         @previsoes[count] = {
                                  :date                         => request.xpath("//div[@class='box-prev-tendencia'][#{count}]//span[@class='data-prev']").text.strip+"/"+Time.now().year.to_s,
                                  :condition                    => request.xpath("//div[@class='box-prev-tendencia'][#{count}]//div[@class='frase-previsao-prev-tendencia']").text.strip,
                                  :probability_of_precipitation => request.xpath("//div[@class='box-prev-tendencia'][#{count}]//li[@class='prob-chuva-prev-tendencia list-style-none']/span[2]").text.strip,
                                  :temperature                  => { :max => request.xpath("//div[@class='box-prev-tendencia'][#{count}]//span[@class='max']").text.strip,
                                                                     :min => request.xpath("//div[@class='box-prev-tendencia'][#{count}]//span[@class='min']").text.strip}
                              }
                                    
         @probability_of_precipitation = @previsoes[count][:probability_of_precipitation].split('mm')                           
                                    
         @previsoes[count][:probability_of_precipitation] = { :volume     => @probability_of_precipitation[0]+"mm" ,
                                                              :percentage => @probability_of_precipitation[1]
                                                            }
         count+=1
      end
      
      @previsoes
      
   end
   
   private
   
  # Returns a hash of cities with code, name and abbreviation of the state
  #
  # Example:
  #   >> PrevisaoClimaTempo.cities()
  #
  # Arguments:
  #
   def cities()
      
      url = "http://servicos.cptec.inpe.br/XML/listaCidades"
      
      cities = Array.new
      
      request ||= requestXml(url)
      
      request.xpath('//cidades/cidade').each do |cidadePath|
     
         cidade = Hash.new
         
         cidade[:id]   = cidadePath.at_xpath('id').text.strip
         cidade[:uf]   = cidadePath.at_xpath('uf').text.strip
         cidade[:nome] = cidadePath.at_xpath('nome').text.strip
         
         cities << cidade
      
      end
      
      cities
      
   end
      
   def wind
     {
       "br" => 
         {
           "N"   => "Norte",
           "S"   => "Sul",
           "E"   => "Leste",
           "W"   => "Oeste",
           "NE"  => "Nordeste",
           "NW"  => "Noroeste",
           "SE"  => "Sudeste",
           "SW"  => "Sudoeste",
           "ENE" => "Les-nordeste",
           "ESE" => "Lés-sudeste",
           "SSE" => "Su-sudeste",
           "NNE" => "Nor-nordeste",
           "NNW" => "Nor-noroeste",
           "SSW" => "Su-sudoeste",
           "WSW" => "Oés-sudoeste",
           "WNW" => "Oés-noroeste"
         },
       "en" => 
         {
           "N"    => "North",
           "S"    => "South",
           "E"    => "East",
           "W"    => "West",
           "NE"   => "Northeast",
           "NW"   => "Northwest",
           "SE"   => "Southeast",
           "SW"   => "Southwest",
           "ENE"  => "east-northeast",
           "ESE"  => "east-southeast",
           "SSE"  => "south-southeast",
           "NNE"  => "north-northeast",
           "NNO"  => "north-northwest",
           "SSWO" => "south-southwest",
           "OSO"  => "west-southwest",
           "ONO"  => "west-northwest"
         }
     }
   end
   

  # Arguments:
  #   url: (String)
  #
  def requestXml(url)
      begin
        
         Nokogiri::XML(open(url))
      
      rescue SocketError => e
            raise "Request failed, without connection to server."
      end
   end
   

   def requestHtml
      request = Net::HTTP.get URI.parse("http://www.climatempo.com.br/previsao-do-tempo/cidade/#{@codCity}/empty")
      request = Nokogiri::HTML request
    end
   

  # Arguments:
  #   url:   (String)
  #   days: (Integer)
  #   limit: (Integer)
  #
   def loadDays(url,days,limit)
      
      previsoes ||= requestXml(url)
      
      previsoes.xpath('//cidade/previsao').each do |previsao|
     
        days << assign(previsao) if days.size < limit 
      
      end
      
      days
      
   end
    
         
   def assign(previsao)
     
     PrevisaoDia.new(previsao.at_xpath('dia').text,
                     previsao.at_xpath('tempo').text,
                     previsao.at_xpath('maxima').text,
                     previsao.at_xpath('minima').text,
                     previsao.at_xpath('iuv') ? previsao.at_xpath('iuv').text : "Nao informado.")
   end
  
end
