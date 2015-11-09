Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 9 Nov 2015 21:09:22 +0000
From: Jason Cooper <kernel-hardening@lakedaemon.net>
Message-ID: <20151109210922.GF20491@io.lakedaemon.net>
References: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com>
 <CAGXu5jK2boq=rSwrdyqyq=B_kZJR2pUQe99+tPBwK+pKEx0X+w@mail.gmail.com>
 <563F4A78.21151.23C6852D@pageexec.freemail.hu>
 <5640E0DD.6040107@labbott.name>
 <20151109182832.GB20491@io.lakedaemon.net>
 <13041.1447095477@turing-police.cc.vt.edu>
 <20151109190224.GD20491@io.lakedaemon.net>
 <CAGagf4d4A8ZN2hVDDUFge78D_AZKFwkh6ZCV9faEZe=DO_fwKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGagf4d4A8ZN2hVDDUFge78D_AZKFwkh6ZCV9faEZe=DO_fwKQ@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: Proposal for kernel self protection
 features
To: Theodore Tso <tytso@google.com>
Cc: kernel-hardening@lists.openwall.com, Emese Revfy <re.emese@gmail.com>, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Greg KH <gregkh@linuxfoundation.org>, Josh Triplett <josh@joshtriplett.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 09, 2015 at 02:11:35PM -0500, Theodore Tso wrote:
> On Mon, Nov 9, 2015 at 2:02 PM, Jason Cooper <
> kernel-hardening@lakedaemon.net> wrote:
> 
> > /var/lib/misc/random-seed has served that role for years, I'm only
> > advocating loading it earlier in the boot process.  It's *much* harder
> > to guess the state of random-seed than the dtb or mac address(es)...
> >
> 
> If the bootloader is willing to reach into the file system, which means (a)
> having a minimal file system layer, like Grub does, and (b) can find the
> block device where the file is found, that's a perfectly *fine*
> implementation.    I'm not sure mobile handset vendors will be all that
> psyched into either using or replicating all of Grub's functionality so it
> could do that, though....

Well, That's why I referred to reading from /boot or from a flash
partition.  Existing bootloaders in the field already have that
capability.  That's how they load the kernel.

thx,

Jason.
