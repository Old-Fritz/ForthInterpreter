: IMMEDIATE  last_word @ cfa 1 - dup c@ 1 or swap c! ;


: rot >r swap r> swap ;
: double_dup swap dup rot dup rot swap ;

: if ' 0branch , here 0  , ; IMMEDIATE
: else ' branch , here 0 , swap here swap !  ; IMMEDIATE
: then here swap ! ; IMMEDIATE
: endif ' then execute ; IMMEDIATE

: repeat here ; IMMEDIATE
: until  ' 0branch , , ; IMMEDIATE 

: for 
	' swap , ' >r , ' >r ,
	here ' r> , ' r> ,
	' double_dup , ' >r , ' >r , ' < ,
	' 0branch , here 0 , swap 
; IMMEDIATE
: endfor 
	' r> , ' lit , 1 , ' + , ' >r ,
	' branch , , here swap ! ' r> ,
	' drop , ' r> , ' drop ,
; IMMEDIATE

