Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 23 Nov 2011 14:49:28 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
Message-ID: <20111123144928.GA3893@hallyn.com>
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
Cc: Serge Hallyn <serge.hallyn@canonical.com>, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Quoting Vasiliy Kulikov (segoon@openwall.com):
> Actually, what concerns me is not ptrace, but symlink/hardling
> protection.  There is no interaction between namespaces in case of
> containers via symlinks in the basic case.  In case of ptrace I don't
> think the child ns may weaken the parent ns - child ns may not access
> processes of the parent namespace and everything it may ptrace is
> already inside of this ns.

Oh, yes.  If you're saying the symlink protection shouldn't be
per-pidns, I agree it seems an odd fit.

How about a version of this patch leaving symlink protection
out of pidns (maybe in user ns), and just putting ptrace
protection per-pidns?

-serge
