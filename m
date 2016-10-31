Reply-To: kernel-hardening@lists.openwall.com
From: Florian Weimer <fw@deneb.enyo.de>
References: <1477922641-2221-1-git-send-email-jann@thejh.net>
	<CAGXu5j+Hz=AmmTAh3+QOv1wTG3HA60LPK0Dq6F8uybNQ5e+sHw@mail.gmail.com>
	<20161031162918.GA2994@pc.thejh.net>
Date: Mon, 31 Oct 2016 21:45:59 +0100
In-Reply-To: <20161031162918.GA2994@pc.thejh.net> (Jann Horn's message of
	"Mon, 31 Oct 2016 17:29:18 +0100")
Message-ID: <87mvhks0vs.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [kernel-hardening] Re: [PATCH] fork: make whole stack_canary random
To: Jann Horn <jann@thejh.net>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Daniel Micay <danielmicay@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

* Jann Horn:

> On Mon, Oct 31, 2016 at 09:04:02AM -0700, Kees Cook wrote:
>> On Mon, Oct 31, 2016 at 7:04 AM, Jann Horn <jann@thejh.net> wrote:
>> > On machines with sizeof(unsigned long)==8, this ensures that the more
>> > significant 32 bits of stack_canary are random, too.
>> > stack_canary is defined as unsigned long, all the architectures with stack
>> > protector support already pick the stack_canary of init as a random
>> > unsigned long, and get_random_long() should be as fast as get_random_int(),
>> > so there seems to be no good reason against this.
>> >
>> > This should help if someone tries to guess a stack canary with brute force.
>> >
>> > (This change has been made in PaX already, with a different RNG.)
>> >
>> > Signed-off-by: Jann Horn <jann@thejh.net>
>> 
>> Acked-by: Kees Cook <keescook@chromium.org>
>> 
>> (A separate change might be to make sure that the leading byte is
>> zeroed. Entropy of the value, I think, is less important than blocking
>> canary exposures from unbounded str* functions. Brute forcing kernel
>> stack canaries isn't like it bruting them in userspace...)
>
> Yeah, makes sense. Especially on 64bit, 56 bits of entropy ought to be
> enough anyway.

So you two approve of the way glibc does this currently?  (See the
other thread.)

I was under the impression that the kernel performs far less
null-terminated string processing the average user space application,
especially on the stack.  (A lot of userspace code assumes large
stacks and puts essentially arbitrarily long strings into VLAs.)
