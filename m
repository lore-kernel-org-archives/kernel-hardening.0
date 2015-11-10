Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 10 Nov 2015 11:47:47 +0100
From: Marcus Meissner <meissner@suse.de>
Message-ID: <20151110104747.GG25737@suse.de>
References: <CAGXu5jK2boq=rSwrdyqyq=B_kZJR2pUQe99+tPBwK+pKEx0X+w@mail.gmail.com>
 <563F4A78.21151.23C6852D@pageexec.freemail.hu>
 <5640E0DD.6040107@labbott.name>
 <20151109182832.GB20491@io.lakedaemon.net>
 <13041.1447095477@turing-police.cc.vt.edu>
 <20151109190224.GD20491@io.lakedaemon.net>
 <CAGagf4d4A8ZN2hVDDUFge78D_AZKFwkh6ZCV9faEZe=DO_fwKQ@mail.gmail.com>
 <20151109210922.GF20491@io.lakedaemon.net>
 <20151109211341.GA29829@srcf.ucam.org>
 <1447152151.29239.0.camel@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1447152151.29239.0.camel@debian.org>
Subject: Re: [kernel-hardening] Re: Proposal for kernel self protection
 features
To: kernel-hardening@lists.openwall.com
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Theodore Tso <tytso@google.com>, Emese Revfy <re.emese@gmail.com>, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Greg KH <gregkh@linuxfoundation.org>, Josh Triplett <josh@joshtriplett.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 10, 2015 at 11:42:31AM +0100, Yves-Alexis Perez wrote:
> On lun., 2015-11-09 at 21:13 +0000, Matthew Garrett wrote:
> > On Mon, Nov 09, 2015 at 09:09:22PM +0000, Jason Cooper wrote:
> > 
> > > Well, That's why I referred to reading from /boot or from a flash
> > > partition.  Existing bootloaders in the field already have that
> > > capability.  That's how they load the kernel.
> > 
> > This doesn't really handle cases like network booting. Most SoCs have 
> > some kind of RNG, recent x86 has hardware RNG, older x86 frequently has 
> > an RNG in a TPM. Pulling an entropy seed from the filesystem is a 
> > reasonable fallback, but we should definitely be thinking of it as a 
> > fallback - someone with physical access to your system while it's turned 
> > off may be able to infer the ASLR state for your next boot, for 
> > instance.
> 
> About the TPM RNG: I was definitely interested in the “get entropy from
> TPM” kind of thing for my laptop (even though I think my laptop would
> not be the worst place to find entropy). Right now I'm using rng-tools
> to read from /dev/hwrng (handled by tpm_rng module), which then feeds
> entropy to /dev/random (or maybe directly using the RND ioctls).
> 
> Do you think bypassing userland completely in order to be able to feed
> that entropy even before userland is completely initialized would be
> helpful?

The kernel has infrastructure for this (feeding hardware random generators
into the random pool) these days.

e.g.
drivers/char/hw_random/tpm-rng.c

How "good" the generator is is determined by  the "quality" member of
the hwrng struct.

(It seems only virtio-rng.c sets one, but more of them could be reviewed
and used.)

Ciao, Marcus
