From: Michael Ellerman <mpe@ellerman.id.au>
In-Reply-To: <CAGXu5jLTTcyGyY2KtuCX3tCThvGH0mCnFWyLaznyng=nTss6Dw@mail.gmail.com>
References: <1487410400-28313-1-git-send-email-mpe@ellerman.id.au> <CAGXu5jLTTcyGyY2KtuCX3tCThvGH0mCnFWyLaznyng=nTss6Dw@mail.gmail.com>
Date: Wed, 22 Feb 2017 13:44:55 +1100
Message-ID: <87d1eblza0.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH] usercopy: Don't test 64-bit get/put_user() on 32-bit powerpc
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, linuxppc-dev@lists.ozlabs.orglinuxppc-dev@lists.ozlabs.org
List-ID: <kernel-hardening.lists.openwall.com>

Kees Cook <keescook@chromium.org> writes:

> On Sat, Feb 18, 2017 at 1:33 AM, Michael Ellerman <mpe@ellerman.id.au> wrote:
>> Add PPC32 to the opt-out list, otherwise it breaks the build.
>>
>> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>> ---
>>  lib/test_user_copy.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/lib/test_user_copy.c b/lib/test_user_copy.c
>> index 4a79f2c1cd6e..6f335a3d4ae2 100644
>> --- a/lib/test_user_copy.c
>> +++ b/lib/test_user_copy.c
>> @@ -37,6 +37,7 @@
>>                             !defined(CONFIG_MICROBLAZE) &&      \
>>                             !defined(CONFIG_MN10300) &&         \
>>                             !defined(CONFIG_NIOS2) &&           \
>> +                           !defined(CONFIG_PPC32) &&           \
>>                             !defined(CONFIG_SUPERH))
>>  # define TEST_U64
>>  #endif
>
> I'm fine to add this, but I'm curious why it fails? ppc uaccess.h has:
>
> #define get_user(x, ptr) \
>         __get_user_check((x), (ptr), sizeof(*(ptr)))
>
> #define __get_user_check(x, ptr, size)                                  \
> ({                                                                      \
> ...
>                 __get_user_size(__gu_val, __gu_addr, (size), __gu_err); \
>
> #define __get_user_size(x, ptr, size, retval)                   \
> do {                                                            \
> ...
>         case 8: __get_user_asm2(x, ptr, retval);  break;        \
>
> #ifdef __powerpc64__
> #define __get_user_asm2(x, addr, err)                   \
>         __get_user_asm(x, addr, err, "ld")
> #else /* __powerpc64__ */
> #define __get_user_asm2(x, addr, err)                   \
>         __asm__ __volatile__(                           \
> ...
>
> It looks like __get_user_asm2() was explicitly designed for handling
> 64-bit get_user()?

Hmm, quite.

It's definitely failing:

  ERROR: "__get_user_bad" [lib/test_user_copy.ko] undefined!


I suspect it's because get_user() goes via __get_user_check(), which
uses an unsigned long as a temporary:

  #define __get_user_check(x, ptr, size)					\
  ({									\
  	long __gu_err = -EFAULT;					\
  	unsigned long  __gu_val = 0;					\
  	const __typeof__(*(ptr)) __user *__gu_addr = (ptr);		\
  	might_fault();							\
  	if (access_ok(VERIFY_READ, __gu_addr, (size)))			\
  		__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
  	(x) = (__force __typeof__(*(ptr)))__gu_val;				\
  	__gu_err;							\
  })


And that trips the check in __get_user_size():

  #define __get_user_size(x, ptr, size, retval)			\
  do {								\
  	retval = 0;						\
  	__chk_user_ptr(ptr);					\
  	if (size > sizeof(x))					\
  		(x) = __get_user_bad();				\



Which I can confirm just by changing that case to call
__get_user_bad_target() instead of __get_user_bad_size():

  ERROR: "__get_user_bad_target" [lib/test_user_copy.ko] undefined!


So despite having __get_user_asm2() defined for 32-bit it doesn't
actually work unless you call __get_user_size() directly.


For now if you don't mind merging this that would be good, so the build
stops breaking.

Then we can think about whether we fix it for ppc32 or just rip it out
entirely.

cheers
