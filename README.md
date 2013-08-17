# PrevisaoClimaTempo 
# VERSION = "0.1.4"

Communication with Clima Tempo accessing information about the weather of Brazil.

## Installation

Add this line to your application's Gemfile:

    gem 'previsao-clima-tempo'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install previsao-clima-tempo

## Usage
	 
From Webservice
	 
	 Instantiating a object.The city code should be informed.
     PrevisaoClimaTempo.new(:codCity => '3156')
     
     Returns an object PrevisaoDia with information from the current day.
     PrevisaoClimaTempo.new(:codCity => '3156').now
     
     Returns an object PrevisaoDia with information the next day.
     PrevisaoClimaTempo.new(:codCity => '3156').tomorrow
     
     Returns a collection of objects PrevisaoDia with information of days referenced.
     PrevisaoClimaTempo.new(:codCity => '3156').days(13) maximum of 13 days from the current day
     
     Returns an object PrevisaoDia with information the day referenced.
     PrevisaoClimaTempo.new(:codCity => '3156').day(date)
     
From Page(contains more information than is extracted from the webservice)
     
     Returns a hash of condtions of weather from page
	 PrevisaoClimaTempo.new(:codCity => '314').nowFromPage
	 return:
	 
	 {
		:last_update: 18:00
		:wind:
		  :velocity: 3 Km/h
		  :direction: Su-sudeste
		:moisture: 91%
		:condition: Poucas nuvens
		:pression: 1022 hPa
		:temperature: 13ºC  
 	 }
 	 
     Returns a hash of condtions of weather whith 5 days from page.
  	 PrevisaoClimaTempo.new(:codCity => '314').fullFromPage
	 return:
	 
	 {
		1:
		  :last_update: 19:00
		  :date: Sábado, 17/08/2013
		  :condition: Sol com muitas nuvens durante o dia e períodos de céu nublado. Noite
		    com muitas nuvens.
		  :wind:
		    :velocity: 6km/h
		    :direction: Su-sudeste
		  :probability_of_precipitation:
		    :volume: 0mm
		    :percentage: 0%
		  :moisture_relative_complete:
		    :max: 100%
		    :min: 49%
		  :temperature:
		    :max: 16º
		    :min: 7º
		  :uv: Alto
		  :sunrise: 06h13
		  :sunset: 17h36
		2: ...
 	 }
 	 
	 Returns a hash of condtions of weather whith 5 days from page.
	 If today is 16-12-2013 returns 21,22,23,24,25 trends.
  	 PrevisaoClimaTempo.new(:codCity => '314').trendsFromPage
	 return:
	 {
		1:
		  :date: Quinta-Feira, 22/08/2013
		  :condition: Sol com algumas nuvens. Não chove.
		  :probability_of_precipitation:
		    :volume: 0mm
		    :percentage: 0%
		  :temperature:
		    :max: 23º
		    :min: 7º
		2: 
 	 }

## Dependencies

<ul>
<li><a href="http://nokogiri.org">nokogiri</a></li>
</ul>

## License

Copyright (c) 2013 Paulo de Tarço

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.