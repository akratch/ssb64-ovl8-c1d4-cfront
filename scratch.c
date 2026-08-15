void func_ovl8_8037C1D4(u8** src, u8** dest, s32 count)
{
    s32 var_a3;
    u8* var_v0;
    u8* var_v1;

    var_v0 = *src;
    var_v1 = *dest;
    var_a3 = count;

    while (var_a3 > 0)
    {
        u8 curr = *var_v0;
        u32 next = *var_v0 + 1;

        if (curr & 0x80)
        {
            s16 run_length = (u8)(-curr++) + 1;
            s16 temp_t1;
            var_v0++;

            temp_t1 = run_length--;

            while (temp_t1)
            {
                u8 *a2 = var_v1++;\
                temp_t1 = run_length--;
                *a2 = *var_v0;
                var_a3--;
            }

            var_v0++;
        }
        else
        {
            s16 run_length = curr++ + 1;
            s16 temp_t1;
            var_v0++;

            temp_t1 = run_length--;

            while (temp_t1)
            {
                u8 *a2 = var_v1++, *t2 = var_v0++;\
                temp_t1 = run_length--;
                *a2 = *t2;
                var_a3--;
            }
        }
    }

    *src = var_v0;
    *dest = var_v1;
}
