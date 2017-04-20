Date: Thu, 20 Apr 2017 10:24:59 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
Message-ID: <20170420152459.GA14726@mail.hallyn.com>
References: <20170419034526.18565-1-matt@nmatt.com>
 <20170419045813.GA17990@mail.hallyn.com>
 <a6b8f9ab-d5f8-51fb-0481-89907c43289f@nmatt.com>
 <20170419235342.GA2305@mail.hallyn.com>
 <59d67e42-3532-6001-91cb-067bff1eec64@nmatt.com>
 <20170420151928.GA14559@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170420151928.GA14559@mail.hallyn.com>
Subject: Re: [kernel-hardening] Re: [PATCH] make TIOCSTI ioctl require
 CAP_SYS_ADMIN
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Matt Brown <matt@nmatt.com>, jmorris@namei.org, gregkh@linuxfoundation.org, jslaby@suse.com, akpm@linux-foundation.org, jannh@google.com, keescook@chromium.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Quoting Serge E. Hallyn (serge@hallyn.com):
> Quoting Matt Brown (matt@nmatt.com):
> > On 04/19/2017 07:53 PM, Serge E. Hallyn wrote:
> > >Quoting Matt Brown (matt@nmatt.com):
> > >>On 04/19/2017 12:58 AM, Serge E. Hallyn wrote:
> > >>>On Tue, Apr 18, 2017 at 11:45:26PM -0400, Matt Brown wrote:
> > >>>>This patch reproduces GRKERNSEC_HARDEN_TTY functionality from the grsecurity
> > >>>>project in-kernel.
> > >>>>
> > >>>>This will create the Kconfig SECURITY_TIOCSTI_RESTRICT and the corresponding
> > >>>>sysctl kernel.tiocsti_restrict that, when activated, restrict all TIOCSTI
> > >>>>ioctl calls from non CAP_SYS_ADMIN users.
> > >>>>
> > >>>>Possible effects on userland:
> > >>>>
> > >>>>There could be a few user programs that would be effected by this
> > >>>>change.
> > >>>>See: <https://codesearch.debian.net/search?q=ioctl%5C%28.*TIOCSTI>
> > >>>>notable programs are: agetty, csh, xemacs and tcsh
> > >>>>
> > >>>>However, I still believe that this change is worth it given that the
> > >>>>Kconfig defaults to n. This will be a feature that is turned on for the
> > >>>
> > >>>It's not worthless, but note that for instance before this was fixed
> > >>>in lxc, this patch would not have helped with escapes from privileged
> > >>>containers.
> > >>>
> > >>
> > >>I assume you are talking about this CVE:
> > >>https://bugzilla.redhat.com/show_bug.cgi?id=1411256
> > >>
> > >>In retrospect, is there any way that an escape from a privileged
> > >>container with the this bug could have been prevented?
> > >
> > >I don't know, that's what I was probing for.  Detecting that the pgrp
> > >or session - heck, the pid namespace - has changed would seem like a
> > >good indicator that it shouldn't be able to push.
> > >
> > 
> > pgrp and session won't do because in the case we are discussing
> > current->signal->tty is the same as tty.
> > 
> > This is the current check that is already in place:
> >  | if ((current->signal->tty != tty) && !capable(CAP_SYS_ADMIN))
> >  | 	return -EPERM;
> 
> Yeah...
> 
> > The only thing I could find to detect the tty message coming from a
> > container is as follows:
> >  | task_active_pid_ns(current)->level
> > 
> > This will be zero when run on the host, but 1 when run inside a
> > container. However this is very much a hack and could probably break
> > some userland stuff where there are multiple levels of namespaces.
> 
> Yes.  This is also however why I don't like the current patch, because
> capable() will never be true in a container, so nested containers break.
> 
> What does current->signal->tty->pgrp actually point to?  Can we take
> it to be the pgrp which opened it?  Could we check
> ns_capable(current_pid_ns()->user_ns, CAP_whatever) and get a meaningful
> answer?
> 

Ok I see that's meaningless, you can't get pidns from pid.  We could
instead add a user_ns *owner to the struct tty and store the user_ns
of the task which opened it.  It's more invasive, but also more
meaningful.
