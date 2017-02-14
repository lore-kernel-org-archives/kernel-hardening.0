Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
From: Hoeun Ryu <hoeun.ryu@gmail.com>
In-Reply-To: <CAGXu5jLhqFx5gZWB7GFdz_zfphJbnUgwrjHNSxHEFBt8ujtPPg@mail.gmail.com>
Date: Wed, 15 Feb 2017 08:42:37 +0900
Content-Transfer-Encoding: quoted-printable
Message-Id: <E113B6A6-F18E-4413-AFFA-9956FAB361F0@gmail.com>
References: <1486880019-8201-1-git-send-email-hoeun.ryu@gmail.com> <CAGXu5j+ogVnxxu1VuUep6ObAdyJbvxMyN25J+PF+exOJqk2VVg@mail.gmail.com> <CAGXu5jLfpq=vn0V_41NbLPyxkPQzGVwvo33tnErkmtcx8TOf4g@mail.gmail.com> <2C0135CD-ACCF-462F-B7C6-E8554C6C99BF@gmail.com> <CAGXu5jLhqFx5gZWB7GFdz_zfphJbnUgwrjHNSxHEFBt8ujtPPg@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH] usercopy: add testcases to check zeroing on failure of usercopy
To: Kees Cook <keescook@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


> On Feb 15, 2017, at 5:36 AM, Kees Cook <keescook@chromium.org> wrote:
>=20
>> On Mon, Feb 13, 2017 at 5:44 PM, Hoeun Ryu <hoeun.ryu@gmail.com> wrote:
>>=20
>>=20
>>>> On Feb 14, 2017, at 4:24 AM, Kees Cook <keescook@chromium.org> wrote:
>>>>=20
>>>>> On Mon, Feb 13, 2017 at 10:33 AM, Kees Cook <keescook@chromium.org> wr=
ote:
>>>>> On Sat, Feb 11, 2017 at 10:13 PM, Hoeun Ryu <hoeun.ryu@gmail.com> wrot=
e:
>>>>> In the hardend usercopy, the destination buffer will be zeroed if
>>>>> copy_from_user/get_user fails. This patch adds testcases for it.
>>>>> The destination buffer is set with non-zero value before illegal
>>>>> copy_from_user/get_user is executed and the buffer is compared to
>>>>> zero after usercopy is done.
>>>>>=20
>>>>> Signed-off-by: Hoeun Ryu <hoeun.ryu@gmail.com>
>>>>> ---
>>>>> lib/test_user_copy.c | 17 +++++++++++++++++
>>>>> 1 file changed, 17 insertions(+)
>>>>>=20
>>>>> diff --git a/lib/test_user_copy.c b/lib/test_user_copy.c
>>>>> index 0ecef3e..54bd898 100644
>>>>> --- a/lib/test_user_copy.c
>>>>> +++ b/lib/test_user_copy.c
>>>>> @@ -41,11 +41,18 @@ static int __init test_user_copy_init(void)
>>>>>       char *bad_usermem;
>>>>>       unsigned long user_addr;
>>>>>       unsigned long value =3D 0x5A;
>>>>> +       char *zerokmem;
>>>>>=20
>>>>>       kmem =3D kmalloc(PAGE_SIZE * 2, GFP_KERNEL);
>>>>>       if (!kmem)
>>>>>               return -ENOMEM;
>>>>>=20
>>>>> +       zerokmem =3D kzalloc(PAGE_SIZE * 2, GFP_KERNEL);
>>>>> +       if (!zerokmem) {
>>>>> +               kfree(kmem);
>>>>> +               return -ENOMEM;
>>>>> +       }
>>>>> +
>>>>>       user_addr =3D vm_mmap(NULL, 0, PAGE_SIZE * 2,
>>>>>                           PROT_READ | PROT_WRITE | PROT_EXEC,
>>>>>                           MAP_ANONYMOUS | MAP_PRIVATE, 0);
>>>>> @@ -69,25 +76,35 @@ static int __init test_user_copy_init(void)
>>>>>                   "legitimate put_user failed");
>>>>>=20
>>>>>       /* Invalid usage: none of these should succeed. */
>>>>> +       memset(kmem, 0x5A, PAGE_SIZE);
>>>>>       ret |=3D test(!copy_from_user(kmem, (char __user *)(kmem + PAGE_=
SIZE),
>>>>>                                   PAGE_SIZE),
>>>>>                   "illegal all-kernel copy_from_user passed");
>>>>> +       ret |=3D test(memcmp(zerokmem, kmem, PAGE_SIZE),
>>>>> +                   "zeroing failure for illegal all-kernel copy_from_=
user");
>>>>> +       memset(bad_usermem, 0x5A, PAGE_SIZE);
>>>>=20
>>>> Oh, actually, ha-ha: this isn't legal: it's a direct copy from kernel
>>>> to userspace. :) This needs a copy_to_user()... (and same for the
>>>> memcmp...)
>>=20
>> I just came up with that usercopy doesn't check the buffer is valid when z=
eroing happens. I mean if the buffer is wrong address pointing other kernel o=
bjects or user space address, is it possible for zeroing to overwrite the ad=
dress ?
>=20
> The overwrite happening even when the address is "wrong" seems like a
> bug to me, but it's sort of already too late (a bad kernel address
> would have already been a target for a userspace copy), but if
> something has gone really wrong (i.e. attacker doesn't have control
> over the source buffer) this does give a "write 0" primitive.
>=20
> Mark Rutland noticed some order-of-operations issues here too, and his
> solution is pretty straight forward: move the checks outside the
> failure path. If the kernel target is demonstrably bad, then the
> process will be killed before the write 0 happens. (In the non-const
> case at least...)
>=20
> (Oh, btw, I just noticed that x86's copy_from_user() already does the
> check before _copy_from_user() can do the memset, so x86 is already
> "ok" in this regard.)
>=20
>>>>> +       ret |=3D test(memcmp(zerokmem, kmem, sizeof(value)),
>>>>> +                   "zeroing failure for illegal get_user");
>>=20
>> Actually on my x86_64 (qemu), this testcase fails.
>> The generic get_user has zeroing but the one of arch x86 does not.
>> Do we need to propagate zeroing to the other arch specific get_user code ?=

