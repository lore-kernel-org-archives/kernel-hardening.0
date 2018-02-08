MIME-Version: 1.0
In-Reply-To: <20180208194235.GA3424@bombadil.infradead.org>
References: <20180208021112.GB14918@bombadil.infradead.org>
 <CAG48ez2-MTJ2YrS5fPZi19RY6P_6NWuK1U5CcQpJ25=xrGSy_A@mail.gmail.com>
 <CA+DvKQLHDR0s=6r4uiHL8kw2_PnfJcwYfPxgQOmuLbc=5k39+g@mail.gmail.com>
 <20180208185648.GB9524@bombadil.infradead.org> <CA+DvKQLHcFc3+kW_SnD6hs53yyD5Zi+uAeSgDMm1tRzxqy-Opg@mail.gmail.com>
 <20180208194235.GA3424@bombadil.infradead.org>
From: Daniel Micay <danielmicay@gmail.com>
Date: Thu, 8 Feb 2018 14:48:52 -0500
Message-ID: <CA+DvKQKba0iU+tydbmGkAJsxCxazORDnuoe32sy-2nggyagUxQ@mail.gmail.com>
Subject: Re: [RFC] Warn the user when they could overflow mapcount
Content-Type: text/plain; charset="UTF-8"
To: Matthew Wilcox <willy@infradead.org>
Cc: Jann Horn <jannh@google.com>, linux-mm@kvack.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

I guess it could saturate and then switch to tracking the count via an
object pointer -> count mapping with a global lock? Whatever the
solution is should probably be a generic one since it's a recurring
issue.
