Date: Fri, 27 Oct 2017 21:44:11 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20171027204410.4jdg2uwuj2mlw5sd@salmiak>
References: <20171026090942.7041-1-mark.rutland@arm.com>
 <20171027154113.GA13737@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171027154113.GA13737@arm.com>
Subject: [kernel-hardening] Re: [RFC PATCH 0/2] arm64: optional paranoid __{get,put}_user checks
To: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Catalin Marinas <catalin.marinas@arm.com>, Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Oct 27, 2017 at 04:41:13PM +0100, Will Deacon wrote:
> On Thu, Oct 26, 2017 at 10:09:40AM +0100, Mark Rutland wrote:
> > Hi,
> > 
> > In Prague, Kees mentioned that it would be nice to have a mechanism to
> > catch bad __{get,put}_user uses, such as the recent CVE-2017-5123 [1,2]
> > issue with unsafe_put_user() in waitid().
> > 
> > These patches allow an optional access_ok() check to be dropped in
> > arm64's __{get,put}_user() primitives. These will then BUG() if a bad
> > user pointer is passed (which should only happen in the absence of an
> > earlier access_ok() check).
> > 
> > The first patch rewrites the arm64 access_ok() check in C. This gives
> > the compiler the visibility it needs to elide redundant access_ok()
> > checks, so in the common case:
> > 
> >   get_user()
> >     access_ok()
> >     __get_user()
> >       BUG_ON(!access_ok())
> >       <uaccess asm>
> > 
> > ... the compiler can determine that the second access_ok() must return
> > true, and can elide it along with the BUG_ON(), leaving:
> > 
> >   get_user()
> >     access_ok()
> >       __get_user()
> >         <uaccess asm>
> > 
> > ... and thus this sanity check can have no cost in the common case.
> 
> Probably a stupid question, but why not just move the access_ok check
> into __{get,put}_user and remove it from {get,put}_user?

Good question.

I was considering this as a debug option, making it possible to catch unsafe
__{get,put}_user() uses via fuzzing or at build time.

As a hardening option, it would make more sense to always have the check in
__{get,put}_user().

> We can also then move the uaccess_{enable,disable}_not_uao calls out from the
> __ variants so that we can implement user_access_{begin,end}.

Mhmm. I'll take a look at this for v2, afer I've figured out precisely what
I've broken with this RFC.

I'd still like the option to scream on unsafe __{get,put}_user() calls, but it
should be possible to handle both cases with minimal IS_ENABLED() usage.

Thanks,
Mark.
