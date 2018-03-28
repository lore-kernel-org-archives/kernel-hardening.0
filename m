Date: Wed, 28 Mar 2018 12:10:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] rslib: Remove VLAs by setting upper bound on nroots
In-Reply-To: <alpine.DEB.2.21.1803281020390.3247@nanos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.21.1803281210040.3247@nanos.tec.linutronix.de>
References: <20180315225919.GA43806@beast> <20180316155950.35fda7c63ec59277ba504201@linux-foundation.org> <CAGXu5jLAqki8oE7AF9BEwLxKzpTOOPsT1imjdSAG_U44uGXJdQ@mail.gmail.com> <CAGXu5j+utmcN_ot-3NJ-8C0onnu8O-DOdbAxVoatzE9UcJ-O4A@mail.gmail.com>
 <20180327164532.796cdd043fece53cd9b56f8f@linux-foundation.org> <CAGXu5j+7cG+BQQLfxSm8xLPzF1de7_+fU-s0R5ZXjfD0jx4c8w@mail.gmail.com> <alpine.DEB.2.21.1803281020390.3247@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Segher Boessenkool <segher@kernel.crashing.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 28 Mar 2018, Thomas Gleixner wrote:
> On Tue, 27 Mar 2018, Kees Cook wrote:
> 
> > > I guess if we put this storage into the rs_control (rather than on the
> > > stack) then we'd have to worry about concurrent uses of it.  It looks
> > > like all the other fields are immutable once it's set up so there might
> > > be such users.  In fact, I suspect there are...
> > 
> > Exactly. :( This is the same conclusion tglx and I came to.
> 
> I think we can lift that and just let all users set up a new rs_control
> from scratch. Takes some time to init the tables, but ....

Bah, no. dm-verity really wants to share them.....
