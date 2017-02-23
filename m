From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
References: <a5e688c4-94b8-b0aa-4425-fc687d3aeeca@redhat.com>
	<CAGXu5jLre9QdOWi+-GxcGi=rxp=Emwnaz=MBxDtdd_ZD=VRc2w@mail.gmail.com>
Date: Fri, 24 Feb 2017 00:15:10 +0100
In-Reply-To: <CAGXu5jLre9QdOWi+-GxcGi=rxp=Emwnaz=MBxDtdd_ZD=VRc2w@mail.gmail.com>
	(Kees Cook's message of "Tue, 14 Feb 2017 11:07:39 -0800")
Message-ID: <87ino04hz5.fsf@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: Format string gcc-plugin?
To: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 14 2017, Kees Cook <keescook@chromium.org> wrote:

> On Tue, Feb 14, 2017 at 10:01 AM, Laura Abbott <labbott@redhat.com> wrote:
>> Hi,
>>
>> The recent discussions about %pk led me to start playing around
>> with writing a gcc plugin (notes about writing a gcc plugin are
>> forthcoming). My idea was to expand checking of the kernel's additional
>> formats (%pK, %pR etc.) or possibly even change the format
>> strings. The big issue is that most of vsprintf.c would end up
>> in the plugin which would be ugly to maintain. This concept could
>> be used for some of the problems with kernel pointer leaks
>> https://kernsec.org/wiki/index.php/Bug_Classes/Kernel_pointer_leak
>> but I'm interested if anyone else has thoughts or ideas about
>> how better to do this (or even not to do this).
>
> If we can leverage common code between the plugin and vsprintf.c, it
> should be doable. I haven't looked at processing format strings at
> all, though I assume the plugin would need to check the
> __printf-generated attributes.
>

smatch already does type checking of the kernel's %p extensions, plus
some additional sanity checks (e.g. passing a signed char to %02x,
duplicate KERN_* or KERN_* prefixes not at the beginning, 0x%d,
etc.). Maybe Dan Carpenter is the only one actually running it
periodically. I never managed to get sparse to grok the printf
attribute, so it uses a hardcoded list of printf-like functions. It
would be nice to do these checks in a gcc plugin to get wider coverage
and piggyback on the actual printf attributes, and it would probably be
easier to keep up with the endless stream of new %pX stuff that way.

Rasmus
