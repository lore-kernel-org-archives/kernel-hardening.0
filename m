MIME-Version: 1.0
In-Reply-To: <20180112075907.GA3391@kroah.com>
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151571803884.27429.7578279171286065970.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180112075907.GA3391@kroah.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 12 Jan 2018 10:47:44 -0800
Message-ID: <CAPcyv4js=KTb+eJjoc4_hjiJsiHr4EApJfxTjFfRBYx_CtuBKA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 10/19] ipv4: prevent bounds-check bypass via
 speculative execution
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Netdev <netdev@vger.kernel.org>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Elena Reshetova <elena.reshetova@intel.com>, Alan Cox <alan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 11, 2018 at 11:59 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, Jan 11, 2018 at 04:47:18PM -0800, Dan Williams wrote:
>> Static analysis reports that 'offset' may be a user controlled value
>> that is used as a data dependency reading from a raw_frag_vec buffer.
>> In order to avoid potential leaks of kernel memory values, block
>> speculative execution of the instruction stream that could issue further
>> reads based on an invalid '*(rfv->c + offset)' value.
>>
>> Based on an original patch by Elena Reshetova.
>
> There is the "Co-Developed-by:" tag now, if you want to use it...

Ok, thanks.

>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
>> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
>> Cc: netdev@vger.kernel.org
>> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  net/ipv4/raw.c |   10 ++++++----
>>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> Ugh, what is this, the 4th time I've said "I don't think this is an
> issue, so why are you changing this code." to this patch.  To be
> followed by a "oh yeah, you are right, I'll drop it", only to see it
> show back up in the next time this patch series is sent out?
>
> Same for the other patches in this series that I have reviewed 4, maybe
> 5, times already.  The "v2" is not very true here...

The theme of the review feedback on v1 was 'don't put ifence in any
net/ code', and that was addressed.

I honestly thought the new definition of array_ptr() changed the
calculus on this patch. Given the same pattern appears in the ipv6
case, and I have yet to hear that we should drop the ipv6 patch, make
the code symmetric just for readability purposes. Otherwise we need a
comment saying why this is safe for ipv4, but maybe not safe for ipv6,
I think 'array_ptr' is effectively that comment. I.e. 'array_ptr()' is
designed to be low impact for instrumenting false positives. If that
new argument does not hold water I will definitely drop this patch.
