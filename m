MIME-Version: 1.0
In-Reply-To: <20180208185648.GB9524@bombadil.infradead.org>
References: <20180208021112.GB14918@bombadil.infradead.org>
 <CAG48ez2-MTJ2YrS5fPZi19RY6P_6NWuK1U5CcQpJ25=xrGSy_A@mail.gmail.com>
 <CA+DvKQLHDR0s=6r4uiHL8kw2_PnfJcwYfPxgQOmuLbc=5k39+g@mail.gmail.com> <20180208185648.GB9524@bombadil.infradead.org>
From: Daniel Micay <danielmicay@gmail.com>
Date: Thu, 8 Feb 2018 14:33:58 -0500
Message-ID: <CA+DvKQLHcFc3+kW_SnD6hs53yyD5Zi+uAeSgDMm1tRzxqy-Opg@mail.gmail.com>
Subject: Re: [RFC] Warn the user when they could overflow mapcount
Content-Type: text/plain; charset="UTF-8"
To: Matthew Wilcox <willy@infradead.org>
Cc: Jann Horn <jannh@google.com>, linux-mm@kvack.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

I don't think the kernel can get away with the current approach.
Object sizes and counts on 64-bit should be 64-bit unless there's a
verifiable reason they can get away with 32-bit. Having it use leak
memory isn't okay, just much less bad than vulnerabilities exploitable
beyond just denial of service.

Every 32-bit reference count should probably have a short comment
explaining why it can't overflow on 64-bit... if that can't be written
or it's too complicated to demonstrate, it probably needs to be
64-bit. It's one of many pervasive forms of integer overflows in the
kernel... :(
