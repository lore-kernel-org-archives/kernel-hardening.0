Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1381360911.2050.47.camel@joe-AO722>
From: Joe Perches <joe@perches.com>
Date: Wed, 09 Oct 2013 16:21:51 -0700
In-Reply-To: <5255E446.2000400@gmail.com>
References: <5255D023.2030907@gmail.com>
	 <1381356014.2050.28.camel@joe-AO722> <5255D2FD.6050705@gmail.com>
	 <1381356861.2050.33.camel@joe-AO722> <5255D7D4.8050204@gmail.com>
	 <1381358030.2050.36.camel@joe-AO722> <5255DBD8.30005@gmail.com>
	 <1381360187.2050.44.camel@joe-AO722> <5255E446.2000400@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3a] vsprintf: Check real user/group id for %pK
To: Ryan Mallon <rmallon@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, eldad@fogrefinery.com, Jiri Kosina <jkosina@suse.cz>, jgunthorpe@obsidianresearch.com, Dan Rosenberg <dan.j.rosenberg@gmail.com>, Kees Cook <keescook@chromium.org>, Alexander Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, George Spelvin <linux@horizon.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 2013-10-10 at 10:18 +1100, Ryan Mallon wrote:
> On 10/10/13 10:09, Joe Perches wrote:
> > Do the in_irq tests only when kptr_restrict is 1.
> > Document the %pK mechanism in vsnprintf
> > Add missing documentation for %pV and %pNF too
> 
> I really did mean post a follow-up/separate patch, not a different
> version of mine.

I think that's not the right thing to do.
There's no good reason to have multiple commits
for the same content.

And almost all of that is actually stuff I wrote.
Your content there is the cred checks.

> > +			cred = current_cred();
> > +			if (!has_capability_noaudit(current, CAP_SYSLOG) ||
> > +			    !uid_eq(cred->euid, cred->uid) ||
> > +			    !gid_eq(cred->egid, cred->gid))
