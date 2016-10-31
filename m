Reply-To: kernel-hardening@lists.openwall.com
From: Florian Weimer <fw@deneb.enyo.de>
References: <1477922641-2221-1-git-send-email-jann@thejh.net>
	<CAGXu5j+Hz=AmmTAh3+QOv1wTG3HA60LPK0Dq6F8uybNQ5e+sHw@mail.gmail.com>
	<20161031162918.GA2994@pc.thejh.net>
	<87mvhks0vs.fsf@mid.deneb.enyo.de> <1477947388.8761.3.camel@gmail.com>
	<1477947674.8761.4.camel@gmail.com> <87ins8rzqm.fsf@mid.deneb.enyo.de>
	<1477948871.8761.9.camel@gmail.com> <8760o8ryh3.fsf@mid.deneb.enyo.de>
	<1477951334.8761.15.camel@gmail.com>
Date: Mon, 31 Oct 2016 23:11:47 +0100
In-Reply-To: <1477951334.8761.15.camel@gmail.com> (Daniel Micay's message of
	"Mon, 31 Oct 2016 18:02:14 -0400")
Message-ID: <87funcqicc.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [kernel-hardening] Re: [PATCH] fork: make whole stack_canary random
To: Daniel Micay <danielmicay@gmail.com>
Cc: Jann Horn <jann@thejh.net>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

* Daniel Micay:

> On Mon, 2016-10-31 at 22:38 +0100, Florian Weimer wrote:
>> * Daniel Micay:
>> 
>> > -fstack-stack is supposed to handle a single guard by default, and
>> > that's all there is for thread stacks by default.
>> 
>> Okay, then I'll really have to look at the probing offsets again.
>> It's been on my to-do list since about 2012, and arguably, it *is* a
>> user-space thing.
>
> This is concerning too:
>
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=66479

Thanks.  This also shows the large stack pointer decrement:

	subq	$4144, %rsp
	orq	$0, (%rsp)

I really don't see how this can be safe with just a single guard page.

> It might be prevented for VLAs by using -fsanitize=vla-bound -fsanitize-
> trap=vla-bound but probably not alloca (or the older -fsanitize-
> undefined-trap-on-error for GCC,  since for some reason it doesn't seem
> to have the new way).

It's certainly reasonable to expect that this was covered by
-fstack-check.
