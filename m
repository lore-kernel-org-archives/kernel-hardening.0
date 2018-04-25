Date: Wed, 25 Apr 2018 08:15:07 -0600
From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH 1/3] big key: get rid of stack array allocation
Message-ID: <20180425141507.GA4240@cisco>
References: <20180424143539.GB3125@cisco>
 <201804242346.FHI69745.SQMHFVOOFLFOJt@I-love.SAKURA.ne.jp>
 <20180424145104.GC3125@cisco>
 <20180424195845.GB23575@mail.hallyn.com>
 <CAGXu5j+SXCJpm9xnX1UaY0Qz2+E0qNETc+s8kwrH6hE9LLjgpw@mail.gmail.com>
 <201804251936.GAG73463.HOJtFFOQSLFOVM@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201804251936.GAG73463.HOJtFFOQSLFOVM@I-love.SAKURA.ne.jp>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: keescook@chromium.org, serge@hallyn.com, ebiggers3@gmail.com, dhowells@redhat.com, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, jmorris@namei.org, Jason@zx2c4.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 25, 2018 at 07:36:21PM +0900, Tetsuo Handa wrote:
> Kees Cook wrote:
> > On Tue, Apr 24, 2018 at 12:58 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> > > Quoting Tycho Andersen (tycho@tycho.ws):
> > >> On Tue, Apr 24, 2018 at 11:46:38PM +0900, Tetsuo Handa wrote:
> > >> > Tycho Andersen wrote:
> > >> > > > > +     if (unlikely(crypto_aead_ivsize(big_key_aead) != GCM_AES_IV_SIZE)) {
> > >> > > > > +             WARN(1, "big key algorithm changed?");
> > >> >
> > >> > Please avoid using WARN() WARN_ON() etc.
> > >> > syzbot would catch it and panic() due to panic_on_warn == 1.
> > >>
> > >> But it is really a programming bug in this case (and it seems better
> > >> than BUG()...). Isn't this exactly the sort of case we want to catch?
> > >>
> > >> Tycho
> > >
> > > Right - is there a url to some discussion about this?  Because not
> > > using WARN when WARN should be used, because it troubles a bot, seems
> > > the wrong solution.  If this *is* what's been agreed upon, then
> > > what is the new recommended thing to do here?
> > 
> > BUG() is basically supposed to never be used, as decreed by Linus.
> > WARN() here is entirely correct: if we encounter a case where
> > crypto_aead_ivsize(big_key_aead) != GCM_AES_IV_SIZE is not true, we
> > run the risk of stack memory corruption. If this is an EXPECTED
> > failure case, then okay, drop the WARN() but we have to keep the
> > -EINVAL.
> 
> big_key_init() is __init function of built-in module which will be called
> only once upon boot, isn't it? Then, there is no point to continue after
> WARN(); BUG() is better here.

I don't think so. The machine can still boot and work just fine, but
big key crypto will not be available. I suspect there are some
machines out there that don't need big key, so there's no reason for
the boot to fail. That's the rub about WARN vs BUG -- that in most
cases things can continue on happily.

> Moreover, if this is meant for sanity check in case something went wrong
> (e.g. memory corruption), it is better to check at run time like

But the algorithm is hard coded at the top of the file, so one check
is enough.

Tycho
