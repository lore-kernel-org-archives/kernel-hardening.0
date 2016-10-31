Reply-To: kernel-hardening@lists.openwall.com
From: Florian Weimer <fw@deneb.enyo.de>
References: <1477922641-2221-1-git-send-email-jann@thejh.net>
	<CAGXu5j+Hz=AmmTAh3+QOv1wTG3HA60LPK0Dq6F8uybNQ5e+sHw@mail.gmail.com>
	<20161031162918.GA2994@pc.thejh.net>
	<87mvhks0vs.fsf@mid.deneb.enyo.de> <1477947388.8761.3.camel@gmail.com>
	<1477947674.8761.4.camel@gmail.com> <87ins8rzqm.fsf@mid.deneb.enyo.de>
	<1477948871.8761.9.camel@gmail.com>
Date: Mon, 31 Oct 2016 22:38:00 +0100
In-Reply-To: <1477948871.8761.9.camel@gmail.com> (Daniel Micay's message of
	"Mon, 31 Oct 2016 17:21:11 -0400")
Message-ID: <8760o8ryh3.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] Re: [PATCH] fork: make whole stack_canary random
To: Daniel Micay <danielmicay@gmail.com>
Cc: Jann Horn <jann@thejh.net>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

* Daniel Micay:

> -fstack-stack is supposed to handle a single guard by default, and
> that's all there is for thread stacks by default.

Okay, then I'll really have to look at the probing offsets again.
It's been on my to-do list since about 2012, and arguably, it *is* a
user-space thing.

And I just realized that we should probably fail at dlopen time if
some tries to open a DSO which needs an executable stack, rather than
silently changing all thread stacks to executable. *sigh*

>> > Note: talking about userspace after the entropy bit. The kernel
>> > doesn't
>> > really -fstack-check, at least in even slightly sane code...
>>=A0
>> There used to be lots of discussions about kernel stack sizes ...
>
> It should just be banning VLAs, alloca and large stack frames though, if
> it's not already. There wasn't even support for guard pages with kernel
> stacks until recently outside grsecurity,

Which is not surprising, considering that one prime motivation for
small stacks was to conserve 32-bit address space.  But I'm glad that
there is now a guard page.  Hopefully, it does not affect performance,
and on 64-bit, at least there isn't the address space limit to worry
about.

> and -fstack-check relies on them so it doesn't seem like a great
> solution for the kernel.

-fsplit-stack could enforce stack usage limits even without guard
pages, but of course, there is some run-time overhead, and the limit
has to come from somewhere (typically the TCB).
