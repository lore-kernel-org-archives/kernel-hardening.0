Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 2 Mar 2016 21:57:11 +0100
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160302215711.7ba0301691f3eb3f5316b861@gmail.com>
In-Reply-To: <CAGXu5j+gTWR_ZMk6nMzMZRfTvvi7VXg5ngoHx6cC+r-fe1OgNA@mail.gmail.com>
References: <20160301181400.9c623ee9230381da90b89b2a@gmail.com>
	<20160301181514.dc3dadeb7e18b77a09dddb7f@gmail.com>
	<CAGXu5j+gTWR_ZMk6nMzMZRfTvvi7VXg5ngoHx6cC+r-fe1OgNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v4 1/3] GCC plugin infrastructure
To: Kees Cook <keescook@chromium.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Michal Marek <mmarek@suse.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 1 Mar 2016 11:07:25 -0800
Kees Cook <keescook@chromium.org> wrote:

> I wonder if it might make sense to split the .so-building logic
> changes from the gcc plugin changes to make things more readable for
> review? Personally, I'm fine with this as-is, but it might benefit
> other reviewers, if it's a sane split.

I will split this patch in the next patch set.

> > +GCC PLUGINS
> > +M:     Kees Cook <keescook@chromium.org>
> > +R:     Emese Revfy <re.emese@gmail.com>
> > +L:     kernel-hardening@lists.openwall.com
> > +S:     Maintained
> > +F:     tools/gcc
> 
> I think that needs a trailing slash to indicate it's a tree to match.

I tested it with get_maintainer.pl and it is good.

> > +F:     Documentation/gcc-plugins.txt
> 
> I wonder if this should be moved to Documentation/kbuild/ ?

I don't know. Michal Marek, could you please tell me where I should put the documentation? 

-- 
Emese
