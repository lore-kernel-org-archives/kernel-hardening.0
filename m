Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 19 Jan 2017 09:52:14 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20170119085214.GG6485@twins.programming.kicks-ass.net>
References: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
 <20170118103031.GB15169@kroah.com>
 <CAGXu5jJyTpsq_=nz2CWQGk1iUtvC8-PqNqxHJ0chowbnB5Y-Xg@mail.gmail.com>
 <20170118203534.GA22446@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170118203534.GA22446@kroah.com>
Subject: [kernel-hardening] Re: [RFCv2 PATCH 00/18] refcount_t API + usage
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Kees Cook <keescook@chromium.org>, Elena Reshetova <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>, Will Deacon <will.deacon@arm.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 18, 2017 at 09:35:34PM +0100, Greg KH wrote:
> I think the refcount_t patch should also go to tip given it depends on
> the kref patches.  But that's up to Peter, he would know best...

Yeah, so I held back on that and the kref conversion, because I wanted
to get the kref fixup thingies in first. If there's no fallout from that
I can stuff in the refcount_t bits.
