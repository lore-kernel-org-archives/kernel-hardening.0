Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 7 Sep 2011 13:43:35 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110907094335.GA17834@openwall.com>
References: <20110812105824.GA7141@openwall.com> <20110825171934.GA3044@albatros> <20110902182929.GA23848@openwall.com> <20110903111849.GA2743@albatros> <20110903235728.GD29169@openwall.com> <20110905124647.GA10247@albatros> <20110906050554.GA3889@openwall.com> <20110907090900.GA3910@albatros> <20110907093036.GA17693@openwall.com> <20110907093411.GA4752@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110907093411.GA4752@albatros>
Subject: Re: [kernel-hardening] [RFC] x86, mm: start mmap allocation for libs from low addresses
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Wed, Sep 07, 2011 at 01:34:11PM +0400, Vasiliy Kulikov wrote:
> On Wed, Sep 07, 2011 at 13:30 +0400, Solar Designer wrote:
> > What if mmap_min_addr set really low, or is even 0?  I think we want to
> > skip low addresses even if processes are permitted to use those.
> > (Permitted does not mean encouraged.)  So how about ASCII_ARMOR_MIN_ADDR
> > 0x19000 (100 KB) when !CONFIG_VM86?
> 
> Are you talking about safety with NULL pointer dereferencing?

Yes.  Besides deliberate attacks, we want inadvertent NULL pointer
dereferences to be detected by the kernel as such.  This wouldn't happen
if the kernel itself happens to map something at NULL in almost every
process just because someone set mmap_min_addr to 0 e.g. to be able to
occasionally run a certain userspace app that needs that.

Then, there may be attack scenarios where the attacker is not able to
invoke mmap() in the process via which the attack on the kernel is
initiated - e.g., some daemon process over which the attacker has only
partial control over a certain protocol.  Thus, low mmap_min_addr
wouldn't be directly exploitable by the attacker, and we shouldn't be
making matters worse with this patch.

Alexander
