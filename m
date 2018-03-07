MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180307234238.yxbbaka35ck2xymw@smitten>
References: <20180307230714.GA20797@beast> <20180307234238.yxbbaka35ck2xymw@smitten>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 7 Mar 2018 15:59:27 -0800
Message-ID: <CAGXu5j+d91dqTEPm13CXDvNzzaj01M-CYLYCqyMN5VjrD5Q4ww@mail.gmail.com>
Subject: Re: [PATCH] vsprintf: Remove accidental VLA usage
Content-Type: text/plain; charset="UTF-8"
To: Tycho Andersen <tycho@tycho.ws>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Tobin C. Harding" <me@tobin.cc>, Jonathan Corbet <corbet@lwn.net>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, "Steven Rostedt (VMware)" <rostedt@goodmis.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 7, 2018 at 3:42 PM, Tycho Andersen <tycho@tycho.ws> wrote:
> Hi Kees,
>
> On Wed, Mar 07, 2018 at 03:07:14PM -0800, Kees Cook wrote:
>> The "sym" calculation is actually a fixed size, but since the max()
>> macro uses some extensive tricks for safety, it ends up looking like a
>> variable size. This replaces max() with a simple max macro which is
>> sufficient for the calculation of the array size.
>>
>> Seen with -Wvla. Fixed as part of the directive to remove all VLAs from
>> the kernel: https://lkml.org/lkml/2018/3/7/621
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  lib/vsprintf.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
>> index d7a708f82559..f420ab1477cb 100644
>> --- a/lib/vsprintf.c
>> +++ b/lib/vsprintf.c
>> @@ -744,8 +744,9 @@ char *resource_string(char *buf, char *end, struct resource *res,
>>  #define FLAG_BUF_SIZE                (2 * sizeof(res->flags))
>>  #define DECODED_BUF_SIZE     sizeof("[mem - 64bit pref window disabled]")
>>  #define RAW_BUF_SIZE         sizeof("[mem - flags 0x]")
>> -     char sym[max(2*RSRC_BUF_SIZE + DECODED_BUF_SIZE,
>> -                  2*RSRC_BUF_SIZE + FLAG_BUF_SIZE + RAW_BUF_SIZE)];
>> +#define SIMPLE_MAX(x, y)     ((x) > (y) ? (x) : (y))
>
> It's probably worth hoisting this out into some other header. When I
> was looking at this a while ago, this problem happens in a few places,
> see e.g. net/ipv4/proc.c:TCPUDP_MIB_MAX.

Hmm, good point. All of those suffer from the same "max*() is too fancy".

I didn't want to encourage a global macro that _lacked_ the safety
built into the max*() family, though... thoughts for a reasonable
approach?

-Kees

-- 
Kees Cook
Pixel Security
