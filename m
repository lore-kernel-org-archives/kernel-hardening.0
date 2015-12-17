Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 17 Dec 2015 11:46:35 -0800
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20151217194635.GA23360@kroah.com>
References: <1450364270-12687-1-git-send-email-dave@progbits.org>
 <1450364270-12687-2-git-send-email-dave@progbits.org>
 <20151217171645.GA7495@kroah.com>
 <CAEXv5_j8Bo9u1WUTH2QwYwye+j9270S+rgzjnsvcbojrYW7sfQ@mail.gmail.com>
 <20151217181143.GA18680@kroah.com>
 <CAEXv5_h9nhKcd3_NYYnofOjorovm4NLbLuZoWzAbZKhM5uiEcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEXv5_h9nhKcd3_NYYnofOjorovm4NLbLuZoWzAbZKhM5uiEcg@mail.gmail.com>
Subject: Re: [kernel-hardening][RFC PATCH v2 01/12] x86: add PAX_REFCOUNT
 support
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 17, 2015 at 01:23:15PM -0500, David Windsor wrote:
> Well, pax_report_refcount_overflow is the mechanism for logging
> overflows and for killing the offending process.  Since that's related
> to adding PAX_REFCOUNT protection (not necessarily to just x86,
> though), I put it in this patch.  I suppose I could have made another
> patch for arch-independent changes like this.

Yes please, each patch should only do one specific thing.  This one
seemed to do many different things, using kconfig options that were not
present yet, making the code useless :)

> You are correct that CONFIG_GRKERNSEC and CONFIG_PAX_REFCOUNT aren't
> currently in the kernel, but they are both added in a later patch in
> this series (patch 11/12).  I should have made those changes part of
> this patch, though.  I will update the series and resubmit later.

You can introduce the build option first or last, either is fine, but it
was confusing to see this without anything seemingly relevant to the
new atomic type.

thanks,

greg k-h
