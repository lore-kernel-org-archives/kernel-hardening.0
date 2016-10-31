Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 31 Oct 2016 12:22:36 +0100
From: Solar Designer <solar@openwall.com>
Message-ID: <20161031112236.GA6816@openwall.com>
References: <14b76703-8185-dadb-7605-10496331452c@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14b76703-8185-dadb-7605-10496331452c@redhat.com>
Subject: [kernel-hardening] Re: Stack guard canary massaging
To: oss-security@lists.openwall.com
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Oct 31, 2016 at 11:48:45AM +0100, Florian Weimer wrote:
> Sorry for cross-posting.

Sorry to bikeshed, but I think this isn't a kernel-hardening topic at
all, so the thread should continue on oss-security only, please.

Florian, if there's a reason why you think it's kernel-hardening
related, please let me know.  To me, it looks like userspace hardening
that is not even kernel-assisted (at least not directly in this place,
even though the kernel may have helped provide the random numbers).

If your cross-posting was to reach more of the right people, then you
have already done so, and they can join oss-security now. ;-)

Alexander
