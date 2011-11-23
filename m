Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 23 Nov 2011 08:41:56 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
Message-ID: <20111123144156.GA1661@sergelap>
References: <1319672956-17114-1-git-send-email-keescook@chromium.org>
 <20111121191811.GA24039@albatros>
 <20111122181310.GA4235@sergelap>
 <20111122192028.GA10458@albatros>
 <20111122201007.GA21722@sergelap>
 <20111123074510.GA2356@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111123074510.GA2356@albatros>
Subject: [kernel-hardening] Re: [RFC] Make Yama pid_ns aware
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, "Serge E. Hallyn" <serge@hallyn.com>
List-ID: <kernel-hardening.lists.openwall.com>

Quoting Vasiliy Kulikov (segoon@openwall.com):
> > But still, is turning this on and off per-container, and leaving it off
> > on the host, something people will reasonably want to do?
> 
> Probably we need strict rules like ptrace is relaxed iff in both source
> ns and dest ns ptrace is relaxed.

But will people want that?

> > I'm just
> > wondering whether adding the extra data on the pidns is worth it.  It's
> > fine if it is, but I'm having a hard time imagining someone using it
> > like that.
> 
> We have already very big net_namespace with all kind of per-ns stuff.
> Yama's variables don't significantly increase the size of container.

Yes I'm not complaining about the extra host memory usage, just trying
to make sure we don't pollute the pidns struct with something noone
wants

> Actually, what concerns me is not ptrace, but symlink/hardling
> protection.  There is no interaction between namespaces in case of
> containers via symlinks in the basic case.  In case of ptrace I don't
> think the child ns may weaken the parent ns - child ns may not access
> processes of the parent namespace and everything it may ptrace is
> already inside of this ns.

User namespace being respected by VFS will help symlinking.

-serge
