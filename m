Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 5 Oct 2016 22:23:08 +0200
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20161005202308.GA20923@kroah.com>
References: <CAKv+Gu_7AdRk7O-Mt8oS=t6prJY56=nS5CS1stgfqHzJ--YD9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_7AdRk7O-Mt8oS=t6prJY56=nS5CS1stgfqHzJ--YD9Q@mail.gmail.com>
Subject: Re: [kernel-hardening] initcall randomization
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@fedoraproject.org>, Mark Rutland <mark.rutland@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 05, 2016 at 06:09:01PM +0100, Ard Biesheuvel wrote:
> Did anyone ever look into whether there is anything to gain in terms
> of hardening from randomizing the order initcalls are issued at each
> level? I know entropy is hard to come by at this stage, but on recent
> UEFI systems, this is something we could potentially solve
> generically. (It may uncover some breakage as well, but only hidden
> breakage that could already surface at any time due to linker changes,
> so I think this could serve as a diagnostic option as well)

We rely on link-order init call dependancy in the kernel a lot, so be
very careful about reording them.

> Since boot time mappings are often performed in initcalls, this could
> potentially reduce the predictability of the layout of the virtual
> kernel space. But before I start experimenting with this, I thought
> I'd ask if anyone has ever looked into this.

I think you will break things, try it yourself and see :)

good luck!

greg k-h
