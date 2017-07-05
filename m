Date: Wed, 5 Jul 2017 08:35:21 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20170705123521.hr662wo5c2ksc3se@thunk.org>
References: <20170606174804.31124-1-Jason@zx2c4.com>
 <2639082.PtrrGWOPPL@positron.chronox.de>
 <1498440189.26123.85.camel@haakon3.risingtidesystems.com>
 <1678474.GnYBdSlWgs@tauon.chronox.de>
 <595C8F4F020000A100026F29@gwsmtp1.uni-regensburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <595C8F4F020000A100026F29@gwsmtp1.uni-regensburg.de>
Subject: Re: Antw: Re: [kernel-hardening] Re: [PATCH v4 06/13] iscsi: ensure
 RNG is seeded before use
To: Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>
Cc: "Nicholas A.Bellinger" <nab@linux-iscsi.org>, David Miller <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>, open-iscsi <open-iscsi@googlegroups.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Chris Leech <cleech@redhat.com>, Lee Duncan <lduncan@suse.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, linux-kernel@vger.kernel.org, target-devel <target-devel@vger.kernel.org>, "Jason A.Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jul 05, 2017 at 09:03:43AM +0200, Ulrich Windl wrote:
> > Note, during the development of my /dev/random implementation, I added the 
> > getrandom-like blocking behavior to /dev/urandom (which is the equivalent to
> > Jason's patch except that it applies to user space). The boot process locked
> 
> I thought reads from urandom never block by definition. An older manual page
> (man urandom) also says: "A  read  from  the  /dev/urandom device will not
> block waiting for more entropy."

As I said in my original message, I *tried* this as an experiment.
Because lots of security-obsessed people were disputing my
intelligence, my judgement, and in some cases, my paternity becuase I
wouldn't change /dev/urandom not to block.

So I did the experiment so I could give them hard data about why we
couldn't go down that path.

> > up since systemd wanted data from /dev/urandom while it processed the 
> > initramfs. As it did not get any, the boot process did not commence that 
> > could 
> > deliver new events to be picked up by the RNG.

And indeed, making this change brick'ed at least one version of Ubuntu
and one version of CeroWRT, as reported by the kernel's 0-day testing
system.  As a result, this patch (which was always a proof of concept,
not anything I thought had any chance of going upstream), was dropped.

Since in the kernel, We Do Not Break Backwards Compatibility, this is
why we have a new interface --- getrandom(2) --- instead of changing
an existing interface.  (Well, there were multiple good reasons for
getrandom, but this was definitely one of them.)

	    	       	   	    - Ted
