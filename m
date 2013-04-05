Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Fri, 5 Apr 2013 09:55:32 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20130405075532.GF26889@gmail.com>
References: <1365106055-22939-1-git-send-email-keescook@chromium.org>
 <1365106055-22939-4-git-send-email-keescook@chromium.org>
 <515DDEC0.9000109@zytor.com>
 <CAGXu5j+FqZpXURougB_Sd4zmF3bsqsT=m-om5eEM5WCsRX014g@mail.gmail.com>
 <c3d1db06-5196-4828-b0a4-7f6517c7b68a@email.android.com>
 <CAG7+5M0SDj0r+HfrZp99FvmDa+LJMJmyDv2Eju5LSfe2TsCXbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG7+5M0SDj0r+HfrZp99FvmDa+LJMJmyDv2Eju5LSfe2TsCXbg@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH 3/3] x86: kernel base offset ASLR
To: Eric Northup <digitaleric@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>


* Eric Northup <digitaleric@google.com> wrote:

> On Thu, Apr 4, 2013 at 1:58 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > It seems to me that you are assuming that the attacker is targeting a specific system, but a bot might as well target 256 different systems and see what sticks...
> 
> The alarm signal from the ones that don't stick is, in my opinion, the 
> primary benefit from this work -- it makes certain classes of attack 
> much less economical.  A crash dump from a panic'd machine may include 
> enough information to diagnose the exploited vulnerability - and once 
> diagnosed and fixed, knowledge about the vulnerability is much less 
> valuable.

Correct.

Beyond making worm propagation and zombie collection dynamics much less 
favorable, there's another aspect to randomization: attacks against high 
value Linux targets often use high value exploits, where considerable 
effort is spent to make sure that the attack will succeed 100%, without 
alerting anyone - or will fail safely without alerting anyone.

Probabilistically crashing the kernel does not fit that requirement.

In some cases adding even a _single bit_ of randomness will change the 
economics dramatically, because as time progresses and the kernel gets 
(hopefully) more secure, the value of an exploitable zero-day 
vulnerability becomes inevitably much higher than the value of pretty much 
any system attacked.

Injecting a significant risk of detection is a powerful concept. Think of 
WWII: how much effort went into making sure that the Germans did not 
detect that the encryption of Enigma was broken. Or how much effort went 
into making sure that the soviets did not detect that the US got hold of 
one of their nukes - etc.

So this feature really seems useful across the security spectrum, for low 
and high value systems alike.

Thanks,

	Ingo
