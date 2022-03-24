function RescueSyntaxPython()
	hi link pythonStatement		Statement
	hi link pythonConditional		Conditional
	hi link pythonRepeat		Repeat
	hi link pythonOperator		Operator
	hi link pythonException		Exception
	hi link pythonInclude		Include
	hi link pythonAsync			Statement
	hi link pythonDecorator		Define
	hi link pythonDecoratorName		Function
	hi link pythonFunction		Function
	hi link pythonComment		Comment
	hi link pythonTodo			Todo
	hi link pythonString		String
	hi link pythonRawString		String
	hi link pythonQuotes		String
	hi link pythonTripleQuotes		pythonQuotes
	hi link pythonEscape		Special

	hi link pythonNumber		Number
	hi link pythonBuiltin		Function
	hi link pythonExceptions		Structure
	hi link pythonSpaceError		Error
	hi link pythonDoctest		Special
	hi link pythonDoctestValue	Define
endfun

function PythonCompiler()
	"the last line: \%-G%.%# is meant to suppress some
	"late error messages that I found could occur e.g.
	"with wxPython and that prevent one from using :clast
	"to go to the relevant file and line of the traceback.
	setlocal errorformat=
	\%A\ \ File\ \"%f\"\\\,\ line\ %l\\\,%m,
	\%C\ \ \ \ %.%#,
	\%+Z%.%#Error\:\ %.%#,
	\%A\ \ File\ \"%f\"\\\,\ line\ %l,
	\%+C\ \ %.%#,
	\%-C%p^,
	\%Z%m
	"\%-G%.%#
endfun

function! RescueCocHighlights()
  hi default link NormalFloat Pmenu
  hi default link CocHintFloat DiffAdd
  hi default link CocErrorFloat DiffDelete

endfun
