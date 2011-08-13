Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 13 Aug 2011 23:25:30 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110813192530.GB13051@openwall.com>
References: <20110810150257.GA12198@albatros> <20110810154059.GA31860@openwall.com> <20110810162101.GA2833@albatros> <20110810164225.GA32177@openwall.com> <20110812120747.GA14598@albatros> <20110812122343.GA7859@openwall.com> <20110813151220.GA8388@albatros> <20110813151947.GA12495@openwall.com> <20110813165502.GA9328@albatros> <20110813173118.GA1639@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110813173118.GA1639@albatros>
Subject: Re: [kernel-hardening] 32/64 bitness restriction for pid namespace
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Aug 13, 2011 at 09:31:18PM +0400, Vasiliy Kulikov wrote:
> Also, to keep the code clean and small, I think sysctl interface should
> be dropped.  The only use case is locking a live container, which is
> probably a very limited thing.  Also it will fail if any unprivileged task
> already runs a binary of other bitness anyway.
> 
> Do you agree?

Yes.

BTW, another user of this feature may be vsftpd - but I guess it will
simply be enhanced to use our prctl().

Alexander
