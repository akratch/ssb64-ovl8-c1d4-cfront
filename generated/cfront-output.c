# 1 "input.C"

/* <<AT&T USL C++ Language System <3.0.1> 02/03/92>> */
/* < input.C > */

# 1 "input.C"
void *__vec_new (void *, int , int , void *);

# 1
void __vec_ct (void *, int , int , void *);

# 1
void __vec_dt (void *, int , int , void *);

# 1
void __vec_delete (void *, int , int , void *, int , int );
typedef int (*__vptp)(void);
struct __mptr {short d; short i; __vptp f; };

# 1
typedef short s16 ;
typedef long s32 ;
typedef unsigned char u8 ;
typedef unsigned int u32 ;
extern struct __mptr* __ptbl_vec__input_C_func_ovl8_8037C1D4_[];
void func_ovl8_8037C1D4__FPPUcT1l (u8 **__1src , u8 **__1dest , s32 __1count )
# 7
{ 
# 8
s32 __1var_a3 ;
u8 *__1var_v0 ;
u8 *__1var_v1 ;

# 12
__1var_v0 = ((*__1src ));
__1var_v1 = ((*__1dest ));
__1var_a3 = __1count ;

# 16
while (__1var_a3 > 0 )
# 17
{ 
# 18
u8 __2curr ;
u32 __2next ;

# 18
__2curr = ((*__1var_v0 ));
__2next = (((*__1var_v0 ))+ 1 );

# 21
if (__2curr & 0x80 )
# 22
{ 
# 23
s16 __3run_length ;
s16 __3temp_t1 ;

# 23
__3run_length = ((((unsigned char )(- (__2curr ++ ))))+ 1 );

# 25
__1var_v0 ++ ;

# 27
__3temp_t1 = (__3run_length -- );

# 29
while (__3temp_t1 )
# 30
{ 
# 31
u8 *__4a2 ;

# 31
__4a2 = (__1var_v1 ++ );

# 31
__3temp_t1 = (__3run_length -- );

# 33
((*__4a2 ))= ((*__1var_v0 ));
__1var_a3 -- ;
}

# 37
__1var_v0 ++ ;
}
else 
# 40
{ 
# 41
s16 __3run_length ;
s16 __3temp_t1 ;

# 41
__3run_length = ((__2curr ++ )+ 1 );

# 43
__1var_v0 ++ ;

# 45
__3temp_t1 = (__3run_length -- );

# 47
while (__3temp_t1 )
# 48
{ 
# 49
u8 *__4a2 ;

# 49
u8 *__4t2 ;

# 49
__4a2 = (__1var_v1 ++ );

# 49
__4t2 = (__1var_v0 ++ );

# 49
__3temp_t1 = (__3run_length -- );

# 51
((*__4a2 ))= ((*__4t2 ));
__1var_a3 -- ;
}
}
}

# 57
((*__1src ))= __1var_v0 ;
((*__1dest ))= __1var_v1 ;
}

# 59

/* the end */
