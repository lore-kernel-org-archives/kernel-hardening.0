MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAGXu5j+ogVnxxu1VuUep6ObAdyJbvxMyN25J+PF+exOJqk2VVg@mail.gmail.com>
References: <1486880019-8201-1-git-send-email-hoeun.ryu@gmail.com> <CAGXu5j+ogVnxxu1VuUep6ObAdyJbvxMyN25J+PF+exOJqk2VVg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 13 Feb 2017 11:24:25 -0800
Message-ID: <CAGXu5jLfpq=vn0V_41NbLPyxkPQzGVwvo33tnErkmtcx8TOf4g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] usercopy: add testcases to check zeroing on failure of usercopy
To: Hoeun Ryu <hoeun.ryu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 13, 2017 at 10:33 AM, Kees Cook <keescook@chromium.org> wrote:
> On Sat, Feb 11, 2017 at 10:13 PM, Hoeun Ryu <hoeun.ryu@gmail.com> wrote:
>> In the hardend usercopy, the destination buffer will be zeroed if
>> copy_from_user/get_user fails. This patch adds testcases for it.
>> The destination buffer is set with non-zero value before illegal
>> copy_from_user/get_user is executed and the buffer is compared to
>> zero after usercopy is done.
>>
>> Signed-off-by: Hoeun Ryu <hoeun.ryu@gmail.com>
>> ---
>>  lib/test_user_copy.c | 17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>
>> diff --git a/lib/test_user_copy.c b/lib/test_user_copy.c
>> index 0ecef3e..54bd898 100644
>> --- a/lib/test_user_copy.c
>> +++ b/lib/test_user_copy.c
>> @@ -41,11 +41,18 @@ static int __init test_user_copy_init(void)
>>         char *bad_usermem;
>>         unsigned long user_addr;
>>         unsigned long value = 0x5A;
>> +       char *zerokmem;
>>
>>         kmem = kmalloc(PAGE_SIZE * 2, GFP_KERNEL);
>>         if (!kmem)
>>                 return -ENOMEM;
>>
>> +       zerokmem = kzalloc(PAGE_SIZE * 2, GFP_KERNEL);
>> +       if (!zerokmem) {
>> +               kfree(kmem);
>> +               return -ENOMEM;
>> +       }
>> +
>>         user_addr = vm_mmap(NULL, 0, PAGE_SIZE * 2,
>>                             PROT_READ | PROT_WRITE | PROT_EXEC,
>>                             MAP_ANONYMOUS | MAP_PRIVATE, 0);
>> @@ -69,25 +76,35 @@ static int __init test_user_copy_init(void)
>>                     "legitimate put_user failed");
>>
>>         /* Invalid usage: none of these should succeed. */
>> +       memset(kmem, 0x5A, PAGE_SIZE);
>>         ret |= test(!copy_from_user(kmem, (char __user *)(kmem + PAGE_SIZE),
>>                                     PAGE_SIZE),
>>                     "illegal all-kernel copy_from_user passed");
>> +       ret |= test(memcmp(zerokmem, kmem, PAGE_SIZE),
>> +                   "zeroing failure for illegal all-kernel copy_from_user");
>> +       memset(bad_usermem, 0x5A, PAGE_SIZE);
>
> Oh, actually, ha-ha: this isn't legal: it's a direct copy from kernel
> to userspace. :) This needs a copy_to_user()... (and same for the
> memcmp...)
>
>>         ret |= test(!copy_from_user(bad_usermem, (char __user *)kmem,
>>                                     PAGE_SIZE),
>>                     "illegal reversed copy_from_user passed");
>> +       ret |= test(memcmp(zerokmem, bad_usermem, PAGE_SIZE),
>> +                   "zeroing failure for illegal reversed copy_from_user");
>>         ret |= test(!copy_to_user((char __user *)kmem, kmem + PAGE_SIZE,
>>                                   PAGE_SIZE),
>>                     "illegal all-kernel copy_to_user passed");
>>         ret |= test(!copy_to_user((char __user *)kmem, bad_usermem,
>>                                   PAGE_SIZE),
>>                     "illegal reversed copy_to_user passed");
>> +       memset(kmem, 0x5A, PAGE_SIZE);
>>         ret |= test(!get_user(value, (unsigned long __user *)kmem),
>>                     "illegal get_user passed");
>> +       ret |= test(memcmp(zerokmem, kmem, sizeof(value)),
>> +                   "zeroing failure for illegal get_user");
>>         ret |= test(!put_user(value, (unsigned long __user *)kmem),
>>                     "illegal put_user passed");
>>
>>         vm_munmap(user_addr, PAGE_SIZE * 2);
>>         kfree(kmem);
>> +       kfree(zerokmem);
>>
>>         if (ret == 0) {
>>                 pr_info("tests passed.\n");
>> --
>> 2.7.4
>>
>
> Can you respin this?

On second thought, don't worry about a respin, I had to adjust the bad
copy_from_user() that was already in there (which fails under SMAP/PAN
anyway). I'll clean this up and add it to the tree.

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
