References: <476DC76E7D1DF2438D32BFADF679FC562305B2AC@ORSMSX103.amr.corp.intel.com>
 <20170210195240.GA2243@kroah.com>
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Message-ID: <9315f31a-a3df-f7cf-b938-1ec28269f69a@m4x.org>
Date: Fri, 10 Feb 2017 22:53:56 +0100
MIME-Version: 1.0
In-Reply-To: <20170210195240.GA2243@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] %pK continuation
To: Greg KH <gregkh@linuxfoundation.org>, "Roberts, William C" <william.c.roberts@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 10/02/17 20:52, Greg KH wrote:
> On Fri, Feb 10, 2017 at 07:02:42PM +0000, Roberts, William C wrote:
>> I haven't had time to really work on the continuation of:
>> http://www.openwall.com/lists/kernel-hardening/2016/10/07/1
>>
>> I think the simple approach of killing %p based on kptr_restrict remains the simplest, IMHO best way to achieve a better level of
>> preventing leaks of kernel addresses. In example of %pK going wrong can be found here:
>>  https://googleprojectzero.blogspot.com/2017/02/lifting-hyper-visor-bypassing-samsungs.html.
>>
>> Granted, the exploit author would have found another way to defeat KASL, I'd like to force their hand.
>>
>> In a nut shell, the driver use %pk instead of %pK (capitalization of K matters).  This would actually be a
>> good checkpatch.pl check. I grep'd the kernel for %pk (lower case k) and found no usages!
> 
> %pk is not a valid kernel printk() modifier at all, so I sure hope you
> %would not find any usages :)

Actually such a format string was present in the kernel until commit
901d805c33fc ("UBSAN: fix typo in format string") (merged in 4.8). I
found it using a gcc plugin and I guess other people are performing
static analysis on the kernel code and report the bug they find. This
would better explain why it is quite difficult to find inconsistent
format strings today.

And this just reminded me that I sent some patches back in October to
fix some issues in drivers/isdn/hardware/eicon/ (e.g.
https://lkml.org/lkml/2016/10/29/140), and these patches have not been
applied because they needed more work. As my own free time to work on
the kernel is quite scarse, someone else on kernel-hardening@ might be
willing to take over these patches...

Regards,
Nicolas
