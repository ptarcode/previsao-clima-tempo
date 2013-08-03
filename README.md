# PrevisaoClimaTempo

Permiti o acesso as funcionalidades e informações do Clima Tempo.

## Installation

Add this line to your application's Gemfile:

    gem 'previsao-clima-tempo'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install previsao-clima-tempo

## Usage
	 
	 Instanciando um objeto.Pro padrão o código da cidade deve ser informado.
     PrevisaoClimaTempo.new(:codCity => '3156')
     
     
     Devolve um objeto PrevisaoDia com as informações do dia atual.
     PrevisaoClimaTempo.new(:codCity => '3156').now
     
     Devolve um objeto PrevisaoDia com as informações do dia seguinte.
     PrevisaoClimaTempo.new(:codCity => '3156').tomorrow
     
     Devolve um collection  de objetos PrevisaoDia com as informações dos dias referenciados.
     PrevisaoClimaTempo.new(:codCity => '3156').days(13) máximo de 13 dias a partir do dia atual
     
     Devolve um objeto PrevisaoDia com as informações do dia referenciado.
     PrevisaoClimaTempo.new(:codCity => '3156').day(date) 
 

## Dependencies

<ul>
<li><a href="http://nokogiri.org">nokogiri</a></li>
</ul>