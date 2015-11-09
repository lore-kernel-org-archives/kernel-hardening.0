Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 9 Nov 2015 21:13:41 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
Message-ID: <20151109211341.GA29829@srcf.ucam.org>
References: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com>
 <CAGXu5jK2boq=rSwrdyqyq=B_kZJR2pUQe99+tPBwK+pKEx0X+w@mail.gmail.com>
 <563F4A78.21151.23C6852D@pageexec.freemail.hu>
 <5640E0DD.6040107@labbott.name>
 <20151109182832.GB20491@io.lakedaemon.net>
 <13041.1447095477@turing-police.cc.vt.edu>
 <20151109190224.GD20491@io.lakedaemon.net>
 <CAGagf4d4A8ZN2hVDDUFge78D_AZKFwkh6ZCV9faEZe=DO_fwKQ@mail.gmail.com>
 <20151109210922.GF20491@io.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151109210922.GF20491@io.lakedaemon.net>
Subject: Re: [kernel-hardening] Re: Proposal for kernel self protection
 features
To: kernel-hardening@lists.openwall.com
Cc: Theodore Tso <tytso@google.com>, Emese Revfy <re.emese@gmail.com>, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Greg KH <gregkh@linuxfoundation.org>, Josh Triplett <josh@joshtriplett.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 09, 2015 at 09:09:22PM +0000, Jason Cooper wrote:

> Well, That's why I referred to reading from /boot or from a flash
> partition.  Existing bootloaders in the field already have that
> capability.  That's how they load the kernel.

This doesn't really handle cases like network booting. Most SoCs have 
some kind of RNG, recent x86 has hardware RNG, older x86 frequently has 
an RNG in a TPM. Pulling an entropy seed from the filesystem is a 
reasonable fallback, but we should definitely be thinking of it as a 
fallback - someone with physical access to your system while it's turned 
off may be able to infer the ASLR state for your next boot, for 
instance.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
