Date: Sat, 22 Dec 2018 00:17:39 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 01/12] x86_64: memset_user()
Message-ID: <20181221211739.GD8441@uranus>
References: <20181221181423.20455-1-igor.stoppa@huawei.com>
 <20181221181423.20455-2-igor.stoppa@huawei.com>
 <20181221182515.GF10600@bombadil.infradead.org>
 <20181221200546.GA8441@uranus>
 <20181221202946.GJ10600@bombadil.infradead.org>
 <20181221204616.GC8441@uranus>
 <20181221210721.GK10600@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181221210721.GK10600@bombadil.infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Igor Stoppa <igor.stoppa@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Thiago Jung Bauermann <bauerman@linux.ibm.com>, igor.stoppa@huawei.com, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Ahmed Soliman <ahmedsoliman@mena.vt.edu>, linux-integrity@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Dec 21, 2018 at 01:07:21PM -0800, Matthew Wilcox wrote:
> On Fri, Dec 21, 2018 at 11:46:16PM +0300, Cyrill Gorcunov wrote:
> > Cast to unsigned char is needed in any case. And as far as I remember
> > we've been using this multiplication trick for a really long time
> > in x86 land. I'm out of sources right now but it should be somewhere
> > in assembly libs.
> 
> x86 isn't the only CPU.  Some CPUs have slow multiplies but fast shifts.

This is x86-64 patch, not some generic code.

> Also loading 0x0101010101010101 into a register may be inefficient on
> some CPUs.

It is pretty efficient on x86-64. Moreover the self dependents as
a |= a << b is a source for data hazards inside cpu engine. Anyway
i'm not going to insist, just wanted to remind about such trick.
Up to you what to choose.
