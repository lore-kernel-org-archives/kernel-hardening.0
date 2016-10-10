Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1476115319.2329.108.camel@cvidal.org>
References: <1476016472.2329.38.camel@cvidal.org> <CE954033-54F3-47AE-9788-B26B9CE45401@gmail.com>
 <1476040182.2329.72.camel@cvidal.org> <20161009193731.GD14666@pc.thejh.net>
 <2236FBA76BA1254E88B949DDB74E612B41BDCAF6@IRSMSX102.ger.corp.intel.com> <1476115319.2329.108.camel@cvidal.org>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 10 Oct 2016 14:05:19 -0700
Message-ID: <CAGXu5jLvBMWHw_Y8ntmKB3GFqWfmT_E1neUiVQLJAsErLxFLWw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] self introduction
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Oct 10, 2016 at 9:01 AM, Colin Vidal <colin@cvidal.org> wrote:
>> This branch to be precise:
>> https://github.com/ereshetova/linux-stable/tree/hardened_atomic_on_next
>>
>> This is where the latest code for linux-next is hosted now and where
>> we work with David and Hans.
>> >
>> > >
>> > > Please contact me if you have any questions; I'd be glad to help!
>> >
>> > I actually have question. :-) As far as I understand, PAX_REFCOUNT
>> > [1] is mainly a x86-only
>>
>> >
>> > No, PAX_REFCOUNT also supports a bunch of other architectures. As
>> > far as I can tell from a quick look: ARM, MIPS, PowerPC and SPARC.
>>
>> Yes, just in our patch series we only made implementation for x86.
>> But if you look into Grsecurity/PaX patches, it has support for
>> others implemented.
>
> OK, got it! Thanks for this clarification.
>
> So, I will try to start to port PAX_REFCOUNT arm-specific features to
> hardened_atomic_on_next, and keep you in touch. Is there a deadline?
> (4.10 / 5.0 merge window?)

You may want to compare notes with Takahiro (CCed) who may have
started to look at arm64 (and maybe arm too).

As for a deadline, as Elena says, we have no specific target. ("As
soon as possible.") The only thing around timing that I like to see is
persistent progress: if a patch series goes up for review, getting
people to take a look at it, ask questions, make comments, and then
hopefully within a week or so, the next version comes up. Momentum is
easier to maintain than to build. ;)

> Just to be sure, the patch [1] and documentation [2] of PaX are still
> up-to-date, or there is another references I missed?
>
> Thanks
>
> Colin
>
> [1] https://pax.grsecurity.net/pax-linux-3.6-201210022100.patch

This is a quite old version of PaX. (Note the date.) If you want to
examine PaX separately from Grsecurity (noting differences can be
enlightening), check here:

https://www.grsecurity.net/~paxguy1/?C=M;O=D

> [2] https://forums.grsecurity.net/viewtopic.php?f=7&t=4173

Yes, outside of reading the code itself, I believe this to be the most
comprehensive piece of documentation about PAX_REFCOUNT.

-Kees

-- 
Kees Cook
Nexus Security
