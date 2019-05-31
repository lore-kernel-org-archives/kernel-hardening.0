Date: Fri, 31 May 2019 11:05:58 -0600
From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: unrecognizable insn generated in plugin?
Message-ID: <20190531170558.GD5739@cisco>
References: <20190530170033.GA5739@cisco>
 <CA+=Sn1kSg-Y8SseUWPTTJi5HRgYYxVtcDGUJvCcCYQQzKeiUQw@mail.gmail.com>
 <20190530192606.GB5739@cisco>
 <CAN+XpFRPnt7w5jkadD9ANHA2NTDnjOzjnPWDLY26wOq-jNAW-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+XpFRPnt7w5jkadD9ANHA2NTDnjOzjnPWDLY26wOq-jNAW-g@mail.gmail.com>
To: Mark Brand <markbrand@google.com>
Cc: Andrew Pinski <pinskia@gmail.com>, GCC Mailing List <gcc@gcc.gnu.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 31, 2019 at 05:43:44PM +0200, Mark Brand wrote:
> On Thu, May 30, 2019 at 9:26 PM Tycho Andersen <tycho@tycho.ws> wrote:
> >
> > Hi Andrew,
> >
> > On Thu, May 30, 2019 at 10:09:44AM -0700, Andrew Pinski wrote:
> > > On Thu, May 30, 2019 at 10:01 AM Tycho Andersen <tycho@tycho.ws> wrote:
> > > >
> > > > Hi all,
> > > >
> > > > I've been trying to implement an idea Andy suggested recently for
> > > > preventing some kinds of ROP attacks. The discussion of the idea is
> > > > here:
> > > > https://lore.kernel.org/linux-mm/DFA69954-3F0F-4B79-A9B5-893D33D87E51@amacapital.net/
> > > >
> 
> 
> Hi Tycho,
> 
> I realise this is maybe not relevant to the topic of fixing the
> plugin; but I'm struggling to understand what this is intending to
> protect against.
> 
> The idea seems to be to make sure that restored rbp, rsp values are
> "close" to the current rbp, rsp values? The only scenario I can see
> this providing any benefit is if an attacker can only corrupt a saved
> stack/frame pointer, which seems like such an unlikely situation that
> it's not really worth adding any complexity to defend against.

> An attacker who has control of rip can surely get a controlled value
> into rsp in various ways;

Yes, if you already have control of rip this doesn't help you.

> a quick scan of the current Ubuntu 18.04
> kernel image offers the following sequence (which shows up
> everywhere):
> 
> lea rsp, qword ptr [r10 - 8]
> ret
> 
> I'd assume that it's not tremendously difficult for an attacker to
> chain to this without needing to previously pivot out the stack
> pointer, assuming that at the point at which they gain control of rip
> they have control over some state somewhere. If you could explain the
> exact attack scenario that you have in mind then perhaps I could
> provide a better explanation of how one might bypass it.

The core bit that's important here is the writes to rsp/rbp, not the
fact that they're pop instructions. The insight is that we know how
the thread's stack should be aligned, and so any value that's written
to these registers outside of that alignment (during "normal"
execution) is a bug.

The idea is that a ROP attack requires a payload to be injected
somewhere so that it can return to this payload and execute this
attack. This is most probably done via some allocation elsewhere
(add_key() or unreceived data or whatever) since as you note, the
stack should be mostly well protected.

So then, if we don't allow anyone to write anything that's not on the
stack to rsp/rbp, in principle we should be safe from ROP attacks
where the payload is elsewhere. As you note, preventing bad "pop
rpb" instructions is not enough, nor is preventing bad "pop rsp", as
Andy initially proposed. We need to prevent all bad writes to these
registers, including the sequence you mentioned, and presumably
others. So there would need to be a lot more matching and checks
inserted, and maybe it would ultimately be slow. Right now I just
wanted to play with it for a bit to see if I can get it to work at all
even in one case :)

Am I thinking about this wrong? Any discussion is welcome, thanks!

Tycho
