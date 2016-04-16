Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 16 Apr 2016 21:58:09 +0200
From: Pavel Machek <pavel@denx.de>
Message-ID: <20160416195809.GA25795@amd>
References: <20160412221659.GA18102@www.outflux.net>
 <20160414200102.GB3856@amd>
 <CAGXu5jKNKV2RaPCw+m3R-e7irmmP0eRBBq9RKY0mcH5A1Nsx6g@mail.gmail.com>
 <20160414203444.GC3856@amd>
 <CAGXu5j+cTYF_OGG=u4BKU5X3f6TF0FdAcES9e_8S0ajMyjhn6Q@mail.gmail.com>
 <fd9b0950f40aaffbdaa30e9cf75a9e5b@abdsec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd9b0950f40aaffbdaa30e9cf75a9e5b@abdsec.com>
Subject: [kernel-hardening] Re: [PATCH v2] kaslr: allow kASLR to be default over Hibernation
To: Emrah Demir <ed@abdsec.com>
Cc: Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Ingo Molnar <mingo@kernel.org>, James Morse <james.morse@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, Yves-Alexis Perez <corsac@debian.org>, Jonathan Corbet <corbet@lwn.net>, x86@kernel.org, Len Brown <len.brown@intel.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, linux-doc@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, keescook@google.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri 2016-04-15 12:25:19, Emrah Demir wrote:
> On 2016-04-14 18:42, Kees Cook wrote:
> >On Thu, Apr 14, 2016 at 1:34 PM, Pavel Machek <pavel@denx.de> wrote:
> >>On Thu 2016-04-14 13:14:07, Kees Cook wrote:
> >>>On Thu, Apr 14, 2016 at 1:01 PM, Pavel Machek <pavel@denx.de> wrote:
> >>>> Hi!
> >>>>
> >>>>> Since kASLR and Hibernation can not currently coexist at runtime
> >>>>> on x86, the default behavior was to disable kASLR by default when
> >>>>> CONFIG_HIBERNATION was present (to retain original behavior).
> >>>>>
> >>>>> The behavior of kASLR on arm64 (and soon MIPS) is to be enabled by
> >>>>> default when selected at build time. Since arm64 Hibernation does not
> >>>>> conflict with kASLR, this fixes the hibernation argument parsing to be
> >>>>> x86-specific. Additionally, since end users want to be able to select
> >>>>> kASLR on x86 by default at build time, create CONFIG_RANDOMIZE_BASE_ON
> >>>>> that is present only on x86.
> 
> >>>>
> >>>> I believe this is bad idea. arm64 shows that kaslr and hibernation can
> >>>> coexist, and hibernation is still useful when your battery runs out.
> >>>
> >>>What? I'm confused -- this patch leaves the x86 behavior as-is by
> >>>default but allows hibernation to work with arm64. (For example, right
> >>>now, if you boot arm64 with "kaslr" kernel argument, hibernation will
> >>>get needlessly disabled.)
> >>
> 
> So what about making new kernel parameters. "hibernate" and "nohibernate"
> 
> This way before decompression it will look at the parameters and depend on
> parameters it will act differently
> 
> "kaslr" "nohibernate"  -->  kASLR will enable, no hibernate
> 
> "nokaslr" "nohibernate" --> Neither of them will work
> 
> "kaslr" "hiberante"   ---> Owner has to face consequences(ARM has
> advantages)
> 
> "nokaslr" "hibernate"  ---> kASLR disabled and hibernate will works.
> 
> Before writing something I want to know your ideas.

Patch fixing hibernation with kaslr on x86 and x86-64 would be
welcome.

Adding command line options that will become useless when kernel is
fixed ... not so much.

Best regards,
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
