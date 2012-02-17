Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 17 Feb 2012 15:42:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20120217154213.ecf4f7b4.akpm@linux-foundation.org>
In-Reply-To: <CAGXu5jJ629rrEuQX1MSiqM2SvhCSmZYuNZdOA4zBr5GZHtFcuw@mail.gmail.com>
References: <20120107185548.GA30748@outflux.net>
	<20120217152432.112fdace.akpm@linux-foundation.org>
	<CAGXu5jJ629rrEuQX1MSiqM2SvhCSmZYuNZdOA4zBr5GZHtFcuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2012.2] fs: symlink restrictions on sticky directories
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Rik van Riel <riel@redhat.com>, Federica Teodori <federica.teodori@googlemail.com>, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Eric Paris <eparis@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>, Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 17 Feb 2012 15:36:09 -0800
Kees Cook <keescook@chromium.org> wrote:

> > I think I disagree with this. __If the person compiling the kernel
> > includes the feature in his kernel via the time-honoured process of
> > "wtf is that thing? __Yeah, whatev", it gets turned on by default. __This
> > could easily result in weird failures which would take a *long* time
> > for an unsuspecting person to debug.
> >
> > Would it not be kinder to our users to start this out as
> > turned-off-at-runtime unless the kernel configurer has deliberately
> > gone in and enabled it?
> 
> There was a fair bit of back-and-forth discussion about it.
> Originally, I had it disabled, but, IIRC, Ingo urged me to have it be
> the default. I can sent a patch to disable it if you want.

What is the reasoning behind the current setting?
