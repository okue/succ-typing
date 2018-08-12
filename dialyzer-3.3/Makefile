compile:
	erl -make

test: compile
	bash test.sh

xref: compile
	erl -pa ebin/ -eval "xref:d(\"ebin\")"

clean:
	rm -f ebin/*.beam
