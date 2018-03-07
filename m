MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180307154019.e39890b5f8aa98cf25532cf1@linux-foundation.org>
References: <20180307230714.GA20797@beast> <20180307154019.e39890b5f8aa98cf25532cf1@linux-foundation.org>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 7 Mar 2018 15:56:50 -0800
Message-ID: <CAGXu5jJofYYFiKEbNsU+g11x38JFsPg30AHJbH3hArAgr3PBVA@mail.gmail.com>
Subject: Re: [PATCH] vsprintf: Remove accidental VLA usage
Content-Type: text/plain; charset="UTF-8"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, Jonathan Corbet <corbet@lwn.net>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, "Steven Rostedt (VMware)" <rostedt@goodmis.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 7, 2018 at 3:40 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 7 Mar 2018 15:07:14 -0800 Kees Cook <keescook@chromium.org> wrote:
>
>> The "sym" calculation is actually a fixed size, but since the max()
>> macro uses some extensive tricks for safety, it ends up looking like a
>> variable size. This replaces max() with a simple max macro which is
>> sufficient for the calculation of the array size.
>>
>> Seen with -Wvla. Fixed as part of the directive to remove all VLAs from
>> the kernel: https://lkml.org/lkml/2018/3/7/621
>>
>> ...
>>
>> --- a/lib/vsprintf.c
>> +++ b/lib/vsprintf.c
>> @@ -744,8 +744,9 @@ char *resource_string(char *buf, char *end, struct resource *res,
>>  #define FLAG_BUF_SIZE                (2 * sizeof(res->flags))
>>  #define DECODED_BUF_SIZE     sizeof("[mem - 64bit pref window disabled]")
>>  #define RAW_BUF_SIZE         sizeof("[mem - flags 0x]")
>> -     char sym[max(2*RSRC_BUF_SIZE + DECODED_BUF_SIZE,
>> -                  2*RSRC_BUF_SIZE + FLAG_BUF_SIZE + RAW_BUF_SIZE)];
>> +#define SIMPLE_MAX(x, y)     ((x) > (y) ? (x) : (y))
>> +     char sym[SIMPLE_MAX(2*RSRC_BUF_SIZE + DECODED_BUF_SIZE,
>> +                         2*RSRC_BUF_SIZE + FLAG_BUF_SIZE + RAW_BUF_SIZE)];
>>
>>       char *p = sym, *pend = sym + sizeof(sym);
>>       int decode = (fmt[0] == 'R') ? 1 : 0;
>
> A year from now I'll be receiving an email titled
>
>         [patch] lib/vsprintf.c: use standard max() macro
>
> won't I?

Hopefully a year from now we'll have added -Wvla to the global build
flags and no one will be able to try that. :)

-Kees

-- 
Kees Cook
Pixel Security
