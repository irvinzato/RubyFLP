require 'open3'
require 'expect'

class Prolog
  # Prolog
  @@prolog = "swipl"
  def initialize(file)
    cmd = "#{@@prolog} -l #{file}"
    # Conexión a Prolog
    @stdin, @stdout, @stderr, @wt = Open3.popen3(cmd)

    # SWIPL manda mensaje inicial a stderr
    fs = @stderr.expect("d).")
    puts fs
  end

  def haz(cmd)
    @stdin.write("#{cmd}.\n")
    res = @stdout.expect("true.",1)
    if res == nil then
      res = @stdout.expect("false.",1)
    end
    if res == nil then
       res = @stdout.expect(/\w+ = \w+/,1)
    end
    return res
  end

  def next
    # Obten el siguiente resultado
    @stdin.write(";\n")
    res = @stdout.expect("false.",1)
    if res == nil then
        res = @stdout.expect(/\w+ = \w+/,1)
    end
    return res
  end

  def fin
    @stdin.close
    serr = @stderr.readlines;
    @stderr.close
    sout = @stdout.readlines;
    @stdout.close
    puts "Err #{serr}"
    puts "Out #{sout}"
    puts @wt.value
  end
end

if __FILE__ == $0 then
  p = Prolog.new("p.pl")
  r = p.haz("member(X,[1,2,3,4])") # GENERA UN ARRAY
  until (r == nil) # se cambio por r[0] =~ /false./ tenia pero causaba un error
    puts r
    r = p.next
  end
  p.fin
  puts "Se termino"
end
