Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 18 Jan 2017 21:35:34 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20170118203534.GA22446@kroah.com>
References: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
 <20170118103031.GB15169@kroah.com>
 <CAGXu5jJyTpsq_=nz2CWQGk1iUtvC8-PqNqxHJ0chowbnB5Y-Xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJyTpsq_=nz2CWQGk1iUtvC8-PqNqxHJ0chowbnB5Y-Xg@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFCv2 PATCH 00/18] refcount_t API + usage
To: Kees Cook <keescook@chromium.org>
Cc: Elena Reshetova <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>, Peter Zijlstra <peterz@infradead.org>, Will Deacon <will.deacon@arm.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 18, 2017 at 12:06:19PM -0800, Kees Cook wrote:
> On Wed, Jan 18, 2017 at 2:30 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Wed, Jan 18, 2017 at 11:11:29AM +0200, Elena Reshetova wrote:
> >> Changes since v1:
> >>  - kref INIT fixes are moved to a proper separate commit
> >>  - Peter's commits are now properly integrated into series
> >>  - various small fixes are incorporated based on testing
> >>    results and feedback
> >>
> >> This patch series is build on top of Peter's Zijlstra patches
> >> that provide refcount_t type and API definition.
> >> The rest of patches convert various places of kernel subsystems
> >> where atomic_t was used for reference counting to new refcount_t type and API.
> >> By doing this, we make sure that underflows and overflows
> >> cannot occur in these places and therefore no use-after-free situation
> >> can be created and misused by an attacker.
> >
> > Your first 7 patches are fine, and most of them are already in the tip
> > tree and getting use in linux-next now.  I'd recommend submitting the
> 
> Where do you see this? I haven't seen refcount_t land in -next yet.

The patches leading up to refcount_t are in the tip tree.

> Should I carry these in the KSPP tree, or who should take them?

I think the refcount_t patch should also go to tip given it depends on
the kref patches.  But that's up to Peter, he would know best...

thanks,

greg k-h
