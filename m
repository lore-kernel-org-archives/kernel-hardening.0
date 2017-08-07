References: <a5e688c4-94b8-b0aa-4425-fc687d3aeeca@redhat.com>
 <CAGXu5jLre9QdOWi+-GxcGi=rxp=Emwnaz=MBxDtdd_ZD=VRc2w@mail.gmail.com>
 <87ino04hz5.fsf@rasmusvillemoes.dk>
From: Vaishali Thakkar <vaishali.thakkar@oracle.com>
Message-ID: <867e7dfd-ce67-a8ea-60b8-897b45a6adbc@oracle.com>
Date: Tue, 8 Aug 2017 03:36:23 +0530
MIME-Version: 1.0
In-Reply-To: <87ino04hz5.fsf@rasmusvillemoes.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: Format string gcc-plugin?
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Friday 24 February 2017 04:45 AM, Rasmus Villemoes wrote:
> On Tue, Feb 14 2017, Kees Cook <keescook@chromium.org> wrote:
> 
>> On Tue, Feb 14, 2017 at 10:01 AM, Laura Abbott <labbott@redhat.com> wrote:
>>> Hi,
>>>
>>> The recent discussions about %pk led me to start playing around
>>> with writing a gcc plugin (notes about writing a gcc plugin are
>>> forthcoming). My idea was to expand checking of the kernel's additional
>>> formats (%pK, %pR etc.) or possibly even change the format
>>> strings. The big issue is that most of vsprintf.c would end up
>>> in the plugin which would be ugly to maintain. This concept could
>>> be used for some of the problems with kernel pointer leaks
>>> https://kernsec.org/wiki/index.php/Bug_Classes/Kernel_pointer_leak
>>> but I'm interested if anyone else has thoughts or ideas about
>>> how better to do this (or even not to do this).
>>
>> If we can leverage common code between the plugin and vsprintf.c, it
>> should be doable. I haven't looked at processing format strings at
>> all, though I assume the plugin would need to check the
>> __printf-generated attributes.
>>
> 
> smatch already does type checking of the kernel's %p extensions, plus
> some additional sanity checks (e.g. passing a signed char to %02x,
> duplicate KERN_* or KERN_* prefixes not at the beginning, 0x%d,
> etc.). Maybe Dan Carpenter is the only one actually running it
> periodically. I never managed to get sparse to grok the printf
> attribute, so it uses a hardcoded list of printf-like functions. It
> would be nice to do these checks in a gcc plugin to get wider coverage
> and piggyback on the actual printf attributes, and it would probably be
> easier to keep up with the endless stream of new %pX stuff that way.

Hi all,

I was recently looking at gcc's -Wformat-security and realized that 
there is a TODO point on KSPP's wiki page regarding fixing it for const
strings.

I was wondering that may be we can also try Coccinelle for the type 
checking of %pX extensions? Is there any work done or is someone working 
on this after this discussion?

I'm not sure what is a preferable way over here [GCC plugin or 
Coccinelle scripts] but if noone is working on this then I would like to 
give it a try. Any comments on the same are welcome.

Thanks!

> Rasmus
> 
