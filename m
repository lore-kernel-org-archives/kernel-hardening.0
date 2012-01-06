Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 6 Jan 2012 01:58:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20120106015808.1655d1c9.akpm@linux-foundation.org>
In-Reply-To: <20120106094339.GA9990@elte.hu>
References: <20120104201800.GA2587@www.outflux.net>
	<20120105091704.GB3249@elte.hu>
	<CAGXu5jJ=D1pKCZ8=1-WGkm0witNEH9Ux01+1BJyZKC_DAX00aA@mail.gmail.com>
	<20120106073635.GC14188@elte.hu>
	<20120106012120.32c3f370.akpm@linux-foundation.org>
	<20120106094339.GA9990@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2012.1] fs: symlink restrictions on sticky directories
To: Ingo Molnar <mingo@elte.hu>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Rik van Riel <riel@redhat.com>, Federica Teodori <federica.teodori@googlemail.com>, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Eric Paris <eparis@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>, Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 6 Jan 2012 10:43:40 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > +config PROTECTED_STICKY_SYMLINKS
> > > +	bool "Protect symlink following in sticky world-writable directories"
> > > +	default y
> > > +	help
> > > +	  A long-standing class of security issues is the symlink-based
> > > +	  time-of-check-time-of-use race, most commonly seen in
> > > +	  world-writable directories like /tmp. The common method of
> > > +	  exploitation of this flaw is to cross privilege boundaries
> > > +	  when following a given symlink (i.e. a root process follows
> > > +	  a malicious symlink belonging to another user).
> > > +
> > > +	  Enabling this solves the problem by permitting symlinks to be
> > > +	  followed only when outside a sticky world-writable directory,
> > > +	  or when the uid of the symlink and follower match, or when
> > > +	  the directory and symlink owners match.
> > 
> > This is all quite misleading.  One would expect that 
> > CONFIG_PROTECTED_STICKY_SYMLINKS turns the entire feature on 
> > or off permanently.  ie, it controls whether the code is 
> > generated into vmlinux in the usual fashion.  But it's not 
> > that at all - the user gets the feature whether or not he 
> > wants it, and this variable only sets the initial value.
> > 
> > Why are we forcing the user to have the feature if he doesn't 
> > want it, btw?
> 
> Basing on the (not yet fully confirmed) assertion that no apps 
> are broken by this change but exploits, I'd argue that this is 
> actually the sane and correct semantics for symlinks - i.e. we 
> want this to be the default Linux behavior - not just a 
> 'feature'.
> 
> That way the configuration knobs are compat settings in essence 
> - in case some app cares.
> 
> If people disagree and want it default off and as a separate 
> feature then it has to be modularized out some more. There's 
> notable silence from VFS folks on all this so Kees made an 
> educated guess. It might be wrong.

Maybe true for a general purpose computer, but someone who is making a
single-purpose device such as a digital TV or a wifi router won't want
it.

> > And we appear to be enabling the feature if CONFIG_PROC_FS=n, 
> > which might not be terribly useful?
> 
> It can still be useful if it's default on - just cannot be 
> turned off via /proc/sys/, right?
> 
> The combination that is not so useful is when it's off and 
> there's !PROC_FS. If it's a compat feature then i wouldnt bother 
> about it. If it's a separated out modular feature in a separate 
> .c file then it can all be properly shaped via Kconfig 
> dependencies.

Spose so.

I'd have thought the way to configure this feature would be to have
CONFIG_PROTECTED_STICKY_SYMLINKS to control the code generation then a
0 or 1 CONFIG_PROTECTED_STICKY_SYMLINKS_ENABLED to control the initial
setting.
