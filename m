Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 6 Jan 2012 02:33:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20120106023358.76374f2c.akpm@linux-foundation.org>
In-Reply-To: <20120106100520.GA7962@elte.hu>
References: <20120104201800.GA2587@www.outflux.net>
	<20120105091704.GB3249@elte.hu>
	<CAGXu5jJ=D1pKCZ8=1-WGkm0witNEH9Ux01+1BJyZKC_DAX00aA@mail.gmail.com>
	<20120106073635.GC14188@elte.hu>
	<20120106012120.32c3f370.akpm@linux-foundation.org>
	<20120106094339.GA9990@elte.hu>
	<20120106015808.1655d1c9.akpm@linux-foundation.org>
	<20120106100520.GA7962@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2012.1] fs: symlink restrictions on sticky directories
To: Ingo Molnar <mingo@elte.hu>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Rik van Riel <riel@redhat.com>, Federica Teodori <federica.teodori@googlemail.com>, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Eric Paris <eparis@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>, Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 6 Jan 2012 11:05:20 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Maybe true for a general purpose computer, but someone who is 
> > making a single-purpose device such as a digital TV or a wifi 
> > router won't want it.
> 
> That's the case for 99% of the features and semantics we have: 
> by definition a single-purpose device uses only a small sub-set 
> of an infinite purpose OS, right?
> 
> Still we only modularize semantics out if they easily fit into 
> some existing plug-in/module concept, if the feature is arguably 
> oddball that a sizable portion of people want to disable, or if 
> it makes notable sense for size reasons. To me it looked 
> distinctly silly to complicate things for such a small piece of 
> code.

We're talking tens or hundreds of millions of machines for which the
patch is a straightforward speed and space regression.  Fixing this
needs just a little Kconfig twiddling and a #else clause.  We may as
well do it.

> I doubt Kees would mind modularizing it, but it would be nice to 
> get VFS maintainer feedback in the:
> 
>    { 'you are crazy, over my dead body' ... 'cool, merge it' }
> 
> continuous spectrum of possible answers.

Well yes.  We'll get there.

Alas, I've become rather slack in my maintainer patchbombing in the
past year or two.  It's just boring and depressing to spray patches at
maintainers and have 90% or more of them simply ignored.  I'm sitting
on 45 such patches at present so I suppose I should get off my tail and
do a respray.
