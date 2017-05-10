Date: Wed, 10 May 2017 21:29:20 +0100
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Message-ID: <20170510212920.7f6bc5e6@alans-desktop>
In-Reply-To: <20170505232018.28846-1-matt@nmatt.com>
References: <20170505232018.28846-1-matt@nmatt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v6 0/2] security: tty: make TIOCSTI ioctl require
 CAP_SYS_ADMIN
To: Matt Brown <matt@nmatt.com>
Cc: serge@hallyn.com, gregkh@linuxfoundation.org, jslaby@suse.com, akpm@linux-foundation.org, jannh@google.com, keescook@chromium.org, jmorris@namei.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri,  5 May 2017 19:20:16 -0400
Matt Brown <matt@nmatt.com> wrote:

> This patchset introduces the tiocsti_restrict sysctl, whose default is
> controlled via CONFIG_SECURITY_TIOCSTI_RESTRICT. When activated, this
> control restricts all TIOCSTI ioctl calls from non CAP_SYS_ADMIN users.
> 
> This patch was inspired from GRKERNSEC_HARDEN_TTY.
> 
> This patch would have prevented
> https://bugzilla.redhat.com/show_bug.cgi?id=1411256 under the following
> conditions:
> * non-privileged container
> * container run inside new user namespace
> 
> Possible effects on userland:
> 
> There could be a few user programs that would be effected by this
> change.
> See: <https://codesearch.debian.net/search?q=ioctl%5C%28.*TIOCSTI>
> notable programs are: agetty, csh, xemacs and tcsh
> 
> However, I still believe that this change is worth it given that the
> Kconfig defaults to n. 

And it still doesn't deal with the fact that there are hundreds of other
ways to annoy the owner of a tty if it's passed to a lower privilege
child from framebuffer reprogramming through keyboard remaps.

The proper way to handle those cases is to create a pty/tty pair and use
that. Your patch is pure snake oil and if anything implies safety that
doesn't exist.

In addition your change to allow it to be used by root in the guest
completely invalidates any protection you have because I can push

"rm -rf /\n"

as root in my namespace and exit

The tty buffers are not flushed across the context change so the shell
you return to gets the input and oh dear....

Alan
