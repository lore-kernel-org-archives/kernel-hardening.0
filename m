MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <878tp3j12z.fsf@concordia.ellerman.id.au>
References: <20170214204039.GA125586@beast> <CAMuHMdWEH0OiBOJJrJLr27sZHo20sa2Qz5Acq9SZWBGav2FXdw@mail.gmail.com>
 <CAGXu5j+MtxHxiPbSG3+6Tuw3EkBPixO73GYn692Nfoi1AwPWZw@mail.gmail.com> <878tp3j12z.fsf@concordia.ellerman.id.au>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 21 Feb 2017 11:09:19 -0800
Message-ID: <CAGXu5jL0bMoYdQ7FwqZG_gheMXiVqjStY3RfJ_=rY-xGTNWgFA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH] usercopy: Add tests for all
 get_user() sizes
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Feb 18, 2017 at 1:32 AM, Michael Ellerman <mpe@ellerman.id.au> wrote:
> Kees Cook <keescook@chromium.org> writes:
>
>> On Wed, Feb 15, 2017 at 12:50 AM, Geert Uytterhoeven
>> <geert@linux-m68k.org> wrote:
>>> On Tue, Feb 14, 2017 at 9:40 PM, Kees Cook <keescook@chromium.org> wrote:
>>>> The existing test was only exercising native unsigned long size
>>>> get_user(). For completeness, we should check all sizes.
>>>>
>>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>>> ---
>>>>  lib/test_user_copy.c | 45 ++++++++++++++++++++++++++++++++++-----------
>>>>  1 file changed, 34 insertions(+), 11 deletions(-)
>>>>
>>>> diff --git a/lib/test_user_copy.c b/lib/test_user_copy.c
>>>> index ac3a60ba9331..49569125b7c5 100644
>>>> --- a/lib/test_user_copy.c
>>>> +++ b/lib/test_user_copy.c
>>>> @@ -40,8 +40,11 @@ static int __init test_user_copy_init(void)
>>>>         char __user *usermem;
>>>>         char *bad_usermem;
>>>>         unsigned long user_addr;
>>>> -       unsigned long value = 0x5A;
>>>>         char *zerokmem;
>>>> +       u8 val_u8;
>>>> +       u16 val_u16;
>>>> +       u32 val_u32;
>>>> +       u64 val_u64;
>>>>
>>>>         kmem = kmalloc(PAGE_SIZE * 2, GFP_KERNEL);
>>>>         if (!kmem)
>>>> @@ -72,10 +75,20 @@ static int __init test_user_copy_init(void)
>>>>                     "legitimate copy_from_user failed");
>>>>         ret |= test(copy_to_user(usermem, kmem, PAGE_SIZE),
>>>>                     "legitimate copy_to_user failed");
>>>> -       ret |= test(get_user(value, (unsigned long __user *)usermem),
>>>> -                   "legitimate get_user failed");
>>>> -       ret |= test(put_user(value, (unsigned long __user *)usermem),
>>>> -                   "legitimate put_user failed");
>>>> +
>>>> +#define test_legit(size)                                                 \
>>>> +       do {                                                              \
>>>> +               ret |= test(get_user(val_##size, (size __user *)usermem), \
>>>> +                   "legitimate get_user (" #size ") failed");            \
>>>> +               ret |= test(put_user(val_##size, (size __user *)usermem), \
>>>> +                   "legitimate put_user (" #size ") failed");            \
>>>> +       } while (0)
>>>> +
>>>> +       test_legit(u8);
>>>> +       test_legit(u16);
>>>> +       test_legit(u32);
>>>> +       test_legit(u64);
>>>> +#undef test_legit
>>>
>>> ERROR: "__get_user_bad" [lib/test_user_copy.ko] undefined!
>>>
>>> http://kisskb.ellerman.id.au/kisskb/buildresult/12936728/
>>>
>>> So 64-bit get_user() support is mandatory now?
>>
>> That's not my intention. :) In my sampling of architectures, I missed
>> a couple 32-bit archs that don't support 64-bit getuser(). I'm not
>> sure how to correctly write these tests, though, since it seems rather
>> ad-hoc. e.g. m68k has 64-bit getuser() commented out due to an old gcc
>> bug...
>>
>> Should I just universally skip 64-bit getuser on 32-bit archs?
>
> I think you should just make it opt-in for 32-bit arches.

I did this opt-out instead and manually inspected all the
architectures that should skip the test. (That way future 32-bit
architectures will get noticed if they don't support 64-bit
get_user().)

-Kees

-- 
Kees Cook
Pixel Security
