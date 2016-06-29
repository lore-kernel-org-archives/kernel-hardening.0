Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 29 Jun 2016 20:39:14 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160629203914.db0dce1f9587a67f1a20a602@gmail.com>
In-Reply-To: <874m8dhwb4.fsf@rasmusvillemoes.dk>
References: <20160628133407.10c2ea1ecd194e8085e84c5a@gmail.com>
	<20160628133645.8f3cac0df4fc363e308426ac@gmail.com>
	<874m8dhwb4.fsf@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v1 2/2] Mark functions with the __nocapture attribute
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: kernel-hardening@lists.openwall.com, pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, arnd@arndb.de
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 28 Jun 2016 22:50:55 +0200
Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:

> On Tue, Jun 28 2016, Emese Revfy <re.emese@gmail.com> wrote: 
> > diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
> > index 6f96247..4cdf266 100644
> > --- a/include/asm-generic/bug.h
> > +++ b/include/asm-generic/bug.h
> > @@ -62,13 +62,13 @@ struct bug_entry {
> >   * to provide better diagnostics.
> >   */
> >  #ifndef __WARN_TAINT
> > -extern __printf(3, 4)
> > +extern __printf(3, 4) __nocapture(1, 3, 4)
> >  void warn_slowpath_fmt(const char *file, const int line,
> >  		       const char *fmt, ...);
> > -extern __printf(4, 5)
> > +extern __printf(4, 5) __nocapture(1, 4, 5)
> >  void warn_slowpath_fmt_taint(const char *file, const int line, unsigned taint,
> >  			     const char *fmt, ...);
> 
> The 3,4 and 4,5 parts seem redundant when __printf automatically supplies those.

Thanks, I'll fix them in the next patch set.

-- 
Emese
