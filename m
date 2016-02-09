Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 9 Feb 2016 20:14:30 +0100
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160209201430.67b852830e40e74e4e80762f@gmail.com>
In-Reply-To: <CAGXu5j+ugmECzm7-ppjVLd=oii5tewUxrRVc5T25hdodeVkq2g@mail.gmail.com>
References: <20160207222721.e0087a07fa604b5dac79a109@gmail.com>
	<20160207223257.28ca7020daa09c082e6b9c62@gmail.com>
	<CAGXu5j+ugmECzm7-ppjVLd=oii5tewUxrRVc5T25hdodeVkq2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 3/3] Documentation for the GCC plugin infrastructure
To: Kees Cook <keescook@chromium.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Michal Marek <mmarek@suse.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 8 Feb 2016 20:27:31 -0800
Kees Cook <keescook@chromium.org> wrote:

> On Sun, Feb 7, 2016 at 1:32 PM, Emese Revfy <re.emese@gmail.com> wrote:
> > This is the GCC infrastructure documentation about its operation, how to add
> > and use a new plugin with an example.
> >
> > ---
> >  Documentation/example_gcc_plugin.c | 103 +++++++++++++++++++++++++++++++++++++
> 
> Perhaps this example should live in samples/gcc_plugin/ ?

Perhaps the example plugin is unnecessary. I should use the cyclomatic complexity plugin
because I already wrote about it in the sections "Usage" and "How to add a new GCC plugin"
and they differ by only two lines.

> For an example, I'd expect verbose comments. :) Imagine someone
> reading it who knows very little about plugins or compiler internals.

I think gcc has very good documentation about plugins, I reference them from gcc-plugins.txt,
you can see it below. If you think it isn't enough tell me please what you would like to
see as additional documentation.  

> > +1. Introduction
> > +===============
> > +
> > +GCC plugins are loadable modules that provide extra features to the
> > +compiler [1]. They are useful for runtime instrumentation and static analysis.
> > +We can analyse, change and add further code during compilation via
> > +callbacks [2], GIMPLE [3], IPA [4] and RTL passes [5].
> > +
> > +The GCC plugin infrastructure of the kernel supports all gcc versions from
> > +4.5 to 6.0, building out-of-tree modules, cross-compilation and building in a
> > +separate directory.
> > +
> > +Currently the GCC plugin infrastructure supports only the x86 architecture.
> > +
> > +This infrastructure was ported from grsecurity [6] and PaX [7].
> > +
> > +--
> > +[1] https://gcc.gnu.org/onlinedocs/gccint/Plugins.html
> > +[2] https://gcc.gnu.org/onlinedocs/gccint/Plugin-API.html#Plugin-API
> > +[3] https://gcc.gnu.org/onlinedocs/gccint/GIMPLE.html
> > +[4] https://gcc.gnu.org/onlinedocs/gccint/IPA.html
> > +[5] https://gcc.gnu.org/onlinedocs/gccint/RTL.html
> > +[6] https://grsecurity.net/
> > +[7] https://pax.grsecurity.net/

-- 
Emese
