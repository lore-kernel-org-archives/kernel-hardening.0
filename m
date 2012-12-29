Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 29 Dec 2012 05:13:44 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <20121229051344.GC4939@ZenIV.linux.org.uk>
References: <20121228175627.GA7683@cachalot>
 <87wqw15wqb.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wqw15wqb.fsf@xmission.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Subject: [kernel-hardening] Re: [PATCH/RFC] user_ns: fix missing limiting of user_ns counts
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vasily Kulikov <segoon@openwall.com>, Containers <containers@lists.linux-foundation.org>, Serge Hallyn <serge.hallyn@canonical.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Dec 28, 2012 at 08:05:32PM -0800, Eric W. Biederman wrote:

> Yes.  Gcc can't turn a tail call into a jump in even the most basic
> cases apparently.

What.  The.  Fuck?

You have introduced unlimited recursion on kernel stack.  OK, it's
unpleasant, but it can happen to anybody.  But then you have the gall
to complain about gcc optimizations not saving your broken code.  Are
you serious?

It's not a question of gcc being not smart enough, and while we are
at it, it's *not* a basic case at all - we have recursion going through
the callback and we have non-trivial return value on top of that; if
the caller of kref_put() had checked said return value, you would've
been unable to turn that into a loop at all.

Are you seriously saying that you relied on compiler being smart enough
to
	* notice that return value of kref_put() is ignored
	* notice that therefore the return value of kref_sub() is ignored
	* notice that you have this call of put_user_ns() calling
kref_put() calling kref_sub() inside the callback we'd passed through the
last two levels of calls and that we are dealing with the tail recursion
here
... so that your code wouldn't have stepped into unlimited recursion?
I sincerely hope that you are not that much of an idiot.  If nothing else,
even if gcc did spot that one, the result would've been extremely brittle -
minor change to kref.h several year down the road and we'd get the problem.
