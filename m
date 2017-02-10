Date: Fri, 10 Feb 2017 20:52:40 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20170210195240.GA2243@kroah.com>
References: <476DC76E7D1DF2438D32BFADF679FC562305B2AC@ORSMSX103.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476DC76E7D1DF2438D32BFADF679FC562305B2AC@ORSMSX103.amr.corp.intel.com>
Subject: Re: [kernel-hardening] %pK continuation
To: "Roberts, William C" <william.c.roberts@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 10, 2017 at 07:02:42PM +0000, Roberts, William C wrote:
> I haven't had time to really work on the continuation of:
> http://www.openwall.com/lists/kernel-hardening/2016/10/07/1
> 
> I think the simple approach of killing %p based on kptr_restrict remains the simplest, IMHO best way to achieve a better level of
> preventing leaks of kernel addresses. In example of %pK going wrong can be found here:
>  https://googleprojectzero.blogspot.com/2017/02/lifting-hyper-visor-bypassing-samsungs.html.
> 
> Granted, the exploit author would have found another way to defeat KASL, I'd like to force their hand.
> 
> In a nut shell, the driver use %pk instead of %pK (capitalization of K matters).  This would actually be a
> good checkpatch.pl check. I grep'd the kernel for %pk (lower case k) and found no usages!

%pk is not a valid kernel printk() modifier at all, so I sure hope you
%would not find any usages :)

Documentation/printk-formats.txt is a good thing to check.

thanks,

greg k-h
