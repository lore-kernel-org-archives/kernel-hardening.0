Subject: Re: [kernel-hardening] [PATCH 4/6] Protectable Memory
From: Igor Stoppa <igor.stoppa@huawei.com>
References: <20180124175631.22925-1-igor.stoppa@huawei.com>
 <20180124175631.22925-5-igor.stoppa@huawei.com>
 <CAG48ez0JRU8Nmn7jLBVoy6SMMrcj46R0_R30Lcyouc4R9igi-g@mail.gmail.com>
 <20180126053542.GA30189@bombadil.infradead.org>
 <alpine.DEB.2.20.1802021236510.31548@nuc-kabylake>
 <f2ddaed0-313e-8664-8a26-9d10b66ed0c5@huawei.com>
Message-ID: <b75b5903-0177-8ad9-5c2b-fc63438fb5f2@huawei.com>
Date: Sat, 3 Feb 2018 21:57:13 +0200
MIME-Version: 1.0
In-Reply-To: <f2ddaed0-313e-8664-8a26-9d10b66ed0c5@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: Christopher Lameter <cl@linux.com>, Matthew Wilcox <willy@infradead.org>, Boris Lukashev <blukashev@sempervictus.com>
Cc: Jann Horn <jannh@google.com>, jglisse@redhat.com, Kees Cook <keescook@chromium.org>, Michal Hocko <mhocko@kernel.org>, Laura Abbott <labbott@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-security-module@vger.kernel.org, linux-mm@kvack.org, kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

>> On Thu, 25 Jan 2018, Matthew Wilcox wrote:

>>> It's worth having a discussion about whether we want the pmalloc API
>>> or whether we want a slab-based API.  
I'd love to have some feedback specifically about the API.

I have also some idea about userspace and how to extend the pmalloc
concept to it:

http://www.openwall.com/lists/kernel-hardening/2018/01/30/20

I'll be AFK intermittently for about 2 weeks, so i might not be able to
reply immediately, but from my perspective this would be just the
beginning of a broader hardening of both kernel and userspace that I'd
like to pursue.

--
igor
