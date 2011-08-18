Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 18 Aug 2011 14:34:32 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110818103432.GA448@openwall.com>
References: <20110812122343.GA7859@openwall.com> <20110813151220.GA8388@albatros> <20110813151947.GA12495@openwall.com> <20110813165502.GA9328@albatros> <20110814095010.GA14443@openwall.com> <20110814101658.GA20509@albatros> <20110814112922.GA15012@openwall.com> <20110814115549.GA3423@albatros> <20110814120448.GA15372@openwall.com> <20110815153836.GA6060@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110815153836.GA6060@albatros>
Subject: Re: [kernel-hardening] 32/64 bitness restriction for pid namespace
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Mon, Aug 15, 2011 at 07:38:36PM +0400, Vasiliy Kulikov wrote:
> Given the latest discussion on LKML we're unlikely to push the
> restriction upstream.  So, I'm posting the patch here.

I feel that it may be desirable to post the patch to LKML as well - not
as RFC, nor PATCH anymore, but merely for the sake of completeness.  We
promised a better patch, so we should provide it, even if we know it's
NAK'ed.  Just word your message such that no one gets the impression
we're pushing this regardless of it having been NAK'ed.  Mention
explicitly that given the discussion so far you do not expect this to be
applied, but you are posting this for the sake of completeness - to have
this proposal archived in full, including the actual patch.

Does this make sense to you?

Alexander
