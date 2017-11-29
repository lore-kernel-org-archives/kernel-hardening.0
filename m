MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAGXu5j+Tv4KHytjOtBvG9e53o-pG7h5DjZZkATXbado-HAbKHw@mail.gmail.com>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
 <1511803118-2552-6-git-send-email-tixxdz@gmail.com> <CA+55aFxfO1i1LS9dPTTCf50ovWPXcq6BE9mKiq_FxWSm4iE8Mg@mail.gmail.com>
 <CAEiveUcvKbuJMB5801jdRosxYn+CZ4E=pfvXNrhuOrXXbw4ZBQ@mail.gmail.com>
 <CA+55aFzx2eM+wVrjQEfkE-G8E9OVLcdo6vk0fDMwZNu2sh1oCQ@mail.gmail.com>
 <1100603534.56586.1511871419952@ichabod.co-bxl> <20171128193243.4fymnjk7fplqw62x@thunk.org>
 <CAGXu5jLtBjLSe5mbe5sYSao1o67ezkkQq_u3md9646rRfi3cCQ@mail.gmail.com>
 <CA+55aFzvaFR1skBFKwT1QPnKqxaLqCuq33FCuYz8DP7MjKkgNg@mail.gmail.com>
 <CAGXu5j+OzbUAcqVBuC8QoY-ZiA9Xw6Uf9kzfzpx9MQHQ1LtxVQ@mail.gmail.com>
 <CA+55aFz0t7cCkePJQ1w44Kw_g5nns1tYJLUOL7f-c7vriqkFig@mail.gmail.com>
 <708003731.69563.1511905898471@ichabod.co-bxl> <CA+55aFzxFQeyk6Mrk50=jzevHpZ78BXz_9nHcHabMWBdM6RC6A@mail.gmail.com>
 <CA+55aFyybavkF8ccQKJsoVAF+MG=J5=e9PxXKU=J_hqCQRZnug@mail.gmail.com>
 <CAGXu5jLU8LqTYM9SYQADeH9wm2npVu4AEuSqvYqi3S+qtjC-Qw@mail.gmail.com>
 <CA+55aFwDfBnMVGfBVkrFFr26tp1y8CUpSf154AuXH+sWyeY5FA@mail.gmail.com> <CAGXu5j+Tv4KHytjOtBvG9e53o-pG7h5DjZZkATXbado-HAbKHw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 29 Nov 2017 10:46:38 -0800
Message-ID: <CA+55aFxiDKfe6VCM+aV2OgnkzMpP+iz+rn2k25_Qa_QLex=pPQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use
 request_module_cap() to load 'netdev-%s' modules
To: Kees Cook <keescook@chromium.org>
Cc: Geo Kozey <geokozey@mailfence.com>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 29, 2017 at 10:30 AM, Kees Cook <keescook@chromium.org> wrote:
> On Tue, Nov 28, 2017 at 4:50 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Just thinking about the DCCP case, where networking people actually
>> knew it was pretty deprecated and had no real maintainer, I think one
>> thing to look at would be simply a per-module flag.
>>   [ ... ]
>> Does that sound reasonable?
>
> Yeah, I think I see the way forward here; thanks for the discussion!

Note: I don't want to really force that per-module flag if it ends up
being painful, I was really just thinking that considering the DCCP
case, it would be (I think) a really nice solution.

In particular, request_module() ends up having that indirection
through usermode-helper, which makes it potentially very inconvenient
to store the "did the original caller have proper capabilities" and
then check it at actual module load time.

So the module flag is technically easy to add, and it's technically
easy to read at module loading time, but I suspect that it's actually
annoyingly hard to pass the original request_module() capability
information around to where we actually read the module.

That's why it might be _much_ easier to try to do it per call-site
instead. It's not quite as fine-grained (because several call-sites do
things like

        request_module("net-pf-%d-proto-%d", PF_NETLINK, protocol);

that can load a large number of different modules), but if we can get
away with just saying "this particular callsite is ok, because it only
loads the bluetooth module that we thing is trustworthy" or "this
call-site is ok, because you already had to have access to the device
node", that is going to be much simpler and more straightforward.

In other words: I think there are at least two different models to go
after, and there may be practical reasons to prefer one over the
other.

                    Linus
