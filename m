Reply-To: kernel-hardening@lists.openwall.com
Date: 11 Oct 2013 00:42:32 -0400
Message-ID: <20131011044232.11545.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
In-Reply-To: <87pprck0q7.fsf@xmission.com>
Subject: [kernel-hardening] Re: [PATCH v3a] vsprintf: Check real user/group id for %pK
To: ebiederm@xmission.com, joe@perches.com
Cc: akpm@linux-foundation.org, dan.j.rosenberg@gmail.com, eldad@fogrefinery.com, jgunthorpe@obsidianresearch.com, jkosina@suse.cz, keescook@chromium.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux@horizon.com, rmallon@gmail.com, viro@zeniv.linux.org.uk
List-ID: <kernel-hardening.lists.openwall.com>

ebiederm@xmission.com (Eric W. Biederman) wrote:
> Sigh.  This is all wrong.  The only correct thing to test is
> file->f_cred.  Aka the capabilities of the program that opened the
> file.
> 
> Which means that the interface to %pK in the case of kptr_restrict is
> broken as it has no way to be passed the information it needs to make
> a sensible decision.

I looked at the code, and pretty painful.  Certainly it's possible to
include a reference to the file (I was thinking of just the credentials,
actually) in the seq_file.  But getting that to the vsprintf.c code
(specifically, the pointer() function) is a PITA.

I'm willing to accept the currently proposed kludge as a "good enough"
approximation, as long as we're all agreed that using the credentials
at open() time would be The Right Thing, and hopefully someone will find
the round tuitts to implement that in future.

But in the meantime, "the perfect is the enemey of the good" is worth
remembering.

(An alternate implementation I've been thinking about would be to do
away with %pK, and instead have a "secret_ptr(p, seq->cred)" helper that
returned p or 0 depending on the credential.)
