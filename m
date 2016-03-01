Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAGXu5j+x04TOhN42rv+pmR9B=Z63mBrYVH2rA=3GXq-XaD=B+g@mail.gmail.com>
References: <1455837862-24189-1-git-send-email-linux@rasmusvillemoes.dk>
	<CAGXu5j+x04TOhN42rv+pmR9B=Z63mBrYVH2rA=3GXq-XaD=B+g@mail.gmail.com>
Date: Tue, 1 Mar 2016 13:54:50 -0800
Message-ID: <CAGXu5j+_mPypESS8EXFzHnZxcFX2OkGbxrHT2KN-FM_8TpAr9g@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC 0/2] format_template attribute
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 22, 2016 at 11:31 AM, Kees Cook <keescook@chromium.org> wrote:
> On Thu, Feb 18, 2016 at 3:24 PM, Rasmus Villemoes
> <linux@rasmusvillemoes.dk> wrote:
>> I've been sitting on this for a while and would like to get some
>> comments; apologies if this is inappropriate for this list. It's also
>> a lot of code for not finding any bugs in the current kernel, but I
>> guess that's good thing. It's on top of Emese's v2 infrastructure. It
>> probably won't build with all gccs; it works for me with gcc 4.9.
>
> Awesome! The existing checks in gcc are far from sufficient. :)

FWIW, it's possible to test these in my gcc-plugins tree now. If I add
a bogus format string, I get failures, as expected:

kernel/watchdog.c:692:1: error: specifier 1 in 'watchdog/%d' ('%d')
incompatible with format template 'foobar/%u'
 };

It'd be nice if gcc's "error" included the gcc plugin. Maybe we should
add something like this to gcc-common.h:

#define plug_error(fmt, args...) error("%s plugin: " fmt, __FILE__, args)

-Kees

>
>>
>> Rasmus Villemoes (2):
>>   plugins: implement format_template attribute
>>   compiler.h: add __format_template
>>
>>  arch/Kconfig                        |  18 ++
>>  drivers/hwmon/applesmc.c            |   2 +-
>>  drivers/staging/speakup/spk_types.h |   2 +-
>>  include/linux/compiler.h            |   7 +
>>  include/linux/smpboot.h             |   2 +-
>>  include/linux/usb.h                 |   2 +-
>>  scripts/Makefile.gcc-plugins        |   4 +
>>  tools/gcc/Makefile                  |   2 +
>>  tools/gcc/format_template.c         | 331 ++++++++++++++++++++++++++++++++++++
>>  9 files changed, 366 insertions(+), 4 deletions(-)
>>  create mode 100644 tools/gcc/format_template.c
>>
>> --
>> 2.1.4
>>
>
> I wonder if we need something in Documention to explain this, along
> with our existing __printf markings?
>
> -Kees
>
> --
> Kees Cook
> Chrome OS & Brillo Security



-- 
Kees Cook
Chrome OS & Brillo Security
