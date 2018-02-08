Date: Thu, 8 Feb 2018 10:56:48 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC] Warn the user when they could overflow mapcount
Message-ID: <20180208185648.GB9524@bombadil.infradead.org>
References: <20180208021112.GB14918@bombadil.infradead.org>
 <CAG48ez2-MTJ2YrS5fPZi19RY6P_6NWuK1U5CcQpJ25=xrGSy_A@mail.gmail.com>
 <CA+DvKQLHDR0s=6r4uiHL8kw2_PnfJcwYfPxgQOmuLbc=5k39+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+DvKQLHDR0s=6r4uiHL8kw2_PnfJcwYfPxgQOmuLbc=5k39+g@mail.gmail.com>
To: Daniel Micay <danielmicay@gmail.com>
Cc: Jann Horn <jannh@google.com>, linux-mm@kvack.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 08, 2018 at 01:05:33PM -0500, Daniel Micay wrote:
> The standard map_max_count / pid_max are very low and there are many
> situations where either or both need to be raised.

[snip good reasons]

> I do think the default value in the documentation should be fixed but
> if there's a clear problem with raising these it really needs to be
> fixed. Google either of the sysctl names and look at all the people
> running into issues and needing to raise them. It's only going to
> become more common to raise these with people trying to use lots of
> fine-grained sandboxing. Process-per-request is back in style.

So we should make the count saturate instead, then?  That's going to
be interesting.
