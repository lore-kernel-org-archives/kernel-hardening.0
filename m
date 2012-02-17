Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Fri, 17 Feb 2012 11:59:45 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20120217075945.GA2831@albatros>
References: <CAEXv5_gkTsPHDFh+wQqD3P3D-Z+uCN-_1bVyHfHV=u7bS-tgeA@mail.gmail.com>
 <20120216204515.GH20420@outflux.net>
 <20120217002405.GB7746@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217002405.GB7746@kroah.com>
Subject: Re: [kernel-hardening] Re: Add overflow protection to kref
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Ubuntu security discussion <ubuntu-hardened@lists.ubuntu.com>, linux-kernel@vger.kernel.org, David Windsor <dwindsor@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, pageexec@freemail.hu, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

> And in all that time, I've never seen an instance where you can overflow
> the reference count,

Do you mean that the overflow is theoretically impossible or that this
type of programmer error is rare?

If the former, it is only 2**32 incs - if you can find open() implementation
with a missing atomic_dec() in error path and you can call open() faster than
10000 times per second, you can overflow the counter in ~4 days.

If the latter, it is just a question of finding missing put() in some triggerable
error path.  Kees has already posted a link to a bug with a missing fput().


BTW, moving from atomic_t to 64 bit refcounter would kill the possibility of
overflow.  Unfortunately, AFAIU, 64 bit operations are not atomic on some 64 bit
archs.

Thanks,

-- 
Vasiliy
