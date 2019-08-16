:- discontiguous
        movie/2,
        director/2,
        actor/3,
        actress/3,
        menu/0,
        hazOpcion/1,
        subMenu2/1.

:- dynamic
        movie/2,
        director/2,
        actor/3,
        actress/3,
		menu.

:-consult('BD').

interprete(M,A):-actor(M,A,_);actress(M,A,_).

member(X,[X|Xs]).
member(X,[Y|Xs]):-!,member(X,Xs).



hazMeta:-read(G),call(G),write(G),nl,fail;true.

escribe():-
	open('BD.pl',write,S),
	assert(movie(avengers_end_game,2012)),
	set_output(S),
	listing(movie/2),
    listing(director/2),
    listing(actor/3),
    listing(actress/3),
    close(S).

modificaPelicula(M,N):-
	findall(D,director(M,D),Ld),
	findall((A1,P1),actor(M,A1,P1),La1),
	findall((A2,P2),actress(M,A2,P2),La2),
	open('BD.pl',write,S),
	retract(movie(M,An)), %borra
	retractall(director(M,_)),
	retractall(actor(M,_,_)),
	retractall(actress(M,_,_)),
	assert(movie(N,An)), %actualiza
	(member(X,Ld),assert(director(N,X)),fail;true),
	(member((X,Y),La1),assert(actor(N,X,Y)),fail;true),
	(member((X,Y),La2),assert(actress(N,X,Y)),fail;true),
	set_output(S),
	listing(movie/2),
	listing(director/2),
	listing(actor/3),
	listing(actress/3),
	close(S).
	
%Modificar peicula 2da opcion
updateMovie(M1,M2,Y1,Y2):-
	open('BD.pl',write,S),
	movie(M1,Y1),
	findall(D,director(M1,D),Directores),
	findall((A1,P1),actor(M1,A1,P1),Actores),
	findall((A2,P2),actress(M1,A2,P2),Actrices),
	
	% Elimina dependencias
	retract(movie(M1,Y1)),
	retractall(director(M1,_)),
	retractall(actor(M1,_,_)),
	retractall(actress(M1,_,_)),

	% Crea nuevas dependencias
	assert(movie(M2,Y2)),
	(member(X,Directores),assert(director(M2,X)),fail;true),
	(member((A,R),Actores),assert(actor(M2,A,R)),fail;true),
	(member((A,R),Actrices),assert(actress(M2,A,R)),fail;true),
	set_output(S),
	listing(movie/2),
	listing(director/2),
	listing(actor/3),
	listing(actress/3),
	close(S).
	
buscarM(M):-
	%write('Ingrese el nombre de la pelicula'),nl,
	%read(M),
	%write("Hola"),
	consult('BD.pl'),
	clause(movie(M,_),_),
	findall(A,interprete(M,A),Interpretes),
	write('Actores: '),write(Interpretes),nl,
	movie(M,Y),
	write('Año: '),write(Y),nl,
	findall(D,director(M,D),Directores),	
	write('Director/es: '),write(Directores),nl,nl.

%Eliminar Pelicula
deleteMovie(M):-
	open('BD.pl',write,S),
	retract(movie(M,_)), %borra
	retractall(director(M,_)),
	retractall(actor(M,_,_)),
	retractall(actress(M,_,_)),
	set_output(S),
	listing(movie/2),
	listing(director/2),
	listing(actor/3),
	listing(actress/3),
	close(S).
%Eliminar Director
deleteDirector(P,D):-s
	retractall(director(P,D)).
	
%Eliminar Actor
deleteActor(P,A,_):-
	retract(actor(P,A,_)).

%Eliminar Actress
deleteActres(P,A,_):-
	retract(actress(P,A,_)).



agregarM(M, Y, D):-
	open('BD.pl',write,S),
	assert(movie(M,Y)),
	assert(director(M,D)),
	%assert(actor(M,A,R)),
	%assert(actress(M,AC,R)),
	set_output(S),
	listing(movie/2),
    listing(director/2),
    listing(actor/3),
    listing(actress/3),
	close(S).
	
