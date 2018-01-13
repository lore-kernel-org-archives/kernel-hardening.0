Date: Sat, 13 Jan 2018 09:56:35 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20180113085635.GA11640@kroah.com>
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151571803884.27429.7578279171286065970.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180112075907.GA3391@kroah.com>
 <CAPcyv4js=KTb+eJjoc4_hjiJsiHr4EApJfxTjFfRBYx_CtuBKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4js=KTb+eJjoc4_hjiJsiHr4EApJfxTjFfRBYx_CtuBKA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2 10/19] ipv4: prevent bounds-check bypass via
 speculative execution
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Netdev <netdev@vger.kernel.org>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Elena Reshetova <elena.reshetova@intel.com>, Alan Cox <alan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 12, 2018 at 10:47:44AM -0800, Dan Williams wrote:
> On Thu, Jan 11, 2018 at 11:59 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >> Cc: "David S. Miller" <davem@davemloft.net>
> >> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> >> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> >> Cc: netdev@vger.kernel.org
> >> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> >> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> >> ---
> >>  net/ipv4/raw.c |   10 ++++++----
> >>  1 file changed, 6 insertions(+), 4 deletions(-)
> >
> > Ugh, what is this, the 4th time I've said "I don't think this is an
> > issue, so why are you changing this code." to this patch.  To be
> > followed by a "oh yeah, you are right, I'll drop it", only to see it
> > show back up in the next time this patch series is sent out?
> >
> > Same for the other patches in this series that I have reviewed 4, maybe
> > 5, times already.  The "v2" is not very true here...
> 
> The theme of the review feedback on v1 was 'don't put ifence in any
> net/ code', and that was addressed.
> 
> I honestly thought the new definition of array_ptr() changed the
> calculus on this patch. Given the same pattern appears in the ipv6
> case, and I have yet to hear that we should drop the ipv6 patch, make
> the code symmetric just for readability purposes. Otherwise we need a
> comment saying why this is safe for ipv4, but maybe not safe for ipv6,
> I think 'array_ptr' is effectively that comment. I.e. 'array_ptr()' is
> designed to be low impact for instrumenting false positives. If that
> new argument does not hold water I will definitely drop this patch.

I also argued, again in an older review of this same patch series, that
the ipv6 patch should be dropped as well for this same exact reason.

I didn't think you wanted to hear me rant about the same thing on both
patches :)

greg k-h
