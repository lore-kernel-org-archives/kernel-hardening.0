Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 23 Nov 2011 11:45:10 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20111123074510.GA2356@albatros>
References: <1319672956-17114-1-git-send-email-keescook@chromium.org>
 <20111121191811.GA24039@albatros>
 <20111122181310.GA4235@sergelap>
 <20111122192028.GA10458@albatros>
 <20111122201007.GA21722@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122201007.GA21722@sergelap>
Subject: [kernel-hardening] Re: [RFC] Make Yama pid_ns aware
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, "Serge E. Hallyn" <serge@hallyn.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 22, 2011 at 14:10 -0600, Serge Hallyn wrote:
> Quoting Vasiliy Kulikov (segoon@openwall.com):
> > Hi Serge,
> > 
> > On Tue, Nov 22, 2011 at 12:13 -0600, Serge Hallyn wrote:
> > > Quoting Vasiliy Kulikov (segoon@openwall.com):
> > > > As Yama's sysctls are about defining a security policy for the system,
> > > > it is reasonable to define it per container in case of LXC containers
> > > > (or out-of-tree alternatives like OpenVZ).  In my opinion they belong
> > > > to pid namespace.  With per-pid_ns sysctls it is possible to create
> > > > multiple containers with different ptrace, /tmp, etc. policies.
> > > 
> > > tying the ptrace policy to pidns makes some sense, but is it definately
> > > what we want?
> > > 
> > > Is the idea that the container should never be able to bypass the
> > > restrictions, or should root in the container eventually be able to
> > > bypass it as he can on the host?
> > 
> > In-container root already has CAP_SYS_PTRACE, so he can avoid the check
> > even if Yama's ptrace policy is enabled.
> 
> Well, not necessarily  :)  But in general.

This is the question is what in-container root is :-)  Until LXC root is
restricted up to the case where he is unable to get out of the container
in the mainline kernel, I assume we're talking about an abstract entity
which has full control over the container.  It includes stuff like
CAP_CHOWN, CAP_KILL, CAP_SYS_PTRACE, CAP_NET_ADMIN, etc. etc.  The
debatable thing is what parts of CAP_SYS_ADMIN belong to in-container
root, like ability to mount/umount.  But CAP_SYS_PTRACE is surely
belongs to the in-container root.


> But still, is turning this on and off per-container, and leaving it off
> on the host, something people will reasonably want to do?

Probably we need strict rules like ptrace is relaxed iff in both source
ns and dest ns ptrace is relaxed.


> I'm just
> wondering whether adding the extra data on the pidns is worth it.  It's
> fine if it is, but I'm having a hard time imagining someone using it
> like that.

We have already very big net_namespace with all kind of per-ns stuff.
Yama's variables don't significantly increase the size of container.


Actually, what concerns me is not ptrace, but symlink/hardling
protection.  There is no interaction between namespaces in case of
containers via symlinks in the basic case.  In case of ptrace I don't
think the child ns may weaken the parent ns - child ns may not access
processes of the parent namespace and everything it may ptrace is
already inside of this ns.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
