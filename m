Reply-To: kernel-hardening@lists.openwall.com
From: Florian Weimer <fw@deneb.enyo.de>
References: <1477922641-2221-1-git-send-email-jann@thejh.net>
	<CAGXu5j+Hz=AmmTAh3+QOv1wTG3HA60LPK0Dq6F8uybNQ5e+sHw@mail.gmail.com>
	<20161031162918.GA2994@pc.thejh.net>
	<87mvhks0vs.fsf@mid.deneb.enyo.de> <1477947388.8761.3.camel@gmail.com>
	<1477947674.8761.4.camel@gmail.com> <87ins8rzqm.fsf@mid.deneb.enyo.de>
	<20161031212251.GB3286@pc.thejh.net>
Date: Mon, 31 Oct 2016 22:26:26 +0100
In-Reply-To: <20161031212251.GB3286@pc.thejh.net> (Jann Horn's message of
	"Mon, 31 Oct 2016 22:22:51 +0100")
Message-ID: <877f8orz0d.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [kernel-hardening] Re: [PATCH] fork: make whole stack_canary random
To: Jann Horn <jann@thejh.net>
Cc: Daniel Micay <danielmicay@gmail.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

* Jann Horn:

> Until recently: Zero, no guard pages below stacks, stack overflow
> goes straight into some other allocation.
> Now: One guard page, thanks to a lot of work by Andy Lutomirski.
> (I think that change is in the current 4.9-rc3 kernel, but not in
> any stable kernel yet.)

Sorry, I meant for the stack allocation in user space.

(I'm very much a user space person only.)
