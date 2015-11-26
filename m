Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAJpd-bFvTNQK=qGCPdnB1ec=yJ+jZuzaoR9pNbn01pgim=0aLg@mail.gmail.com>
References: <CAJpd-bFvTNQK=qGCPdnB1ec=yJ+jZuzaoR9pNbn01pgim=0aLg@mail.gmail.com>
From: comex <comexk@gmail.com>
Date: Thu, 26 Nov 2015 02:43:31 -0500
Message-ID: <CAPM5UJ2G_hWRYs-J3qsRV1E=aBZqPOacntT2ZA5zcNfZeibHzQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] On techniques for preventing commit_creds()
 user-space abuse
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 25, 2015 at 6:14 PM, Salva Peir=C3=B3 <speirofr@gmail.com> wrot=
e:
> - *Indirect jump*
> An attacker can perform an indirect jump to a kernel location that does
> the commit_creds() for him, but it complicates the task of the
> attacker. To prevent indirect calls check the rest of the stack trace.

The added complication of indirection is minimal, and checking the
frame pointer/return address chain on the stack would be far from
sufficient to prevent it: even if you had full control flow integrity
on returns (see e.g. RAP), if the attacker was already executing
arbitrary code, they could overwrite the whole stack to simulate a
call stack that would normally be allowed to call commit_creds and
won't crash on return, e.g. setuid returning to userland.

> - *Direct override*
> Another route to bypass would be to figure out the location of the
> process creds in memory, and perform the change directly in memory,
> but AFAIK SMAP and its ARM equivalent would deter this route.

SMEP (not SMAP) already makes it impossible to directly execute code
from userspace mapped addresses.  SMAP prevents accessing those
addresses, but has no effect on kernel mapped addresses such as the
data structures containing credentials.

In general there's not much point trying to defend against an attacker
who is already running arbitrary code in kernel mode.  Even executing
a ROP chain, once the attacker gets past any initial hurdles such as
stack pivoting, is pretty much game over (the possibility of it being
complicated to find gadgets with unusual instruction sequences, find a
large number of gadgets, or use a long chain of them /might/ make some
additional measures valuable, but not very - e.g. [1]); true code
execution generally makes working around any 'harassment' measures
trivial.

[1] http://vulnfactory.org/blog/2011/09/21/defeating-windows-8-rop-mitigati=
on/
