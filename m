Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
From: Hoeun Ryu <hoeun.ryu@gmail.com>
In-Reply-To: <CAGXu5jLfpq=vn0V_41NbLPyxkPQzGVwvo33tnErkmtcx8TOf4g@mail.gmail.com>
Date: Tue, 14 Feb 2017 10:44:22 +0900
Content-Transfer-Encoding: quoted-printable
Message-Id: <2C0135CD-ACCF-462F-B7C6-E8554C6C99BF@gmail.com>
References: <1486880019-8201-1-git-send-email-hoeun.ryu@gmail.com> <CAGXu5j+ogVnxxu1VuUep6ObAdyJbvxMyN25J+PF+exOJqk2VVg@mail.gmail.com> <CAGXu5jLfpq=vn0V_41NbLPyxkPQzGVwvo33tnErkmtcx8TOf4g@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH] usercopy: add testcases to check zeroing on failure of usercopy
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>



> On Feb 14, 2017, at 4:24 AM, Kees Cook <keescook@chromium.org> wrote:
>=20
>> On Mon, Feb 13, 2017 at 10:33 AM, Kees Cook <keescook@chromium.org> wrote=
:
>>> On Sat, Feb 11, 2017 at 10:13 PM, Hoeun Ryu <hoeun.ryu@gmail.com> wrote:=

>>> In the hardend usercopy, the destination buffer will be zeroed if
>>> copy_from_user/get_user fails. This patch adds testcases for it.
>>> The destination buffer is set with non-zero value before illegal
>>> copy_from_user/get_user is executed and the buffer is compared to
>>> zero after usercopy is done.
>>>=20
>>> Signed-off-by: Hoeun Ryu <hoeun.ryu@gmail.com>
>>> ---
>>> lib/test_user_copy.c | 17 +++++++++++++++++
>>> 1 file changed, 17 insertions(+)
>>>=20
>>> diff --git a/lib/test_user_copy.c b/lib/test_user_copy.c
>>> index 0ecef3e..54bd898 100644
>>> --- a/lib/test_user_copy.c
>>> +++ b/lib/test_user_copy.c
>>> @@ -41,11 +41,18 @@ static int __init test_user_copy_init(void)
>>>        char *bad_usermem;
>>>        unsigned long user_addr;
>>>        unsigned long value =3D 0x5A;
>>> +       char *zerokmem;
>>>=20
>>>        kmem =3D kmalloc(PAGE_SIZE * 2, GFP_KERNEL);
>>>        if (!kmem)
>>>                return -ENOMEM;
>>>=20
>>> +       zerokmem =3D kzalloc(PAGE_SIZE * 2, GFP_KERNEL);
>>> +       if (!zerokmem) {
>>> +               kfree(kmem);
>>> +               return -ENOMEM;
>>> +       }
>>> +
>>>        user_addr =3D vm_mmap(NULL, 0, PAGE_SIZE * 2,
>>>                            PROT_READ | PROT_WRITE | PROT_EXEC,
>>>                            MAP_ANONYMOUS | MAP_PRIVATE, 0);
>>> @@ -69,25 +76,35 @@ static int __init test_user_copy_init(void)
>>>                    "legitimate put_user failed");
>>>=20
>>>        /* Invalid usage: none of these should succeed. */
>>> +       memset(kmem, 0x5A, PAGE_SIZE);
>>>        ret |=3D test(!copy_from_user(kmem, (char __user *)(kmem + PAGE_S=
IZE),
>>>                                    PAGE_SIZE),
>>>                    "illegal all-kernel copy_from_user passed");
>>> +       ret |=3D test(memcmp(zerokmem, kmem, PAGE_SIZE),
>>> +                   "zeroing failure for illegal all-kernel copy_from_us=
er");
>>> +       memset(bad_usermem, 0x5A, PAGE_SIZE);
>>=20
>> Oh, actually, ha-ha: this isn't legal: it's a direct copy from kernel
>> to userspace. :) This needs a copy_to_user()... (and same for the
>> memcmp...)

I just came up with that usercopy doesn't check the buffer is valid when zer=
oing happens. I mean if the buffer is wrong address pointing other kernel ob=
jects or user space address, is it possible for zeroing to overwrite the add=
ress ?

>>=20
>>>        ret |=3D test(!copy_from_user(bad_usermem, (char __user *)kmem,
>>>                                    PAGE_SIZE),
>>>                    "illegal reversed copy_from_user passed");
>>> +       ret |=3D test(memcmp(zerokmem, bad_usermem, PAGE_SIZE),
>>> +                   "zeroing failure for illegal reversed copy_from_user=
");
>>>        ret |=3D test(!copy_to_user((char __user *)kmem, kmem + PAGE_SIZE=
,
>>>                                  PAGE_SIZE),
>>>                    "illegal all-kernel copy_to_user passed");
>>>        ret |=3D test(!copy_to_user((char __user *)kmem, bad_usermem,
>>>                                  PAGE_SIZE),
>>>                    "illegal reversed copy_to_user passed");
>>> +       memset(kmem, 0x5A, PAGE_SIZE);
>>>        ret |=3D test(!get_user(value, (unsigned long __user *)kmem),
>>>                    "illegal get_user passed");
>>> +       ret |=3D test(memcmp(zerokmem, kmem, sizeof(value)),
>>> +                   "zeroing failure for illegal get_user");

Actually on my x86_64 (qemu), this testcase fails.
The generic get_user has zeroing but the one of arch x86 does not.
Do we need to propagate zeroing to the other arch specific get_user code ?

>>>        ret |=3D test(!put_user(value, (unsigned long __user *)kmem),
>>>                    "illegal put_user passed");
>>>=20
>>>        vm_munmap(user_addr, PAGE_SIZE * 2);
>>>        kfree(kmem);
>>> +       kfree(zerokmem);
>>>=20
>>>        if (ret =3D=3D 0) {
>>>                pr_info("tests passed.\n");
>>> --
>>> 2.7.4
>>>=20
>>=20
>> Can you respin this?
>=20
> On second thought, don't worry about a respin, I had to adjust the bad
> copy_from_user() that was already in there (which fails under SMAP/PAN
> anyway). I'll clean this up and add it to the tree.
>=20
> Thanks!
>=20
> -Kees
>=20
> --=20
> Kees Cook
> Pixel Security
