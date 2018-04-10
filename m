Date: Tue, 10 Apr 2018 10:35:38 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v3 3/3] x86: usercopy: reimplement
 arch_within_stack_frames with unwinder
Message-ID: <20180410153500.shqpjemlsfp63yu5@treble>
References: <1523275156-29087-1-git-send-email-kpark3469@gmail.com>
 <1523275156-29087-2-git-send-email-kpark3469@gmail.com>
 <1523275156-29087-3-git-send-email-kpark3469@gmail.com>
 <1523275156-29087-4-git-send-email-kpark3469@gmail.com>
 <a59b818d84b74c13a4f25f757eba1f93@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a59b818d84b74c13a4f25f757eba1f93@AcuMS.aculab.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: "'kpark3469@gmail.com'" <kpark3469@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "keescook@chromium.org" <keescook@chromium.org>, "will.deacon@arm.com" <will.deacon@arm.com>, "mark.rutland@arm.com" <mark.rutland@arm.com>, "james.morse@arm.com" <james.morse@arm.com>, "keun-o.park@darkmatter.ae" <keun-o.park@darkmatter.ae>, "psodagud@codeaurora.org" <psodagud@codeaurora.org>, "mingo@kernel.org" <mingo@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 09, 2018 at 01:14:58PM +0000, David Laight wrote:
> From: kpark3469@gmail.com
> > Sent: 09 April 2018 12:59
> >
> > The old arch_within_stack_frames which used the frame pointer is
> > now reimplemented to use frame pointer unwinder apis. So the main
> > functionality is same as before.
> 
> How much slower does this make the code?
> Following stack frames using %bp is reasonably quick.
> I can't imagine some of the other unwinder APIs being any where
> near that fast.
> While fine for fault tracebacks, using them during usercopy
> is likely to have measurable performance impact.

Agreed, using the unwind interface is going to be quite a bit slower
than the current manual approach.  So this patch has only drawbacks and
no benefits.

The only benefit would be if you used the unwind API in a generic
manner, such that it also worked for the ORC unwinder.  But even then I
think we'd need to see performance numbers, with both FP and ORC, to see
how bad the impact is on usercopy.

-- 
Josh
