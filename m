Date: Sun, 9 Dec 2018 14:25:23 -0700
From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [RFC v1] copy_{to,from}_user(): only inline when !__CHECKER__
Message-ID: <20181209212523.GE30796@cisco>
References: <20181209204449.18906-1-tycho@tycho.ws>
 <20181209210220.GB2217@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181209210220.GB2217@ZenIV.linux.org.uk>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-sparse@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi Al,

On Sun, Dec 09, 2018 at 09:02:21PM +0000, Al Viro wrote:
> On Sun, Dec 09, 2018 at 01:44:49PM -0700, Tycho Andersen wrote:
> > While working on some additional copy_to_user() checks for sparse, I
> > noticed that sparse's current copy_to_user() checks are not triggered. This
> > is because copy_to_user() is declared as __always_inline, and sparse
> > specifically looks for a call instruction to copy_to_user() when it tries
> > to apply the checks.
> > 
> > A quick fix is to explicitly not inline when __CHECKER__ is defined, so
> > that sparse will be able to analyze all the copy_{to,from}_user calls.
> > There may be some refactoring in sparse that we can do to fix this,
> > although it's not immediately obvious to me how, hence the RFC-ness of this
> > patch.
> 
> Which sparse checks do not trigger?  Explain, please - as it is, I had been
> unable to guess what could "specifically looks for a call instruction" refer
> to.

In sparse.c there's check_call_instruction(), which is triggered when
there's an instruction of OP_CALL type in the basic block. This simply
compares against the name of the call target to determine whether or
not to call check_ctu().

I think what's happening here is that the call is getting inlined, and
so the OP_CALL goes away, and check_call_instruction() never gets
called.

Tycho
