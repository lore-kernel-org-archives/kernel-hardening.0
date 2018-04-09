From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH v3 3/3] x86: usercopy: reimplement
 arch_within_stack_frames with unwinder
Date: Mon, 9 Apr 2018 13:14:58 +0000
Message-ID: <a59b818d84b74c13a4f25f757eba1f93@AcuMS.aculab.com>
References: <1523275156-29087-1-git-send-email-kpark3469@gmail.com>
 <1523275156-29087-2-git-send-email-kpark3469@gmail.com>
 <1523275156-29087-3-git-send-email-kpark3469@gmail.com>
 <1523275156-29087-4-git-send-email-kpark3469@gmail.com>
In-Reply-To: <1523275156-29087-4-git-send-email-kpark3469@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "'kpark3469@gmail.com'" <kpark3469@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "keescook@chromium.org" <keescook@chromium.org>, "will.deacon@arm.com" <will.deacon@arm.com>, "mark.rutland@arm.com" <mark.rutland@arm.com>, "james.morse@arm.com" <james.morse@arm.com>, "panand@redhat.com" <panand@redhat.com>, "keun-o.park@darkmatter.ae" <keun-o.park@darkmatter.ae>, "psodagud@codeaurora.org" <psodagud@codeaurora.org>, "jpoimboe@redhat.com" <jpoimboe@redhat.com>, "mingo@kernel.org" <mingo@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: kpark3469@gmail.com
> Sent: 09 April 2018 12:59
>
> The old arch_within_stack_frames which used the frame pointer is
> now reimplemented to use frame pointer unwinder apis. So the main
> functionality is same as before.

How much slower does this make the code?
Following stack frames using %bp is reasonably quick.
I can't imagine some of the other unwinder APIs being any where
near that fast.
While fine for fault tracebacks, using them during usercopy
is likely to have measurable performance impact.

	David
