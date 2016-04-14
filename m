Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 14 Apr 2016 22:34:44 +0200
From: Pavel Machek <pavel@denx.de>
Message-ID: <20160414203444.GC3856@amd>
References: <20160412221659.GA18102@www.outflux.net>
 <20160414200102.GB3856@amd>
 <CAGXu5jKNKV2RaPCw+m3R-e7irmmP0eRBBq9RKY0mcH5A1Nsx6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKNKV2RaPCw+m3R-e7irmmP0eRBBq9RKY0mcH5A1Nsx6g@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2] kaslr: allow kASLR to be default over Hibernation
To: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Ingo Molnar <mingo@kernel.org>, James Morse <james.morse@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, Yves-Alexis Perez <corsac@debian.org>, Emrah Demir <ed@abdsec.com>, Jonathan Corbet <corbet@lwn.net>, "x86@kernel.org" <x86@kernel.org>, Len Brown <len.brown@intel.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu 2016-04-14 13:14:07, Kees Cook wrote:
> On Thu, Apr 14, 2016 at 1:01 PM, Pavel Machek <pavel@denx.de> wrote:
> > Hi!
> >
> >> Since kASLR and Hibernation can not currently coexist at runtime
> >> on x86, the default behavior was to disable kASLR by default when
> >> CONFIG_HIBERNATION was present (to retain original behavior).
> >>
> >> The behavior of kASLR on arm64 (and soon MIPS) is to be enabled by
> >> default when selected at build time. Since arm64 Hibernation does not
> >> conflict with kASLR, this fixes the hibernation argument parsing to be
> >> x86-specific. Additionally, since end users want to be able to select
> >> kASLR on x86 by default at build time, create CONFIG_RANDOMIZE_BASE_ON
> >> that is present only on x86.
> >>
> >> Signed-off-by: Kees Cook <keescook@chromium.org>
> >
> > I believe this is bad idea. arm64 shows that kaslr and hibernation can
> > coexist, and hibernation is still useful when your battery runs out.
> 
> What? I'm confused -- this patch leaves the x86 behavior as-is by
> default but allows hibernation to work with arm64. (For example, right
> now, if you boot arm64 with "kaslr" kernel argument, hibernation will
> get needlessly disabled.)

So it is very different from the PATCH v1, still it shares the
subject?

This is the part I don't like:

> >> Since kASLR and Hibernation can not currently coexist at runtime
> >> on x86, the default behavior was to disable kASLR by default when
> >> CONFIG_HIBERNATION was present (to retain original behavior).

Now I notice that it is quite unclear if it actually changes
anything...

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
