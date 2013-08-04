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