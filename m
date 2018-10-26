Date: Fri, 26 Oct 2018 03:17:07 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 13/17] prmem: linked list: disable layout randomization
Message-ID: <20181026101707.GO25444@bombadil.infradead.org>
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
 <20181023213504.28905-14-igor.stoppa@huawei.com>
 <20181026093205.GD3159@worktop.c.hoisthospitality.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181026093205.GD3159@worktop.c.hoisthospitality.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Igor Stoppa <igor.stoppa@gmail.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, kernel-hardening@lists.openwall.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, igor.stoppa@huawei.com, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexey Dobriyan <adobriyan@gmail.com>, Pekka Enberg <penberg@kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Lihao Liang <lianglihao@huawei.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Oct 26, 2018 at 11:32:05AM +0200, Peter Zijlstra wrote:
> On Wed, Oct 24, 2018 at 12:35:00AM +0300, Igor Stoppa wrote:
> > Some of the data structures used in list management are composed by two
> > pointers. Since the kernel is now configured by default to randomize the
> > layout of data structures soleley composed by pointers, this might
> > prevent correct type punning between these structures and their write
> > rare counterpart.
> 
> 'might' doesn't really work for me. Either it does or it does not.

He means "Depending on the random number generator, the two pointers
might be AB or BA.  If they're of opposite polarity (50% of the time),
it _will_ break, and 50% of the time it _won't_ break."
