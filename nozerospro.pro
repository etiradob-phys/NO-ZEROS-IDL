function no_zerospro,vect,constant,replace, BAD_VECT = bad_vect

;-------------------------------------------------------------
program='nozerospro.pro'                                                        ; Name of programs

var=vect
IF n_params() LT 2 THEN constant=0 ELSE constant=constant                       ; Read constant parameter for zero vectors
IF n_params() LT 3 THEN replace=0  ELSE replace=replace                         ; Read replace parameter for zero gasps

sivar=size(var)
nsivar=sivar(1)                                                                 ; Gets size of the vector input

Countpixzero=where(var EQ 0)                                                    ; Gets pixels of zero values (no data or sound)
sicountpixzero=size(Countpixzero)                                               ; Gets numbers of pixels equals to zeros
nsize=sicountpixzero(1)

iniveczero=FIX(Countpixzero(0))                                                 ; Creates a new vector with the pixels numbers of the initial zero gaps

IF nsize EQ nsivar THEN GOTO,con_1                                              ; Case zero pixels equal a total of vector pixels
IF sicountpixzero(0) EQ 0 AND iniveczero EQ -1 THEN GOTO,con_2                  ; Case there are no zero pixels, no need of modifications

pixinizero=[Countpixzero(0)]
pixfinzero=[0]                                                                  ; Creates a new vector with the pixel numbers of zero and the final zero gaps
diff=[pixinizero-pixfinzero]                                                    ; Creates a new vector with the differences between initial and final pixels numbers of zero gaps

IF nsize  EQ 1 THEN BEGIN
  pixfinzero=[pixfinzero,Countpixzero(0)]
  diff=[diff,nsivar-1-Countpixzero(0)]
  GOTO,skip_1
ENDIF

IF Countpixzero(1)-Countpixzero(0) GT 1 THEN BEGIN
    pixfinzero=[pixfinzero,Countpixzero(0)]
    diff=[diff,Countpixzero(1)-Countpixzero(0)]
ENDIF

FOR ii=1,nsize-2 DO BEGIN 
    x=Countpixzero(ii-1)
    y=Countpixzero(ii)
    z=Countpixzero(ii+1)
        
    IF y-x GT 1 THEN BEGIN
        pixinizero=[pixinizero,y] 
        diff=[diff,y-x]
    ENDIF
    
    IF z-y GT 1 THEN pixfinzero=[pixfinzero,y]        
ENDFOR
   
   
IF Countpixzero(nsize-1)-Countpixzero(nsize-2) GT 1 THEN BEGIN      
    pixinizero=[pixinizero,Countpixzero(nsize-1)] 
    diff=[diff,Countpixzero(nsize-1)-Countpixzero(nsize-2)]
ENDIF
    
pixfinzero=[pixfinzero,Countpixzero(nsize-1)]
diff=[diff,nsivar-1-Countpixzero(nsize-1)]

skip_1:
sizerogaps=size(pixinizero)
nsizerogaps=sizerogaps(1)
 
  
FOR jj=0,nsizerogaps-1 DO BEGIN                                                        ; Identifies zero gasps and intervals before and after them that not contain zero gaps
     f=pixinizero(jj)                                                                  ; Initial zero gasp pixel
     g=pixfinzero(jj+1)                                                                ; Final zero gasp pixel
     
     h=diff(jj)                                                                        ; Space to the previous gasp
     i=diff(jj+1)                                                                      ; Space to the next gasp
     
     lowval=f-6
     upval=g+6
     
     IF N_params() EQ 3 THEN GOTO,writemean

     IF f EQ 0 THEN BEGIN
        
        lmean=mean(var(upval-5:upval))
        IF i LE 5 THEN BEGIN 
          lmean=mean(var(upval-5:upval-6+i))     
        ENDIF
        GOTO,writemean
     ENDIF
     
     IF g EQ nsivar-1 THEN BEGIN
        
        lmean=mean(var(lowval:lowval+5))
        IF h LE 5 THEN BEGIN 
          lmean=mean(var(lowval-h+6:lowval+5))
        ENDIF
        GOTO,writemean
     ENDIF 

     IF h LE 5 THEN BEGIN
          ;lmeandown=mean(var(upval-4:upval+h-1)) 
          lmeandown=mean(var(lowval-h+6:lowval+5))
          GOTO,down
     ENDIF
     
     lmeandown=mean(var(lowval:lowval+5))
     down:
     
     IF i LE 5 THEN BEGIN
          ;lmeanup=mean(var(lowval-i+1:lowval+4)) 
          lmeanup=mean(var(upval-5:upval+i-6))
          GOTO,up
     ENDIF
     
     lmeanup=mean(var(upval-5:upval))
     up:
     
     calmean=[lmeandown,lmeanup]
     lmean=mean(calmean)
     
     writemean:
      
     FOR ss=f,g DO BEGIN
           IF N_params() LT 3 THEN var(ss)=lmean ELSE var(ss)=replace
     ENDFOR
    

ENDFOR


con_1:
var=var+constant

con_2:
var=var

bad_vect = 0B
return,var

;======================================================================
;===================== Invalid out section   ==========================
;======================================================================

;NOTVALID:
;bad_vect = 1B
;message, 'Invalid input date specified', /INFORMATIONAL
;return, -1


END