>=20
> Hm, this didn't fail for me on x86 nor arm. Or, at least, my updated
> test doesn't fail:
>=20
>       value =3D 0x5A;
>       ret |=3D test(!get_user(value, (unsigned long __user *)kmem),
>                   "illegal get_user passed");
>       ret |=3D test(value !=3D 0, "zeroing failure for illegal get_user");=

>=20
> I see the zeroing in the x86 uaccess.h, though it's a bit obfuscated:
>=20
> #define get_user(x, ptr)                                                \
> ({                                                                      \
>        int __ret_gu;                                                   \
>        register __inttype(*(ptr)) __val_gu asm("%"_ASM_DX);            \
>        register void *__sp asm(_ASM_SP);                               \
>        __chk_user_ptr(ptr);                                            \
>        might_fault();                                                  \
>        asm volatile("call __get_user_%P4"                              \
>                     : "=3Da" (__ret_gu), "=3Dr" (__val_gu), "+r" (__sp)   =
 \
>                     : "0" (ptr), "i" (sizeof(*(ptr))));                \
>        (x) =3D (__force __typeof__(*(ptr))) __val_gu;                    \=

>        __builtin_expect(__ret_gu, 0);                                  \
> })
>=20
> __ret_gu is the 0 or -EFAULT (from the __get_user_* assembly), and x
> is set unconditionally to __val_gu, which gets zero-set by the same
> assembly.
>=20
> Regardless, I'll expand the tests to check all get_user() sizes...
>=20
> -Kees

Thank you for your detailed explanations.

> --=20
> Kees Cook
> Pixel Security
