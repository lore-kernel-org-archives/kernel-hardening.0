Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 15 Apr 2016 15:06:26 +0200
From: Pavel Machek <pavel@denx.de>
Message-ID: <20160415130626.GA21457@amd>
References: <20160412221659.GA18102@www.outflux.net>
 <20160414200102.GB3856@amd>
 <CAGXu5jKNKV2RaPCw+m3R-e7irmmP0eRBBq9RKY0mcH5A1Nsx6g@mail.gmail.com>
 <20160414203444.GC3856@amd>
 <CAGXu5j+cTYF_OGG=u4BKU5X3f6TF0FdAcES9e_8S0ajMyjhn6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+cTYF_OGG=u4BKU5X3f6TF0FdAcES9e_8S0ajMyjhn6Q@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2] kaslr: allow kASLR to be default over Hibernation
To: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Ingo Molnar <mingo@kernel.org>, James Morse <james.morse@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, Yves-Alexis Perez <corsac@debian.org>, Emrah Demir <ed@abdsec.com>, Jonathan Corbet <corbet@lwn.net>, "x86@kernel.org" <x86@kernel.org>, Len Brown <len.brown@intel.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi!

> > Now I notice that it is quite unclear if it actually changes
> > anything...
> 
> Okay, right. So, there are a few problems that this patch is solving,
> and maybe it needs to be broken up into separate patches, but it
> didn't seem like it to me at the time. Specifically:
> 
> 1) The x86 hibernation and KASLR code don't play well together currently.
> 
> "1" was worked around so that both could be built in, but only one
> would be active at a time. This lead to:

> 2) The general hibernation code contains kernel arguments that should
> only affect x86.
> 
> And we have the desire by folks to have KASLR enabled by default on
> x86, giving us:
> 
> 3) There is no build-time way on x86 to switch the preference of KASLR
> vs hibernation.
> 
> I think "2" should be solved for this release, since arm64 KASLR is
> landing, and mistakenly booting an arm64 system with "kaslr" on the
> command line will needlessly disable hibernation.

Yes, I have no problem with "2".

> 3 and 2 are a result of 1, and IIUC, you're saying you want to solve 1
> to make everything else go away? My only concern with that idea is
> that I don't (yet) have the knowledge of x86 hibernation internals to
> fix this, and it'll take a while to get to having KASLR on by default
> if we have to wait on me to fix hibernation. (I'm not saying I
> won't/can't, it's just that it'll take me time to come up to speed on
> it.)
> 
> That do you think?

I believe it is more important to get it right than to have a solution
right now. x86-64 should be best architecture to start...

I don't understand kaslr, but it looks to me like you need to store
the kaslr seed in the hibernation image, then use thet in
set_up_temporary_mappings(). It should not be that bad.

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
