require 'fox16'

require_relative 'TestProlog'

include Fox

class GUI < FXMainWindow
  def initialize(app)
    super(app,"Peliculas", :width => 650, :height => 660)

    #Menu
    barra = FXMenuBar.new(self,:opts => LAYOUT_SIDE_TOP|LAYOUT_FILL_X)
    menu_arch = FXMenuPane.new(self)
    FXMenuTitle.new(barra,"Archivo",nil,menu_arch)

    menuArchivo = FXMenuCommand.new(menu_arch,"Abrir",:target => @abre, :selector => FXDataTarget::ID_VALUE)
    menuGuardar = FXMenuCommand.new(menu_arch,"Guardar",:target => @abre, :selector => FXDataTarget::ID_VALUE)
    menuSalir = FXMenuCommand.new(menu_arch,"Salir",nil,getApp(),FXApp::ID_QUIT)

    hf = FXHorizontalFrame.new(self,:opts => LAYOUT_FILL)
    #matriz
    m = FXMatrix.new(hf,1,:opts => MATRIX_BY_COLUMNS)
    FXLabel.new(m,"INFORMACION DE UNA PELICULA O ELIMINAR", :opts => LAYOUT_CENTER_X)
    ####buscar informacion de una pelicula y eliminar
    FXLabel.new(m,"Nombre de la pelicula:")
    @nombrePelicula = FXDataTarget.new("")
    FXTextField.new(m,40,:target => @nombrePelicula, :selector => FXDataTarget::ID_VALUE)
    btnbuscarInfo = FXButton.new(m,"Buscar")
    btnDeleteMovie = FXButton.new(m, "Eliminar pelicula")
    
    #### agregar una pelicula
    FXLabel.new(m,"AGREGAR PELICULA", :opts => LAYOUT_CENTER_X)
    FXLabel.new(m,"Nombre de la pelicula:")
    @nomPeli = FXDataTarget.new("")
    FXTextField.new(m,40,:target => @nomPeli, :selector => FXDataTarget::ID_VALUE)
    FXLabel.new(m,"Año: ")
    @anio = FXDataTarget.new("")
    FXTextField.new(m,40,:target => @anio, :selector => FXDataTarget::ID_VALUE)
    FXLabel.new(m,"Director: ")
    @director = FXDataTarget.new("")
    FXTextField.new(m,40,:target => @director, :selector => FXDataTarget::ID_VALUE)
    btnAgregar = FXButton.new(m,"Agregar")

    #### modificar  una pelicula
    FXLabel.new(m,"MODIFICAR PELICULA", :opts => LAYOUT_CENTER_X)
    FXLabel.new(m,"Pelicula a modificar:")
    @peliVieja = FXDataTarget.new("")
    FXTextField.new(m,40,:target => @peliVieja, :selector => FXDataTarget::ID_VALUE)
    FXLabel.new(m,"Nuevo nombre de la pelicula:")
    @peliNueva = FXDataTarget.new("")
    FXTextField.new(m,40,:target => @peliNueva, :selector => FXDataTarget::ID_VALUE)
    FXLabel.new(m,"Nuevo año: ")
    @añoModificar = FXDataTarget.new("")
    FXTextField.new(m,40,:target => @añoModificar, :selector => FXDataTarget::ID_VALUE)
    btnModificar = FXButton.new(m,"Modificar")

    FXLabel.new(m, "Entrada de texto") #Etiqueta del campo
    @predicado = FXDataTarget.new("")
    FXTextField.new(m,45,:target => @predicado, :selector => FXDataTarget::ID_VALUE)
    btnPredicado = FXButton.new(m,"Enviar predicado")

    #### area de texto vertical
    vf = FXVerticalFrame.new(hf,:opts => LAYOUT_FILL)
    FXLabel.new(vf,"INFORMACION DE SALIDA", :opts => LAYOUT_CENTER_X)
    @text = FXText.new(vf,:opts => LAYOUT_FILL|TEXT_WORDWRAP)

    ### Eventos###

    menuArchivo.connect(SEL_COMMAND) do
      dialog = FXFileDialog.new(self, "Abre archivo prolog..")
      dialog.selectMode = SELECTFILE_EXISTING
      dialog.patternList = ["Archivos Prolog (*.pl)", "Todos (*)"]
      if dialog.execute != 0 then
        rutaList = dialog.filename.to_s().split("\\")
        rlPos = rutaList.length - 1
        puts rutaList[rlPos]
        @prolog = Prolog.new(rutaList[rlPos])
        #@prolog = Prolog.new('movies.pl')
        puts "archivo leido #{rutaList[rlPos]}"
      end
    end

    menuGuardar.connect(SEL_COMMAND) do
      menuGuardar.connect(SEL_COMMAND) do
        if File.exist?('ficheroCreado.txt') then
          File.open('ficheroCreado.txt', 'r+') do |f1|
          f1.write "#{@text.getText}"
          @text.setText("EL ARCHIVO SE GUARDO CORRECTAMENTE")
          end
        else
           File.open('ficheroCreado.txt', 'w') do |f1|
           f1.write "#{@text.getText}"
           @text.setText("EL ARCHIVO SE GUARDO CORRECTAMENTE")
        end
        end
      end 
    end

    btnbuscarInfo.connect(SEL_COMMAND) do
      if @prolog == nil then
        puts "Hay que abrir el archivo de movies.pl primero"
        @text.setText( "Hay que abrir el archivo de movies.pl primero")
      else
        puts(@nombrePelicula)
        q = "buscarM(#{@nombrePelicula})"
        puts ("mande #{q}\n")
        r = @prolog.haz(q)
        @text.setText("#{r[0]}")
      end
    end

    btnAgregar.connect(SEL_COMMAND) do
      if @prolog == nil then
        puts "Hay que abrir el archivo de movies.pl primero"
        @text.setText( "Hay que abrir el archivo de movies.pl primero")
      else
        puts "(#{@nomPeli},#{@anio},#{@director})"
        q = "agregarM(#{@nomPeli},#{@anio},#{@director})"
        puts "mande #{q}\n"
        r = @prolog.haz(q)
        puts "Recibi \n #{r}"
        @text.setText("Se agrego #{@nomPeli} con año #{@anio} y director #{@director} correctamente")
      end
    end

    btnModificar.connect(SEL_COMMAND) do
      if @prolog == nil then
        @text.setText( "Hay que abrir el archivo de movies.pl primero")
      else
        q = "updateMovie(#{@peliVieja},#{@peliNueva},_,#{@añoModificar})"
        puts q
        puts "#{@peliVieja}"
        puts "#{@peliNueva}"
        r = @prolog.haz(q)
        @text.setText("Se modifico la pelicula #{@peliVieja} correctamente con el nombre de #{@peliNueva} y año de #{@añoModificar}")
      end      
      
    end
    
    btnDeleteMovie.connect(SEL_COMMAND) do
          puts "boton elmininar"
          if @prolog == nil then
            @text.setText( "Hay que abrir el archivo de movies.pl primero")
          else
            q = "deleteMovie(#{@nombrePelicula})"
            puts q
            r = @prolog.haz(q)
            @text.setText("Se elimino la pelicula #{@nombrePelicula} correctamente")
          end
      end

    btnPredicado.connect(SEL_COMMAND) do

      if @prolog == nil then
        puts "Hay que abrir el archivo primero"
        @text.setText( "Hay que abrir el archivo BD.pl primero")
      else
        q = @predicado.value
        puts q
        r = @prolog.haz(q)
        until (r == nil)
          puts r
          @text.appendText(r[0]+"\n")
          r = @prolog.next
      end
      end
     end

  end #fin def initialize

  def create
    super
    show(PLACEMENT_SCREEN)
  end
end

if __FILE__ == $0 then
  app = FXApp.new("AppSen")
  ven = GUI.new(app)
  app.create
  app.run
end
