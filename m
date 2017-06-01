Date: Fri, 2 Jun 2017 08:56:13 +1000 (AEST)
From: James Morris <jmorris@namei.org>
In-Reply-To: <CAGXu5jKLnn_eqerFYdsygjHM=WngUW=o2e65wgw1fjTM=pxO=Q@mail.gmail.com>
Message-ID: <alpine.LRH.2.20.1706020830520.16910@namei.org>
References: <20170529213800.29438-1-matt@nmatt.com> <20170529213800.29438-3-matt@nmatt.com> <20170529232640.16211960@alans-desktop> <CAFUG7CdDd0Yfegb1S6_wNQzje4EuLE0jPdvOE=uSQL152meyjQ@mail.gmail.com> <3738951f-7a4a-b37f-c695-21a2fcd45f76@schaufler-ca.com>
 <0e078ce7-5b62-f27c-3920-efc2ffdf342b@nmatt.com> <b0a29f23-4154-8f2f-98e7-0942612f0cdc@schaufler-ca.com> <e1c9e4e8-5427-b4b6-aad2-72c88552a6af@nmatt.com> <20170530132427.016053da@alans-desktop> <2ab8580e-bf8e-21bd-6bfa-33e5fa82400b@nmatt.com>
 <20170530235106.11aab25c@alans-desktop> <3bd4ff7b-6f7d-52b0-03f6-026bac79f11f@nmatt.com> <20170531005633.484a2e14@alans-desktop> <CAGXu5j+pqD1082fYDS_dvDB2QNvt9wSz+C7vAhGpMXcJWxoDkw@mail.gmail.com> <6e713105-02db-12e1-68a9-f167fe11d0a9@gmail.com>
 <CAGXu5jKLnn_eqerFYdsygjHM=WngUW=o2e65wgw1fjTM=pxO=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: Re: [kernel-hardening] Re: [PATCH v7 2/2] security: tty: make TIOCSTI
 ioctl require CAP_SYS_ADMIN
To: Kees Cook <keescook@chromium.org>
Cc: lazytyped <lazytyped@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 1 Jun 2017, Kees Cook wrote:

> All of the reasoning here seems to match the link restrictions from 5
> years ago: a crappy API (sticky bit) is not handled by userspace (open
> /tmp/$$!) and people get attacked. The solution was a sysctl to enable
> the link restrictions that killed the entire class of the common
> attack (though it didn't solve especially egregious bad uses, much

This is the problem -- it doesn't really eliminate the underlying issue.

A better solution (in this case) was to implement a new API which 
addresses the issue at an architectural level, i.e. namespace-based 
private /tmp views, and encourage its adoption.

> like the TIOCSTI fix). Every distro enabled the sysctl, and, while the
> data is noisy, looking a CVEs matching "/tmp symlink", the numbers
> drop from 2013 and later (with none yet for 2017).

I wonder how much of this is due to the sysctl vs. adoption of private 
/tmp, and what may be lurking in the "egregious bad uses" category for 
future CVEs.  And obviously we don't know what various folk may have up 
their sleeves, if anything.


-- 
James Morris
<jmorris@namei.org>
