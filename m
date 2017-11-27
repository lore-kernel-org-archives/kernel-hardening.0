Date: Mon, 27 Nov 2017 01:26:41 +0100
From: Solar Designer <solar@openwall.com>
Message-ID: <20171127002641.GA14743@openwall.com>
References: <1511337706-8297-1-git-send-email-s.mesoraca16@gmail.com> <1511337706-8297-3-git-send-email-s.mesoraca16@gmail.com> <20171122165144.07aea7ac@alans-desktop> <33dcc007e92349999ce77bf45825be22@AcuMS.aculab.com> <CAJHCu1K-xZXaXh38qYaNzJBr+USVxvsaqOReZjtnchxVOyYnww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJHCu1K-xZXaXh38qYaNzJBr+USVxvsaqOReZjtnchxVOyYnww@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v3 2/2] Protected O_CREAT open in sticky directories
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: David Laight <David.Laight@aculab.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 24, 2017 at 12:43:47PM +0100, Salvatore Mesoraca wrote:
> 2017-11-24 11:53 GMT+01:00 David Laight <David.Laight@aculab.com>:
> > From: Alan Cox
> >> Sent: 22 November 2017 16:52
> >>
> >> On Wed, 22 Nov 2017 09:01:46 +0100 Salvatore Mesoraca <s.mesoraca16@gmail.com> wrote:
> >>
> >> > Disallows O_CREAT open missing the O_EXCL flag, in world or
> >> > group writable directories, even if the file doesn't exist yet.
> >> > With few exceptions (e.g. shared lock files based on flock())

Why would "shared lock files based on flock()" need O_CREAT without
O_EXCL?  Where specifically are they currently used that way?  My guess
would be a group-writable mail spool (that would be fcntl() locks on
Linux now, but it's the same thing for the purpose of this discussion),
but even then I don't see a need for such open flags.  If a program does
that, we could want to find out and revise it (if O_CREAT|O_EXCL fails,
retry without these to open the existing file, then flock() either way).

> >> Enough exceptions to make it a bad idea.

Maybe, but as Salvatore points out we're considering this for rather
limited use - easy opt-in policy enforcement during software development
and auditing (years ago, I was using an LKM for this purpose, which
caught some issues in Postfix that were promptly patched), and maybe on
specific production systems where the sysadmins know what they're doing.

> >> Firstly if you care this much *stop* having shared writable directories.
> >> We have namespaces, you don't need them. You can give every user their
> >> own /tmp etc.

This is good advice (and I've been doing similar with pam_mktemp, prior
to namespaces), but it's not exactly for the same use case.

Also, there are shared writable directories that have to remain shared
unless more things are reworked.  For example, mail spools and crontab
directories, which could be avoided by having the corresponding files in
user homes instead (and it's been done), but that's also a related risk
(a privileged process accessing a directory writable by a user, even if
accessing only for reading, lowering the risk impact).

> > Looks like a very bad idea to me as well.
> >
> > Doesn't this stop all shell redirects into a shared /tmp ?

The above sounds like it'd be something bad - but it's actually just
right for an opt-in policy like this.  A command like "program >
/tmp/file" is generally unsafe (unless the file was pre-created safely,
see below) and should be avoided.  The fact that a lot of documentation
gives commands of this kind only emphasizes the need for easy policy
enforcement against such misuses of /tmp.

Ideally, we'd stop most "shell redirects into a shared /tmp" - all but
those into files correctly pre-created with mktemp(1) and the like.

Technically, we could achieve similar by allowing O_CREAT without O_EXCL
if the file exists _and_ has the same owner as our current fsuid or the
owner is root.  Most scripts that use mktemp(1) then use that file
without switching privileges, so they'll continue working.  If there's
an exception to that on a system where I'd configure a policy like
what's discussed here, I'd rather learn of it and be interested in
looking at that unusual script.  That script would be taking a risk by
making one (pseudo-)user (or root) write into a file in /tmp created
(even if initially safely) by another pseudo-user (not root), thus
letting the latter pseudo-user attack the former (or root).

Ditto for programs using mkstemp(3), but then somehow going through the
pathname rather than the fd.  That's not ideal, but it's sometimes safe
and sometimes makes sense (such as when they need to exec other programs
only accepting a pathname), so the same exception and approach applies.

> > I'm pretty sure most programs use O_CREAT | O_TRUNC for output
> > files - they'll all stop working.

That would be great.  Unfortunately (in this context), you've identified
exceptions, where programs try to be smart but are not necessarily safe.

It's beneficial to be able to easily stop at least some misuses of /tmp
and the like, even if we can't stop all.

> If some program does such a thing, that's a potential vulnerability.

Exactly.

> With "protected_hardlinks" you are, in most cases, safe.

And "protected_symlinks", and not in terms of data spoofing attacks via
FIFOs and regular files (the initial focus of this patchset).

> But, still, that program has a bug and having this feature enabled will
> help you notice it soon.
> For that matter, I'm using this patch on my system and I don't have any
> program behaving like this.
> 
> > If there are some directories where you need to force O_EXCL you
> > need to make it a property of the directory, not the kernel.
> >
> >         David

Good idea, but this would need to be checked and enforced by the kernel
anyhow, so it's a matter of coarse vs. fine policy.  Coarse is much
easier to implement and to start using, albeit perhaps mostly not by
general-purpose distros, but by a software developer/auditor, an
adventurous sysadmin, or a sysadmin team or a developer of specific
systems where a simple policy like this is known to be valid (e.g.,
where there's no expectation of arbitrary software being added, so a
simple rule like this can be introduced system-wide).

Alexander
