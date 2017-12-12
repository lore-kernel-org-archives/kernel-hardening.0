MIME-Version: 1.0
In-Reply-To: <20171211160747.GA24829@openwall.com>
References: <1511337706-8297-1-git-send-email-s.mesoraca16@gmail.com>
 <20171127011441.GA15063@openwall.com> <CAJHCu1+wC1BsW2r77aoibFth_qtjozKZFJTaD4xCuGBzHp2s4w@mail.gmail.com>
 <20171130190539.GA4360@openwall.com> <CAJHCu1JkNJxXHXgrYLMA3Z9V_ekUCb370eG0WCUattR3AzBquA@mail.gmail.com>
 <20171207222334.GA8632@openwall.com> <20171211160747.GA24829@openwall.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Tue, 12 Dec 2017 19:01:06 +0100
Message-ID: <CAJHCu1+JrpwU=KdkKtzdsL1Au7TW1uAYTxnWUKVO-W8256Ce7w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v3 0/2] Restrict dangerous open in sticky directories
To: Solar Designer <solar@openwall.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Matthew Wilcox <willy@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

2017-12-11 17:07 GMT+01:00 Solar Designer <solar@openwall.com>:
> On Thu, Dec 07, 2017 at 11:23:34PM +0100, Solar Designer wrote:
> > On Tue, Dec 05, 2017 at 11:13:50AM +0100, Salvatore Mesoraca wrote:
> > > 2017-11-30 20:05 GMT+01:00 Solar Designer <solar@openwall.com>:
> > > > A new thought: a directory that has someone else as its owner is for our
> > > > purposes effectively the same as a group-writable directory.  So maybe
> > > > whatever we'll implement for group-writable directories should also be
> > > > done for directories that have other than the current fsuid as their
> > > > owner. It's currently very uncommon to have directories with the sticky
> > > > bit set that are not at least group-writable, so this will rarely make a
> > > > difference (and when it does, that's just right), but also it provides a
> > > > way to explicitly include any dibrectory under this monitoring (if the
> > > > group-writable protection is on) - e.g., if a sysadmin wants this
> > > > monitoring for users' home directories, they can change permissions for
> > > > those from e.g. 700 to 1700.  This could be handy for development and
> > > > auditing of software, even though in production it could be easily
> > > > circumvented by the directory owner (who can remove the sticky bit,
> > > > which we should document to avoid providing a false sense of security)
> > > > and it won't automatically apply to subdirectories.  It'd also cover
> > > > part of what we intend to achieve later by possibly extending the
> > > > feature to non-sticky directories, where we might also want to treat
> > > > different owner the same as group-writable (without the circumvention).
> > >
> > > Agreed. I'll extend it to also check for the directory owner.
> > > Maybe I could use another bit and make this additional restriction
> > > independent from the "group-writable" one.
> >
> > I'd prefer not to waste a bit on this.  We'll need plenty of bits later
> > on, perhaps also in pairs or (with your suggestion to separate this one)
> > in triplets, and every extra bit complicates the calculation of the
> > bitmask value.
>
> OTOH, if we were to interleave the world and group bits, then maybe
> instead of having the world and group bits as separate we could have a
> two bit number, which naturally leaves us an extra value we'd use for
> owner.  So:
>
> 0 - none
> 1 - world
> 2 - group and world
> 3 - owner, group, and world
>
> This would remove the ability to enable our restrictions for group (and
> owner) while disabling them for world, but that's likely just an obscure
> misconfiguration.
>
> Unfortunately, this is not compatible with my other idea of easily
> extending a tested policy from world onto group by simply assigning the
> same value to the other sysctl.
>
> I'm not sure which of these approaches is cleaner.

I prefer the version with separate sysctls for world/group, it seems more
usable.

Salvatore
