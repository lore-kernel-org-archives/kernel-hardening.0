Date: Thu, 30 Nov 2017 18:51:47 +0100
From: Solar Designer <solar@openwall.com>
Message-ID: <20171130175147.GA4124@openwall.com>
References: <1511337706-8297-1-git-send-email-s.mesoraca16@gmail.com> <1511337706-8297-3-git-send-email-s.mesoraca16@gmail.com> <9fe9b2cd312748ddb31f63f9dc1b1ed8@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9fe9b2cd312748ddb31f63f9dc1b1ed8@AcuMS.aculab.com>
Subject: [kernel-hardening] Re: [PATCH v3 2/2] Protected O_CREAT open in sticky directories
To: David Laight <David.Laight@ACULAB.COM>
Cc: 'Salvatore Mesoraca' <s.mesoraca16@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 30, 2017 at 04:53:06PM +0000, David Laight wrote:
> From: Salvatore Mesoraca
> > if a program tries to open a file, in a sticky directory,
> > with the O_CREAT flag and without the O_EXCL, it probably has a bug.
> > This feature allows to detect and potentially block programs that
> > act this way, it can be used to find vulnerabilities (like those
> > prevented by patch #1) and to do policy enforcement.

> I presume the 'vulnerabilities' are related to symlinks being created
> just before the open?

That's one way to exploit them.  We already have a sysctl to try and
block that specific attack, and we're considering adding more, for other
attacks.  But we'd also like an easy way to learn of the vulnerabilities
without anyone trying to exploit them yet, hence this patch.

> Trouble is this change breaks a lot of general use of /tmp.

That's general misuse of /tmp.  Things like "command > /tmp/file"
without having pre-created the file with O_EXCL e.g. by mktemp(1).

> I always assumed that code that cared would use O_EXCL and
> everything else wasn't worth subverting.

Opinions will vary on whether it's worth subverting or not, and someone
may reasonably want to configure this differently on different systems.

> I found code in vi (and elsewhere) that subverted these checks
> by opening with O_WRONLY if stat() showed the file existed and
> O_CREAT|O_EXCL if it didn't.

Yes, such misuses of /tmp and the like by use of those programs - where
the potential consequences would often be less severe (if your example
above is correct, it sounds like it'd be data spoofing but not
overwriting another file over a link) - could remain unnoticed.

> I'm pretty sure that traditionally a lot of these opens were done
> with O_CREAT|O_TRUNC.
> Implementing that as unlink() followed by a create would stop
> 'random' (ok all) symlinks being followed.

That's racy.  We have O_EXCL, and it must be used along with O_CREAT
when the directory is untrusted.  (If it were only about symlinks, we
also already have O_NOFOLLOW.)

> Overall I'm pretty sure this change will break things badly somewhere.

Sure.  We want it to visibly break what was subtly broken, so that the
breakage can be seen and corrected without an attempted attack.

Alexander
