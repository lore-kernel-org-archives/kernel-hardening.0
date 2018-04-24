Date: Tue, 24 Apr 2018 13:09:06 -0700
From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH 1/3] big key: get rid of stack array allocation
Message-ID: <20180424200906.GC174675@gmail.com>
References: <20180424010321.14739-1-tycho@tycho.ws>
 <20180424045015.GA4281@sol.localdomain>
 <20180424143539.GB3125@cisco>
 <201804242346.FHI69745.SQMHFVOOFLFOJt@I-love.SAKURA.ne.jp>
 <20180424145104.GC3125@cisco>
 <20180424195845.GB23575@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180424195845.GB23575@mail.hallyn.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Tycho Andersen <tycho@tycho.ws>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, dhowells@redhat.com, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, jmorris@namei.org, Jason@zx2c4.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 24, 2018 at 02:58:45PM -0500, Serge E. Hallyn wrote:
> Quoting Tycho Andersen (tycho@tycho.ws):
> > On Tue, Apr 24, 2018 at 11:46:38PM +0900, Tetsuo Handa wrote:
> > > Tycho Andersen wrote:
> > > > > > +	if (unlikely(crypto_aead_ivsize(big_key_aead) != GCM_AES_IV_SIZE)) {
> > > > > > +		WARN(1, "big key algorithm changed?");
> > > 
> > > Please avoid using WARN() WARN_ON() etc.
> > > syzbot would catch it and panic() due to panic_on_warn == 1.
> > 
> > But it is really a programming bug in this case (and it seems better
> > than BUG()...). Isn't this exactly the sort of case we want to catch?
> > 
> > Tycho
> 
> Right - is there a url to some discussion about this?  Because not
> using WARN when WARN should be used, because it troubles a bot, seems
> the wrong solution.  If this *is* what's been agreed upon, then
> what is the new recommended thing to do here?
> 
> -serge

WARN() is for recoverable kernel bugs, which this is, so WARN() is correct here.
Fuzzers often find cases where WARN() is used on invalid user input or other
cases that are not kernel bugs, and then it has to be removed or replaced with
pr_warn().  But here it is appropriate.  Unfortunately a lot of developers still
seem confused; improving the comments in include/asm-generic/bug.h might help.

Eric
