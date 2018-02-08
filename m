Date: Thu, 8 Feb 2018 11:42:35 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC] Warn the user when they could overflow mapcount
Message-ID: <20180208194235.GA3424@bombadil.infradead.org>
References: <20180208021112.GB14918@bombadil.infradead.org>
 <CAG48ez2-MTJ2YrS5fPZi19RY6P_6NWuK1U5CcQpJ25=xrGSy_A@mail.gmail.com>
 <CA+DvKQLHDR0s=6r4uiHL8kw2_PnfJcwYfPxgQOmuLbc=5k39+g@mail.gmail.com>
 <20180208185648.GB9524@bombadil.infradead.org>
 <CA+DvKQLHcFc3+kW_SnD6hs53yyD5Zi+uAeSgDMm1tRzxqy-Opg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+DvKQLHcFc3+kW_SnD6hs53yyD5Zi+uAeSgDMm1tRzxqy-Opg@mail.gmail.com>
To: Daniel Micay <danielmicay@gmail.com>
Cc: Jann Horn <jannh@google.com>, linux-mm@kvack.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 08, 2018 at 02:33:58PM -0500, Daniel Micay wrote:
> I don't think the kernel can get away with the current approach.
> Object sizes and counts on 64-bit should be 64-bit unless there's a
> verifiable reason they can get away with 32-bit. Having it use leak
> memory isn't okay, just much less bad than vulnerabilities exploitable
> beyond just denial of service.
> 
> Every 32-bit reference count should probably have a short comment
> explaining why it can't overflow on 64-bit... if that can't be written
> or it's too complicated to demonstrate, it probably needs to be
> 64-bit. It's one of many pervasive forms of integer overflows in the
> kernel... :(

Expanding _mapcount to 64-bit, and for that matter expanding _refcount
to 64-bit too is going to have a severe effect on memory consumption.
It'll take an extra 8 bytes per page of memory in your system, so 2GB
for a machine with 1TB memory (earlier we established this attack isn't
feasible for a machine with less than 1TB).

It's not something a user is going to hit accidentally; it is only
relevant to an attack scenario.  That's a lot of memory to sacrifice to
defray this attack.  I think we should be able to do better.
