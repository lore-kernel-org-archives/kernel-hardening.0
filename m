Date: Mon, 8 Jan 2018 09:47:33 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
Message-ID: <20180108154733.GA29416@mail.hallyn.com>
References: <20171205223052.12687-1-mahesh@bandewar.net>
 <CAF2d9jit74_VCdD-pEFy3bJo2W1-0cDo0BOJC5beJiy8yFPCWg@mail.gmail.com>
 <alpine.LFD.2.20.1712301931360.24310@localhost>
 <CAF2d9jiPYvMN=_guoZHyTA5FmMgaJb5mtxroi5D9NvcNrHc5gg@mail.gmail.com>
 <alpine.LFD.2.20.1801081131190.8436@localhost>
 <20180108062452.GA21717@mail.hallyn.com>
 <alpine.LFD.2.20.1801082040180.12014@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.20.1801082040180.12014@localhost>
Subject: [kernel-hardening] Re: [PATCHv3 0/2] capability controlled user-namespaces
To: James Morris <james.l.morris@oracle.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Mahesh Bandewar =?utf-8?B?KOCkruCkueClh+CktiDgpKzgpILgpKHgpYfgpLXgpL4=?= =?utf-8?B?4KSwKQ==?= <maheshb@google.com>, LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Kernel-hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>, Mahesh Bandewar <mahesh@bandewar.net>
List-ID: <kernel-hardening.lists.openwall.com>

Quoting James Morris (james.l.morris@oracle.com):
> On Mon, 8 Jan 2018, Serge E. Hallyn wrote:
> 
> > > Also, why do we need the concept of a controlled user-ns at all, if the 
> > > default whitelist maintains existing behavior?
> > 
> > In past discussions two uses have been brought up:
> > 
> > 1. if an 0-day is discovered which is exacerbated by a specific
> > privilege in user namespaces, that privilege could be turned off until a
> > reboot with a fixed kernel is scheduled, without fully disabling all
> > containers.
> > 
> > 2. some systems may be specifically designed to run software which
> > only requires a few capabilities in a userns.  In that case all others
> > could be disabled.
> > 
> 
> I meant in terms of "marking" a user ns as "controlled" type -- it's 
> unnecessary jargon from an end user point of view.

Ah, yes, that was my point in

http://lkml.iu.edu/hypermail/linux/kernel/1711.1/01845.html
and
http://lkml.iu.edu/hypermail/linux/kernel/1711.1/02276.html

> This may happen internally but don't make it a special case with a 
> different name and don't bother users with internal concepts: simply 
> implement capability whitelists with the default having equivalent 
> behavior of everything allowed.  Then, document the semantics of the 
> whitelist in terms of inheritance etc., as a feature of user namespaces, 
> not as a "type" of user namespace.

The problem with making them inheritable is that an adversarial user
can just create a user namespace at boot that sits and waits for an
0day to be published, then log in and attach to that namespace later,
since it has already inherited the open whitelist.

It feels like there must be some other approach that doesn't feel as...
band-aid-y as this does, but I'm not sure what.
