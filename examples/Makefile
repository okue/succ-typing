compile:
	erl -make

dialyzer: compile
	dialyzer ebin\
		--no_check_plt\
		-Wunmatched_returns -Werror_handling\
		-Wrace_conditions\
		-Wunderspecs -Woverspecs

typer: compile
	typer *.erl

clean:
	rm ebin/*.beam