hazOpcion(3):-
	write('Modificar informacion de una pelicula'),nl,
	write('\t\ta)Modificar nombre de una pelicula
		b)Modificar Director de una pelicula
		c)Modificar Actor pelicula
		d)Modificar Actriz de una pelicula
		e)Regresar al menu principal'),nl,
	   read(Op),
	subMenu2(Op).
	
	subMenu2(a):-
		write('Ingrese el nombre de la pelicula'),nl,
		read(M),
		write('Escribe el nuevo nombre de la pelicula'),nl,
		read(N),
		movie(M,An),
		findall(D,director(M,D),Ld),
		findall((A1,P1),actor(M,A1,P1),La1),
		findall((A2,P2),actress(M,A2,P2),La2),
		open('BD.pl',write,S),
		retract(movie(M,An)), %borra
		retractall(director(M,_)),
		retractall(actor(M,_,_)),
		retractall(actress(M,_,_)),
		assert(movie(N,An)), %actualiza
		(member(X,Ld),assert(director(N,X)),fail;true),
		(member((X,Y),La1),assert(actor(N,X,Y)),fail;true),
		(member((X,Y),La2),assert(actress(N,X,Y)),fail;true),
		set_output(S),
		listing(movie/2),
    	listing(director/2),
    	listing(actor/3),
    	listing(actress/3),
    	close(S),
		hazOpcion(2).
	
	subMenu2(b):-
		write('Ingrese el nombre de la pelicula'),nl,
		read(M),
		write('Ingrese el nuevo nombre del director'),nl,
		read(D2),
		director(M,D1),
		open('BD.pl',write,S),
		retract(director(M,D1)),
		assert(director(M,D2)),
		set_output(S),
		listing(movie/2),
    	listing(director/2),
    	listing(actor/3),
    	listing(actress/3),
    	close(S),
		hazOpcion(2).
		
	subMenu2(c):-
		write('Ingrese el nombre de la pelicula'),nl,
		read(M),
		write('Ingrese el nombre del actor'),nl,
		read(A1),
		write('Ingrese el nuevo nombre del actor'),nl,
		read(A2),
		actor(M,A1,Rol),
		open('BD.pl',write,S),set_output(S),
		retract(actor(M,A1,Rol)),
		assert(actor(M,A2,Rol)),
		set_output(S),
		listing(movie/2),
    	listing(director/2),
    	listing(actor/3),
    	listing(actress/3),
		close(S),
		hazOpcion(2).
		
	subMenu2(d):-
		write('Ingrese el nombre de la pelicula'),nl,
		read(M),
		write('Ingrese el nombre del la actriz'),nl,
		read(A1),
		write('Ingrese el nuevo nombre de la actriz'),nl,
		read(A2),
		actress(M,A1,Rol),
		open('BD.pl',write,S),set_output(S),
		retract(actress(M,A1,Rol)),
		assert(actress(M,A2,Rol)),
		set_output(S),
		listing(movie/2),
    	listing(director/2),
    	listing(actor/3),
    	listing(actress/3),
		close(S),
		hazOpcion(2).
		
	subMenu2(e):- 
		write('e) salir de submenu'),nl,
		menu.
	
hazOpcion(4):-
	write('Borrar informacion de una pelicula'),nl,
	write('\t\ta)Eliminar actor de una pelicula
		b)Eliminar actriz de una pelicula
		c)Eliminar director de una pelicula
		d)Eliminar toda la informacion de una pelicula
		e)Regresar al menu principal'),nl,
	read(Op),
	opSubMenu(Op).
	opSubMenu(a):-
		write('Borrar actor de una pelicula'),nl,
		write('Ingresa el nombre de la pelicula en la que participo'),nl,
		read(M),
		write('Ingresa el nombre del actor'),nl,
		read(A)
		open('BD.pl',write,S),
		retract(actor(M,A,_)),
		set_output(S),
		listing(movie/2),
		listing(director/2),
		listing(actor/3),
		listing(actress/3),
		close(S),
		hazOpcion(4).
		
	opSubMenu(b):-
		write('Eliminar actriz de una pelicula'),nl,
		write('Ingresa el nombre de la pelicula en la que participo'),nl,
		read(M),
		write('Ingresa el nombre de la actriz'),nl,
		read(A),
		open('BD.pl',write,S),
		retract(actress(M,A,_)),
		set_output(S),
		listing(movie/2),
		listing(director/2),
		listing(actor/3),
		listing(actress/3),
		close(S),
		hazOpcion(4).
	
	opSubMenu(c):-
		write('Eliminar director de una pelicula'),nl,
		write('Ingresa el nombre de la pelicula que dirigio'),nl,
		read(M),
		write('Ingresa el nombre del Director'),nl,
		read(D),
		open('BD.pl',write,S),
		retract(director(M,D)),
		set_output(S),
		listing(movie/2),
		listing(director/2),
		listing(actor/3),
		listing(actress/3),
		close(S),
		hazOpcion(4).
		
	opSubMenu(d):-
		write('Borrar toda la informacion de la pelicula'),nl,
		write('Ingrese el nombre de la pelicula'),nl,
		read(M),
		open('BD.pl',write,S),
		retract(movie(M,_)), %borra
		retractall(director(M,_)),
		retractall(actor(M,_,_)),
		retractall(actress(M,_,_)),
		set_output(S),
		listing(movie/2),
    	listing(director/2),
    	listing(actor/3),
    	listing(actress/3),
    	close(S),
    	hazOpcion(4).
			
	opSubMenu(e):-
		write('Regresa a menu princial'),nl,
		menu.	
		


																												
