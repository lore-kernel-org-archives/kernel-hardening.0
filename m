Date: Fri, 12 Jan 2018 08:59:07 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20180112075907.GA3391@kroah.com>
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151571803884.27429.7578279171286065970.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151571803884.27429.7578279171286065970.stgit@dwillia2-desk3.amr.corp.intel.com>
Subject: [kernel-hardening] Re: [PATCH v2 10/19] ipv4: prevent bounds-check bypass via
 speculative execution
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, akpm@linux-foundation.org, kernel-hardening@lists.openwall.com, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, netdev@vger.kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, tglx@linutronix.de, torvalds@linux-foundation.org, "David S. Miller" <davem@davemloft.net>, Elena Reshetova <elena.reshetova@intel.com>, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 11, 2018 at 04:47:18PM -0800, Dan Williams wrote:
> Static analysis reports that 'offset' may be a user controlled value
> that is used as a data dependency reading from a raw_frag_vec buffer.
> In order to avoid potential leaks of kernel memory values, block
> speculative execution of the instruction stream that could issue further
> reads based on an invalid '*(rfv->c + offset)' value.
> 
> Based on an original patch by Elena Reshetova.

There is the "Co-Developed-by:" tag now, if you want to use it...

> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  net/ipv4/raw.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)

Ugh, what is this, the 4th time I've said "I don't think this is an
issue, so why are you changing this code." to this patch.  To be
followed by a "oh yeah, you are right, I'll drop it", only to see it
show back up in the next time this patch series is sent out?

Same for the other patches in this series that I have reviewed 4, maybe
5, times already.  The "v2" is not very true here...

thanks,

greg k-h
