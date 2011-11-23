Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 23 Nov 2011 11:00:04 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
Message-ID: <20111123170004.GA23786@serge-laptop>
References: <1319672956-17114-1-git-send-email-keescook@chromium.org>
 <20111121191811.GA24039@albatros>
 <20111122181310.GA4235@sergelap>
 <20111122192028.GA10458@albatros>
 <20111122201007.GA21722@sergelap>
 <20111123074510.GA2356@albatros>
 <20111123144928.GA3893@hallyn.com>
 <20111123165549.GB3463@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111123165549.GB3463@albatros>
Subject: [kernel-hardening] Re: [RFC] Make Yama pid_ns aware
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Quoting Vasiliy Kulikov (segoon@openwall.com):
> On Wed, Nov 23, 2011 at 14:49 +0000, Serge E. Hallyn wrote:
> > Quoting Vasiliy Kulikov (segoon@openwall.com):
> > > Actually, what concerns me is not ptrace, but symlink/hardling
> > > protection.  There is no interaction between namespaces in case of
> > > containers via symlinks in the basic case.  In case of ptrace I don't
> > > think the child ns may weaken the parent ns - child ns may not access
> > > processes of the parent namespace and everything it may ptrace is
> > > already inside of this ns.
> > 
> > Oh, yes.  If you're saying the symlink protection shouldn't be
> > per-pidns, I agree it seems an odd fit.
> > 
> > How about a version of this patch leaving symlink protection
> > out of pidns (maybe in user ns), and just putting ptrace
> > protection per-pidns?
> 
> I don't think moving symlink/hardling from pid ns to user ns is a good
> idea as user ns is not matured yet.  Also we (Openwall) want to use Yama
> almost as-is in our RHEL6 and RHEL5-based kernels with OpenVZ support
> which don't have user namespaces yet at all (yes, it is not a cause for
> mainline decisions :-) ).
> 
> While user ns is not yet ready, I don't clearly see what is the division
> of security policies among namespaces including user namespace.  I had
> a view that all stuff related to processes (i.e. distinct processes in
> several ways) belongs to pid ns, all net stuff to net ns, etc.  If we
> differentiate user ns and pid ns, only strictly things handling pids
> (like kill(2), procfs, ptrace(2), etc.) belong to pid ns and all other
> process-related stuff (like credentials handling, these symlink/hardling
> things, etc.) belong to user namespaces.
> 
> Can we probably leave them in pid ns for now and when user ns is matured
> just move it from pid ns to user ns?  Is it possible without breaking
> Yama's ABI (I think so)?

That's fine with me.

thanks,
-serge
